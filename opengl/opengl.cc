#ifdef __APPLE__
#define GL_SILENCE_DEPRECATION
#endif

// don't need glad on mac
//#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <OpenGl/gl3.h>
#include <stdio.h>

#include <string>
const int WIDTH = 500;
const int HEIGHT = WIDTH;

struct Window {
    GLFWwindow* window{};
    Window() {
        if (! glfwInit()) {
            puts("glfw init failure!");
            return;
        }

        glfwWindowHint(GLFW_RESIZABLE, false);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, true);

        if (window = glfwCreateWindow(WIDTH,HEIGHT, "OpenGL Triangle", nullptr, nullptr); !window){
            puts("window creation failure!");
            return;
        }
        glfwMakeContextCurrent(window);
        //if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
        //{
        //    puts("glad init failure!");
        //    return;
        //}
    }

    ~Window(){
        puts("shutting down!");
        glfwTerminate();
    }
};

int main() 
{
    Window w;
    auto window = w.window;

    // vertex buffer
    float vertices[] = {
        -0.5f, -0.5f, 0.0f, // left  
         0.5f, -0.5f, 0.0f, // right 
         0.0f,  0.5f, 0.0f  // top 
    };
    // VAO
    auto VAO = 0u;
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    auto VBO = 0u;
    glGenBuffers(1, &VBO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);

    glBufferData(GL_ARRAY_BUFFER, sizeof vertices, vertices, GL_STATIC_DRAW);
    // vertex buffer

    // shader

    auto vs_source = R"(
        #version 330 core
        layout (location = 0) in vec3 aPos;
        void main()
        {
            gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
        }
    )";

    auto vs_shader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vs_shader, 1, &vs_source, nullptr);
    glCompileShader(vs_shader);

    auto success = 0;
    std::string log;
    log.reserve(512);

    glGetShaderiv(vs_shader, GL_COMPILE_STATUS, &success);

    if (!success) {
        glGetShaderInfoLog(vs_shader, log.size(),nullptr, log.data());
        printf("Vertex shader compilation error: %s\n", log.data());
        return 1;
    }

    auto fs_source = R"(
        #version 330 core
        out vec4 FragColor;
        void main()
        {
            FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
        }
    )";

    auto fs_shader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fs_shader, 1, &fs_source, nullptr);
    glCompileShader(fs_shader);

    success = 0;
    log.clear();

    glGetShaderiv(fs_shader, GL_COMPILE_STATUS, &success);

    if (!success) {
        glGetShaderInfoLog(fs_shader, log.size(),nullptr, log.data());
        printf("Fragment shader compilation error: %s\n", log.data());
        return 1;
    }

    auto shader = glCreateProgram();
    glAttachShader(shader, vs_shader);
    glAttachShader(shader, fs_shader);
    glLinkProgram(shader);

    success = 0;
    log.clear();

    glGetProgramiv(shader, GL_LINK_STATUS, &success);

    if (!success) {
        glGetProgramInfoLog(shader, log.size(),nullptr, log.data());
        printf("Shader program link error: %s\n", log.data());
        return 1;
    }

    glDeleteShader(vs_shader);
    glDeleteShader(fs_shader);
    // shader

    // vertex attrib
    glVertexAttribPointer(0, 3, GL_FLOAT, false, 3 * sizeof(float), nullptr);
    glEnableVertexAttribArray(0);
    // use shader
    glUseProgram(shader);



    while (!glfwWindowShouldClose(window)) {
        if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
            glfwSetWindowShouldClose(window,true);

        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        // draw triangle
        glDrawArrays(GL_TRIANGLES, 0, 3);

        glfwSwapBuffers(window);
        glfwPollEvents();
    }
}