const c = @cImport({
    @cDefine("GL_SILENCE_DEPRECATION", "");
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

const std = @import("std");
const print = std.debug.print;
const WIDTH = 500;
const HEIGHT = WIDTH;
const TITLE = "OpenGL Triangle";

pub fn main() void {
    if ( c.glfwInit() == c.GLFW_FALSE ) {
        print("glfw init failed!\n", .{});
        return;
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_RESIZABLE, 0);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, 1);

    var window = c.glfwCreateWindow(WIDTH, HEIGHT, TITLE, null, null) orelse {
        print("window creation error!\n", .{});
        return;
    };

    c.glfwMakeContextCurrent(window);
    if ( c.gladLoadGLLoader(@ptrCast(c.GLADloadproc, c.glfwGetProcAddress)) == 0 ) {
        print("glad init failure\n", .{});
        return;
    }
    // vertex buffer
    const vertices = [_]f32{
        -0.5, -0.5, 0.0, // let  
         0.5, -0.5, 0.0, // right 
         0.0,  0.5, 0.0  // top
    };

    var vao :u32 = undefined;
    c.glGenVertexArrays(1, &vao);
    c.glBindVertexArray(vao);

    var vbo :u32 = undefined;
    c.glGenBuffers(1, &vbo);
    c.glBindBuffer(c.GL_ARRAY_BUFFER, vbo);
    c.glBufferData(c.GL_ARRAY_BUFFER, vertices.len*@sizeOf(f32), &vertices[0], c.GL_STATIC_DRAW);
    // vertex buffer
    // shader
    const vs_shader = c.glCreateShader(c.GL_VERTEX_SHADER);
    defer c.glDeleteShader(vs_shader);
    // const vs_ptr : ?[*]const u8 = vs_source.ptr;
    c.glShaderSource(vs_shader, 1, &vs_source, null);
    c.glCompileShader(vs_shader);

    var success: i32 = undefined;
    var log: [512]u8 = undefined;

    c.glGetShaderiv(vs_shader, c.GL_COMPILE_STATUS, &success);

    if (!intToBool(success) ) {
        c.glGetShaderInfoLog(vs_shader, log.len, null, &log[0]);
        print("vert shader error! {s}\n", .{log});
        return;
    }

    success = -1;
    std.mem.set(u8, log[0..], 0);

    const fs_shader = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    defer c.glDeleteShader(fs_shader);
    // const fs_ptr : ?[*]const u8 = fs_source.ptr;
    c.glShaderSource(fs_shader, 1, &fs_source, null);
    c.glCompileShader(fs_shader);

    c.glGetShaderiv(fs_shader, c.GL_COMPILE_STATUS, &success);

    if (!intToBool(success) ) {
        c.glGetShaderInfoLog(fs_shader, log.len, null, &log[0]);
        print("frag shader error! {s}\n", .{log});
        return;
    }

    const shader = c.glCreateProgram();
    c.glAttachShader(shader, vs_shader);
    c.glAttachShader(shader, fs_shader);
    c.glLinkProgram(shader);

    success = -1;
    std.mem.set(u8, log[0..], 0);

    c.glGetProgramiv(shader, c.GL_LINK_STATUS, &success);

    if ( !intToBool(success) ) {
        c.glGetProgramInfoLog(shader, log.len, null, &log[0]);
        print("shader program link error! {s}\n", .{log});
        return;
    }

    c.glVertexAttribPointer(0, 3, c.GL_FLOAT, 0, 3 * @sizeOf(f32), null);
    c.glEnableVertexAttribArray(0);

    c.glUseProgram(shader);
    // shader

    while ( c.glfwWindowShouldClose(window) != c.GLFW_TRUE ) {

        if ( c.glfwGetKey(window, c.GLFW_KEY_ESCAPE) == c.GLFW_PRESS ) 
            c.glfwSetWindowShouldClose(window, 1);
        
        c.glClearColor(0.2, 0.3, 0.3, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glDrawArrays(c.GL_TRIANGLES, 0, 3);

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }

}

fn intToBool(val: anytype) bool{
    return if ( val == 0 ) false else true;
}

const vs_source: [*c]const u8 = 
\\#version 330 core
\\layout (location = 0) in vec3 aPos;
\\void main()
\\{
\\    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
\\}
;

const fs_source: [*c]const u8 =
\\#version 330 core
\\out vec4 FragColor;
\\void main()
\\{
\\    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
\\}
;