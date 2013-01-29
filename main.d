private {
  import derelict.glfw3.glfw3;
  import derelict.opengl3.gl3;

  import std.exception : enforce;
  import std.file      : read;
  import std.stdio     : writefln;
  import std.string    : toStringz;
}

const auto title  = "Skeleton";
const auto width  = 800;
const auto height = 600;

bool running = true;

extern(C)
void onKeyPress(GLFWwindow* window, int key, int pressed) {
  if(!pressed)
    return;

  switch(key) {
  case GLFW_KEY_Q:
  case GLFW_KEY_ESCAPE:
    running = false;
    break;
  default:
    break;
  }
}

enum startGL = q{
  DerelictGL3.load();
  DerelictGLFW3.load();

  enforce(glfwInit());
  scope(exit)
    glfwTerminate();

  //Enable OpenGL 3.2 (especially for macs)
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  auto window = glfwCreateWindow(width, height, title.toStringz(), null, null);
  enforce(window);
  scope(exit)
    glfwDestroyWindow(window);

  glfwMakeContextCurrent(window);

  DerelictGL3.reload();
};

enum createShaders = q{
  int vshader = glCreateShader(GL_VERTEX_SHADER);
  int fshader = glCreateShader(GL_FRAGMENT_SHADER);

  char[] vsrc = cast(char[])read("shader.vert");
  char[] fsrc = cast(char[])read("shader.frag");

  auto vsrcptr = vsrc.ptr;
  auto fsrcptr = fsrc.ptr;
  auto vsrclen = cast(int)vsrc.length;
  auto fsrclen = cast(int)fsrc.length;

  glShaderSource(vshader, 1, &vsrcptr, &vsrclen);
  glShaderSource(fshader, 1, &fsrcptr, &fsrclen);

  glCompileShader(vshader);
  glCompileShader(fshader);

  int program = glCreateProgram();
  glAttachShader(program, vshader);
  glAttachShader(program, fshader);

  glLinkProgram(program);
  glUseProgram(program);

  if(glGetError() != GL_NO_ERROR)
    writefln("ERROR");
};

int main(string[] args) {
  mixin(startGL);
  mixin(createShaders);

  glfwSetKeyCallback(window, &onKeyPress);
  glViewport(0, 0, width, height);

  float[] square = [-0.5, -0.5, -0.5,
                    -0.5, -0.5,  0.5,
                     0.5,  0.5, -0.5,
                     0.5,  0.5,  0.5,
                    -0.5,  0.5, -0.5,
                    -0.5,  0.5,  0.5,
                     0.5, -0.5, -0.5,
                     0.5, -0.5,  0.5];

  ubyte[] squareIndices = [0, 6, 2, 0, 2, 4];

  // TODO: Create VAO and bind it.
  // TODO: Create VBO to attach it to the VAO

  while(running) {
    glClear(GL_COLOR_BUFFER_BIT);

    // TODO: Bind the VAO
    // TODO: Bind the index VBO
    // TODO: Render on screen

    glfwSwapBuffers(window);
    glfwPollEvents();
  }

  return 0;
}