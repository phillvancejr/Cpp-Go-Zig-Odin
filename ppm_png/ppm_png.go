package main

import (
	"fmt"
	"image"
	"image/color"
	"image/png"
	"os"
)

const (
	width      = 20
	height     = width
	components = 3
)

type Pixels [width * height * 3]byte

var pixels Pixels

// implement image.Image
/*
Could have also used image.Image instead of raw pixel buffer
get one from image.NewRGBA(image.Rect(0,0,width,height))
then access pixels with

my_image.Pix[0]
my_image.Pix[1]
my_image.Pix[2]
my_image.Pix[3]

This can be passed to encode
*/
func (p Pixels) ColorModel() color.Model {
	return color.RGBAModel
}

func (p Pixels) Bounds() image.Rectangle {
	return image.Rect(0, 0, width, height)
}

func (p Pixels) At(x, y int) color.Color {
	x *= components // NOTE X MUST BE SCALED BY COMPONENTS
	r := p[y*width*components+x]
	g := p[y*width*components+x+1]
	b := p[y*width*components+x+2]
	return color.RGBA{r, g, b, 255}
}

func main() {
	// write checker pattern
	for y := 0; y < height; y += 1 {
		for x := 0; x < width*components; x += components {
			scaled_x := x / 3
			// white
			color := byte(255)
			if scaled_x < width/2 {
				if y < height/2 {
					color = 255
				} else {
					color = 0
				}

			} else {
				if y < height/2 {
					color = 0
				} else {
					color = 255
				}
			}
			pixels[y*width*components+x] = color
			pixels[y*width*components+x+1] = color
			pixels[y*width*components+x+2] = color
		}
	}

	ppm, e := os.Create("ppm_png/out.ppm")
	if e != nil {
		panic("could not open file")
	}
	defer ppm.Close()

	fmt.Fprintf(ppm, "P3\n%d %d\n255\n", width, height)

	for y := 0; y < height; y += 1 {
		for x := 0; x < width*components; x += components {
			r := pixels[y*width*components+x]
			g := pixels[y*width*components+x+1]
			b := pixels[y*width*components+x+2]

			fmt.Fprintf(ppm, "%d %d %d\n", r, g, b)
		}
	}

	png_file, e := os.Create("ppm_png/out_test.png")
	if e != nil {
		panic("could not create png")
	}

	defer png_file.Close()
	e = png.Encode(png_file, pixels)

	if e != nil {
		panic(e)
	}

	// print pixels to console
	print_pixels(true)
}

func print_pixels(ansi bool) {
	for y := 0; y < height; y += 1 {
		for x := 0; x < width*components; x += components {
			r := pixels[y*width*components+x]
			g := pixels[y*width*components+x+1]
			b := pixels[y*width*components+x+2]

			if ansi {
				// white
				color := "\x1b[97m"
				// black/dark gray
				if r == 0 {
					color = "\x1b[30m"
				}
				fmt.Printf("%s\u2588\u2588\u2588", color)

			} else {
				// if not using ansi just print text representation
				if r == 255 {
					fmt.Printf("%d%d%d", r, g, b)
				} else {
					fmt.Print("000000000")
				}
			}
		}
		fmt.Println("\x1b[0m")
	}
}
