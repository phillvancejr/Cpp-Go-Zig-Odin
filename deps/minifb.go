//go:build !wasm
// +build !wasm

package main

/*
#cgo CFLAGS: -Ideps/minifb/include
#cgo darwin LDFLAGS: -Ldeps/mac -lminifb
#cgo darwin LDFLAGS: -framework MetalKit -framework Metal -framework Cocoa
#include <MiniFB.h>
#include <stdlib.h>

// callback exported from Go
extern void Keyboard(struct mfb_window*, mfb_key, mfb_key_mod, bool);
*/
import "C"
import (
	"errors"
	"image/color"
	"runtime"
	"time"
	"unsafe"
)

var window *C.struct_mfb_window

// convenience slice to work with the C buffer
var pixels []C.uint
var buffer *C.uint

// This implements the Drawer Interface
type MiniFB struct{}

// draws a filled rectangle at x,y with size w,h
func (MiniFB) fill_rect(x, y, w, h int, c color.RGBA) {
	for _y := y; _y < y+h; _y++ {
		for _x := x; _x < x+w; _x++ {
			pixels[_y*width+_x] = value(c)
		}
	}
}

// clears the screen to a color
func (MiniFB) clear_screen(c color.RGBA) {
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			pixels[y*width+x] = value(c)
		}
	}
}

// helper function to convert a image/color to a C.uint used by minifb's buffer
func value(c color.RGBA) C.uint {
	return C.uint((int(c.R) << 16) | (int(c.G) << 8) | int(c.B))
}

func create_window(title string, w, h int) error {
	ctitle := C.CString(title)
	cw := C.uint(w)
	ch := C.uint(h)

	// ctitle, window and buffer are all dynamically allocated by C so we could free them, but they live for the entirety of the program so I didn't bother
	// title, width, height, flags
	window = C.mfb_open_ex(ctitle, cw, ch, 0)
	if window == nil {
		return errors.New("Could not create window!")
	}

	// allocate pixel buffer
	buffer_len := w * h * 4

	buffer = (*C.uint)(C.malloc(C.ulong(buffer_len)))

	if buffer == nil {
		return errors.New("Could not create buffer!")
	}
	// create the convenience slice to work with the C buffer
	pixels = unsafe.Slice((*C.uint)(buffer), buffer_len)
	return nil
}

// Don't google passing go callbacks to cgo, its a complicated mess
// just export the function from Go, then pass it to the C function as if it were a C callback
//export Keyboard
func Keyboard(window *C.struct_mfb_window, key C.mfb_key, mod C.mfb_key_mod, isPressed C.bool) {
	in_key := none

	switch key {
	case C.KB_KEY_ESCAPE:
		in_key = esc
	case C.KB_KEY_LEFT:
		in_key = left
	case C.KB_KEY_UP:
		in_key = up
	case C.KB_KEY_RIGHT:
		in_key = right
	case C.KB_KEY_DOWN:
		in_key = down
	}

	input(in_key, bool(isPressed))
}

func main() {
	runtime.LockOSThread()
	// setup drawing api
	drawer = MiniFB{}

	e := create_window(title, width, height)

	if e != nil {
		panic(e)
	}

	// setup keyboard handler
	// notice that I pass the C.Keyboard callback here casted to the C.mfb_keyboard_func type
	// C.Keyboard is a C function but it was implemented in Go, this is the easiest way to pass go callbacks to C
	C.mfb_set_keyboard_callback(window, (C.mfb_keyboard_func)(C.Keyboard))

	// last time in ms
	last_time := time.Now().UnixNano() / 1000000
	// this is the minifb loop
	for C.mfb_wait_sync(window) {

		// calculate delta time
		now := time.Now().UnixNano() / 1000000
		delta := float64(now-last_time) / 1000.0
		last_time = now

		// this will be set to false if the esc key is pressed
		if !running {
			C.mfb_close(window)
			break
		}
		// call game functions
		update(delta)
		draw()

		// minifb stuff
		state := C.mfb_update_ex(window, unsafe.Pointer(buffer), width, height)
		if state < 0 {
			break
		}
	}
}
