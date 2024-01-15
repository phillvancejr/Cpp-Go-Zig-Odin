package main

/*
#cgo CFLAGS: -I../deps/glfw
#cgo darwin LDFLAGS: -L../deps/glfw/mac -lglfw3-arm -framework Cocoa -framework IOKit -framework OpenGL
#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>

#ifdef __APPLE__
#define GL_SILENCE_DEPRECATION
#include <OpenGL/gl3.h>
#endif

#include <stdlib.h> // free
*/
import "C"
import (
	"fmt"
	"runtime"
	"unsafe"
	// _"strings"
)

const (
	WIDTH = 500
	HEIGHT = WIDTH
	TITLE = "OpenGL Triangle"
)

var (
	vs_shader =`
		#version 330 core
		layout (location = 0) in vec3 aPos;
		void main()
		{
			gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
		}
	`
	fs_shader = `
		#version 330 core
		out vec4 FragColor;
		void main()
		{
			FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
		}`
)

func main() {
	runtime.LockOSThread()

	if C.glfwInit() != 1 {
		panic("glfw init error")
	}

	defer C.glfwTerminate()

	C.glfwWindowHint(C.GLFW_RESIZABLE, 0)
	C.glfwWindowHint(C.GLFW_CONTEXT_VERSION_MAJOR, 3)
	C.glfwWindowHint(C.GLFW_CONTEXT_VERSION_MINOR, 3)
	C.glfwWindowHint(C.GLFW_OPENGL_PROFILE, C.GLFW_OPENGL_CORE_PROFILE)
	C.glfwWindowHint(C.GLFW_OPENGL_FORWARD_COMPAT, 1)

	ctitle := C.CString(TITLE)
	defer C.free(unsafe.Pointer(ctitle))

	window := C.glfwCreateWindow(WIDTH, HEIGHT, ctitle, nil, nil)
	if window == nil {
		panic("window creation failure")
	}

	C.glfwMakeContextCurrent(window)


	// vertex buffer
	vertices := []C.float{
		-0.5, -0.5, 0.0, // left  
		0.5, -0.5, 0.0, // right 
		0.0,  0.5, 0.0,  // top 
	}

	var vao C.uint
	C.glGenVertexArrays(1, &vao)
	C.glBindVertexArray(vao)

	sizeofVertices := C.long(len(vertices) * int(unsafe.Sizeof(C.float(0))))
	fmt.Println("SIZE OF:", sizeofVertices)

	var vbo C.uint
	C.glGenBuffers(1, &vbo)
	C.glBindBuffer(C.GL_ARRAY_BUFFER, vbo)
	C.glBufferData(C.GL_ARRAY_BUFFER, sizeofVertices, unsafe.Pointer(&vertices[0]), C.GL_STATIC_DRAW)
	// vertex buffer

	// shader
	shader, e := newProgram(vs_shader, fs_shader)

	if e != nil {
		panic(e)
	}

	C.glUseProgram(shader)

	C.glVertexAttribPointer(0, 3, C.GL_FLOAT, 0, C.int(3 * unsafe.Sizeof(C.float(0))), nil)
	C.glEnableVertexAttribArray(0)

	for C.glfwWindowShouldClose(window) != 1 {
		if C.glfwGetKey(window, C.GLFW_KEY_ESCAPE) == C.GLFW_PRESS {
			C.glfwSetWindowShouldClose(window, 1)
		}

		C.glClearColor(0.2, 0.3, 0.3, 1.0)
		C.glClear(C.GL_COLOR_BUFFER_BIT)

		C.glDrawArrays(C.GL_TRIANGLES, 0, 3)

		C.glfwSwapBuffers(window)
		C.glfwPollEvents()
	}

}

func newProgram(vertexShaderSource, fragmentShaderSource string) (C.uint, error) {
	vertexShader, err := compileShader(vertexShaderSource, C.GL_VERTEX_SHADER)
	if err != nil {
		return 0, err
	}

	fragmentShader, err := compileShader(fragmentShaderSource, C.GL_FRAGMENT_SHADER)
	if err != nil {
		return 0, err
	}

	program := C.glCreateProgram()

	C.glAttachShader(program, vertexShader)
	C.glAttachShader(program, fragmentShader)
	C.glLinkProgram(program)

	var status C.int

	C.glGetProgramiv(program, C.GL_LINK_STATUS, &status)

	if status != 1 {

		var clog [128]C.char

		C.glGetProgramInfoLog(program, C.int(len(clog)), nil, (*C.char)(unsafe.Pointer(&clog[0])))		

		log := C.GoString((*C.char)(unsafe.Pointer(&clog[0])))

		return 0, fmt.Errorf("failed to link program: %v", log)
	}

	C.glDeleteShader(vertexShader)
	C.glDeleteShader(fragmentShader)

	return program, nil
}

func compileShader(source string, shaderType C.uint) (C.uint, error) {
	shader := C.glCreateShader(shaderType)

	csource := C.CString(source)
	defer C.free(unsafe.Pointer(csource))

	C.glShaderSource(shader, 1, &csource, nil)
	C.glCompileShader(shader)

	var status C.int

	C.glGetShaderiv(shader, C.GL_COMPILE_STATUS, &status)

	if status != 1 {

		var clog [128]C.char

		C.glGetShaderInfoLog(shader, C.int(len(clog)), nil, (*C.char)(unsafe.Pointer(&clog[0])))		

		log := C.GoString((*C.char)(unsafe.Pointer(&clog[0])))

		return 0, fmt.Errorf("failed to compile %v shader: %v", shaderName(shaderType), log)
	}

	return shader, nil
}

func shaderName(t C.uint) string {
	var name string	

	if t == C.GL_VERTEX_SHADER {
		name = "Vertex"
	} else {
		name = "Fragment"
	}

	return name
}
