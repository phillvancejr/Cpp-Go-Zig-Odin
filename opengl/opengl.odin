package main

import "core:fmt"
import "vendor:glfw"
import gl "vendor:OpenGL"

WIDTH   :: 500
HEIGHT  :: WIDTH
TITLE   :: "OpenGL Triangle"

main :: proc() {
    glfw.Init()
    defer glfw.Terminate()

    glfw.WindowHint(glfw.RESIZABLE, 0)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, 1)

    window := glfw.CreateWindow(WIDTH, HEIGHT, TITLE, nil, nil)

    if window == nil {
        fmt.println("window creation failure")
        return
    }

    glfw.MakeContextCurrent(window)
    gl.load_up_to(3,3, glfw.gl_set_proc_address)

    // vertex buffer
    vertices := [?]f32{
        -0.5, -0.5, 0.0, // left  
         0.5, -0.5, 0.0, // right 
         0.0,  0.5, 0.0,  // top 
    }

    vao :u32
    gl.GenVertexArrays(1, &vao)
    gl.BindVertexArray(vao)

    vbo :u32
    gl.GenBuffers(1, &vbo)
    gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
    gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), &vertices[0], gl.STATIC_DRAW)

    // vertex buffer

    // shaders
    program, ok := gl.load_shaders_source(vs_source, fs_source) 
    if !ok {
        msg, shader_type := gl.get_last_error_message()
        fmt.printf("Shader program creation error! %s %v\n", msg, shader_type )
        return
    }

    gl.VertexAttribPointer(0, 3, gl.FLOAT, false, 3 * size_of(f32), cast(uintptr)0)
    gl.EnableVertexAttribArray(0)
    gl.UseProgram(program)



    // shaders
    for !glfw.WindowShouldClose(window) {
        if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS do glfw.SetWindowShouldClose(window, true)

        gl.ClearColor(0.2, 0.3, 0.3, 1.0)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        gl.DrawArrays(gl.TRIANGLES, 0, 3)

        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }
}

vs_source :: `
    #version 330 core
    layout (location = 0) in vec3 aPos;
    void main()
    {
        gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
    }`

fs_source :: `
    #version 330 core
    out vec4 FragColor;
    void main()
    {
        FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
    }`