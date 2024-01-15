// The Swift Programming Language
// https://docs.swift.org/swift-book
//import GLFW
import GLFW
import GLKit

let width = 500
let height = width

main()

func main() {
    if glfwInit() != GL_TRUE {
        print("glfw init failure!")
        return
    }
    defer { print("shutting down!"); glfwTerminate() }


    glfwWindowHint(GLFW_RESIZABLE, 0)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, 1);

    guard let window = glfwCreateWindow(Int32(width), Int32(height), "OpenGL Triangle Swift", nil, nil) else {
        print("could not creat window")
        return
    }

    glfwMakeContextCurrent(window)

    var vertices: [Float32] = [
        -0.5, -0.5, 0.0, // left  
         0.5, -0.5, 0.0, // right 
         0.0,  0.5, 0.0  // top 
    ]

    var vao = UInt32(0)
    glGenVertexArrays(1, &vao)
    glBindVertexArray(vao)

    var vbo = UInt32(0)
    glGenBuffers(1, &vbo)

    glBindBuffer(UInt32(GL_ARRAY_BUFFER), vbo)

    glBufferData(UInt32(GL_ARRAY_BUFFER), vertices.count * MemoryLayout<Float32>.size, &vertices, UInt32(GL_STATIC_DRAW))

    // shader
    var vs_src = ("""
    #version 330 core
    layout (location = 0) in vec3 pos;
    void main() {
        gl_Position = vec4(pos, 1.0);
    }
    """ as NSString).utf8String
    var fs_src = ("""
    #version 330 core 
    out vec4 FragColor;
    void main() {
        FragColor = vec4(1.0, 0.5, 0.2, 1.0);
    }
    """ as NSString).utf8String

    let vs = glCreateShader(UInt32(GL_VERTEX_SHADER))
    let fs = glCreateShader(UInt32(GL_FRAGMENT_SHADER))
    glShaderSource(vs, 1, &vs_src, nil)
    glShaderSource(fs, 1, &fs_src, nil)
    glCompileShader(vs)
    glCompileShader(fs)

    var success = UInt32(0)
    glGetShaderiv(vs, UInt32(GL_COMPILE_STATUS), &success)
    var log = [CChar](repeating: CChar(0), count: 512)

    if success != GL_TRUE {
        glGetShaderInfoLog(vs, Int32(log.capacity), nil, &log)
        print("VERTEX SHADER ERROR:\n", String(utf8String: log)!) 
        return
    }

    success = 0
    glGetShaderiv(fs, UInt32(GL_COMPILE_STATUS), &success)
    // reset log
    log = log.map { _ in CChar(0) }

    if success != GL_TRUE {
        glGetShaderInfoLog(fs, Int32(log.capacity), nil, &log)
        print("FRAGMENT SHADER ERROR:\n", String(utf8String: log)!) 
        return
    }


    let program = glCreateProgram()
    glAttachShader(program, vs)
    glAttachShader(program, fs)
    glLinkProgram(program)

    success = 0
    log = log.map { _ in CChar(0) }

    glGetProgramiv(program, UInt32(GL_LINK_STATUS), &success)

    if success != GL_TRUE {
        glGetProgramInfoLog(program, Int32(log.capacity), nil, &log)
        print("SHADER PROGRAM ERROR:\n", String(utf8String: log)!)
        return
    }

    glDeleteShader(vs)
    glDeleteShader(fs)

    glUseProgram(program)

    glVertexAttribPointer(0, 3, UInt32(GL_FLOAT), 0, Int32(3 * MemoryLayout<Float>.size), nil)
    glEnableVertexAttribArray(0)

    while (glfwWindowShouldClose(window) == 0) {
        if glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS {
            glfwSetWindowShouldClose(window,1)
        }
        glClearColor(0.2, 0.3, 0.3, 1.0)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))

        glDrawArrays(UInt32(GL_TRIANGLES), 0, 3)

        glfwSwapBuffers(window)
        glfwPollEvents()
    }

}



