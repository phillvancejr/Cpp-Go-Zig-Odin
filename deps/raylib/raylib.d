import core.stdc.config;
import core.stdc.stdarg;

extern (C):

alias va_list = __va_list_tag[1];
alias __gnuc_va_list = __va_list_tag[1];

struct Vector2
{
    float x;
    float y;
}

struct Vector3
{
    float x;
    float y;
    float z;
}

struct Vector4
{
    float x;
    float y;
    float z;
    float w;
}

alias Quaternion = Vector4;

struct Matrix
{
    float m0;
    float m4;
    float m8;
    float m12;
    float m1;
    float m5;
    float m9;
    float m13;
    float m2;
    float m6;
    float m10;
    float m14;
    float m3;
    float m7;
    float m11;
    float m15;
}

struct Color
{
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;
}

// predefined colors
enum LIGHTGRAY  = Color( 200, 200, 200, 255 );   // Light Gray
enum GRAY       = Color( 130, 130, 130, 255 );   // Gray
enum DARKGRAY   = Color( 80, 80, 80, 255   );   // Dark Gray
enum YELLOW     = Color( 253, 249, 0, 255  );   // Yellow
enum GOLD       = Color( 255, 203, 0, 255  );   // Gold
enum ORANGE     = Color( 255, 161, 0, 255  );   // Orange
enum PINK       = Color( 255, 109, 194, 255 );   // Pink
enum RED        = Color( 230, 41, 55, 255  );   // Red
enum MAROON     = Color( 190, 33, 55, 255  );   // Maroon
enum GREEN      = Color( 0, 228, 48, 255   );   // Green
enum LIME       = Color( 0, 158, 47, 255   );   // Lime
enum DARKGREEN  = Color( 0, 117, 44, 255   );   // Dark Green
enum SKYBLUE    = Color( 102, 191, 255, 255 );   // Sky Blue
enum BLUE       = Color( 0, 121, 241, 255  );   // Blue
enum DARKBLUE   = Color( 0, 82, 172, 255   );   // Dark Blue
enum PURPLE     = Color( 200, 122, 255, 255 );   // Purple
enum VIOLET     = Color( 135, 60, 190, 255 );   // Violet
enum DARKPURPLE = Color( 112, 31, 126, 255 );   // Dark Purple
enum BEIGE      = Color( 211, 176, 131, 255 );   // Beige
enum BROWN      = Color( 127, 106, 79, 255 );   // Brown
enum DARKBROWN  = Color( 76, 63, 47, 255   );   // Dark Brown
enum WHITE      = Color( 255, 255, 255, 255 );   // White
enum BLACK      = Color( 0, 0, 0, 255      );   // Black
enum BLANK      = Color( 0, 0, 0, 0        );   // Blank (Transparent)
enum MAGENTA    = Color( 255, 0, 255, 255  );   // Magenta
enum RAYWHITE   = Color( 245, 245, 245, 255 );   // My own White (raylib logo)

// predefined colors

struct Rectangle
{
    float x;
    float y;
    float width;
    float height;
}

struct Image
{
    void* data;
    int width;
    int height;
    int mipmaps;
    int format;
}

struct Texture
{
    uint id;
    int width;
    int height;
    int mipmaps;
    int format;
}

alias Texture2D = Texture;

alias TextureCubemap = Texture;

struct RenderTexture
{
    uint id;
    Texture texture;
    Texture depth;
}

alias RenderTexture2D = RenderTexture;

struct NPatchInfo
{
    Rectangle source;
    int left;
    int top;
    int right;
    int bottom;
    int layout;
}

struct GlyphInfo
{
    int value;
    int offsetX;
    int offsetY;
    int advanceX;
    Image image;
}

struct Font
{
    int baseSize;
    int glyphCount;
    int glyphPadding;
    Texture2D texture;
    Rectangle* recs;
    GlyphInfo* glyphs;
}

struct Camera3D
{
    Vector3 position;
    Vector3 target;
    Vector3 up;
    float fovy;
    int projection;
}

alias Camera = Camera3D;

struct Camera2D
{
    Vector2 offset;
    Vector2 target;
    float rotation;
    float zoom;
}

struct Mesh
{
    int vertexCount;
    int triangleCount;

    float* vertices;
    float* texcoords;
    float* texcoords2;
    float* normals;
    float* tangents;
    ubyte* colors;
    ushort* indices;

    float* animVertices;
    float* animNormals;
    ubyte* boneIds;
    float* boneWeights;

    uint vaoId;
    uint* vboId;
}

struct Shader
{
    uint id;
    int* locs;
}

struct MaterialMap
{
    Texture2D texture;
    Color color;
    float value;
}

struct Material
{
    Shader shader;
    MaterialMap* maps;
    float[4] params;
}

struct Transform
{
    Vector3 translation;
    Quaternion rotation;
    Vector3 scale;
}

struct BoneInfo
{
    char[32] name;
    int parent;
}

struct Model
{
    Matrix transform;

    int meshCount;
    int materialCount;
    Mesh* meshes;
    Material* materials;
    int* meshMaterial;

    int boneCount;
    BoneInfo* bones;
    Transform* bindPose;
}

struct ModelAnimation
{
    int boneCount;
    int frameCount;
    BoneInfo* bones;
    Transform** framePoses;
}

struct Ray
{
    Vector3 position;
    Vector3 direction;
}

struct RayCollision
{
    bool hit;
    float distance;
    Vector3 point;
    Vector3 normal;
}

struct BoundingBox
{
    Vector3 min;
    Vector3 max;
}

struct Wave
{
    uint frameCount;
    uint sampleRate;
    uint sampleSize;
    uint channels;
    void* data;
}

struct rAudioBuffer;

struct AudioStream
{
    rAudioBuffer* buffer;

    uint sampleRate;
    uint sampleSize;
    uint channels;
}

struct Sound
{
    AudioStream stream;
    uint frameCount;
}

struct Music
{
    AudioStream stream;
    uint frameCount;
    bool looping;

    int ctxType;
    void* ctxData;
}

struct VrDeviceInfo
{
    int hResolution;
    int vResolution;
    float hScreenSize;
    float vScreenSize;
    float vScreenCenter;
    float eyeToScreenDistance;
    float lensSeparationDistance;
    float interpupillaryDistance;
    float[4] lensDistortionValues;
    float[4] chromaAbCorrection;
}

struct VrStereoConfig
{
    Matrix[2] projection;
    Matrix[2] viewOffset;
    float[2] leftLensCenter;
    float[2] rightLensCenter;
    float[2] leftScreenCenter;
    float[2] rightScreenCenter;
    float[2] scale;
    float[2] scaleIn;
}

enum ConfigFlags
{
    FLAG_VSYNC_HINT = 0x00000040,
    FLAG_FULLSCREEN_MODE = 0x00000002,
    FLAG_WINDOW_RESIZABLE = 0x00000004,
    FLAG_WINDOW_UNDECORATED = 0x00000008,
    FLAG_WINDOW_HIDDEN = 0x00000080,
    FLAG_WINDOW_MINIMIZED = 0x00000200,
    FLAG_WINDOW_MAXIMIZED = 0x00000400,
    FLAG_WINDOW_UNFOCUSED = 0x00000800,
    FLAG_WINDOW_TOPMOST = 0x00001000,
    FLAG_WINDOW_ALWAYS_RUN = 0x00000100,
    FLAG_WINDOW_TRANSPARENT = 0x00000010,
    FLAG_WINDOW_HIGHDPI = 0x00002000,
    FLAG_MSAA_4X_HINT = 0x00000020,
    FLAG_INTERLACED_HINT = 0x00010000
}

enum TraceLogLevel
{
    LOG_ALL = 0,
    LOG_TRACE = 1,
    LOG_DEBUG = 2,
    LOG_INFO = 3,
    LOG_WARNING = 4,
    LOG_ERROR = 5,
    LOG_FATAL = 6,
    LOG_NONE = 7
}

enum KeyboardKey
{
    KEY_NULL = 0,

    KEY_APOSTROPHE = 39,
    KEY_COMMA = 44,
    KEY_MINUS = 45,
    KEY_PERIOD = 46,
    KEY_SLASH = 47,
    KEY_ZERO = 48,
    KEY_ONE = 49,
    KEY_TWO = 50,
    KEY_THREE = 51,
    KEY_FOUR = 52,
    KEY_FIVE = 53,
    KEY_SIX = 54,
    KEY_SEVEN = 55,
    KEY_EIGHT = 56,
    KEY_NINE = 57,
    KEY_SEMICOLON = 59,
    KEY_EQUAL = 61,
    KEY_A = 65,
    KEY_B = 66,
    KEY_C = 67,
    KEY_D = 68,
    KEY_E = 69,
    KEY_F = 70,
    KEY_G = 71,
    KEY_H = 72,
    KEY_I = 73,
    KEY_J = 74,
    KEY_K = 75,
    KEY_L = 76,
    KEY_M = 77,
    KEY_N = 78,
    KEY_O = 79,
    KEY_P = 80,
    KEY_Q = 81,
    KEY_R = 82,
    KEY_S = 83,
    KEY_T = 84,
    KEY_U = 85,
    KEY_V = 86,
    KEY_W = 87,
    KEY_X = 88,
    KEY_Y = 89,
    KEY_Z = 90,
    KEY_LEFT_BRACKET = 91,
    KEY_BACKSLASH = 92,
    KEY_RIGHT_BRACKET = 93,
    KEY_GRAVE = 96,

    KEY_SPACE = 32,
    KEY_ESCAPE = 256,
    KEY_ENTER = 257,
    KEY_TAB = 258,
    KEY_BACKSPACE = 259,
    KEY_INSERT = 260,
    KEY_DELETE = 261,
    KEY_RIGHT = 262,
    KEY_LEFT = 263,
    KEY_DOWN = 264,
    KEY_UP = 265,
    KEY_PAGE_UP = 266,
    KEY_PAGE_DOWN = 267,
    KEY_HOME = 268,
    KEY_END = 269,
    KEY_CAPS_LOCK = 280,
    KEY_SCROLL_LOCK = 281,
    KEY_NUM_LOCK = 282,
    KEY_PRINT_SCREEN = 283,
    KEY_PAUSE = 284,
    KEY_F1 = 290,
    KEY_F2 = 291,
    KEY_F3 = 292,
    KEY_F4 = 293,
    KEY_F5 = 294,
    KEY_F6 = 295,
    KEY_F7 = 296,
    KEY_F8 = 297,
    KEY_F9 = 298,
    KEY_F10 = 299,
    KEY_F11 = 300,
    KEY_F12 = 301,
    KEY_LEFT_SHIFT = 340,
    KEY_LEFT_CONTROL = 341,
    KEY_LEFT_ALT = 342,
    KEY_LEFT_SUPER = 343,
    KEY_RIGHT_SHIFT = 344,
    KEY_RIGHT_CONTROL = 345,
    KEY_RIGHT_ALT = 346,
    KEY_RIGHT_SUPER = 347,
    KEY_KB_MENU = 348,

    KEY_KP_0 = 320,
    KEY_KP_1 = 321,
    KEY_KP_2 = 322,
    KEY_KP_3 = 323,
    KEY_KP_4 = 324,
    KEY_KP_5 = 325,
    KEY_KP_6 = 326,
    KEY_KP_7 = 327,
    KEY_KP_8 = 328,
    KEY_KP_9 = 329,
    KEY_KP_DECIMAL = 330,
    KEY_KP_DIVIDE = 331,
    KEY_KP_MULTIPLY = 332,
    KEY_KP_SUBTRACT = 333,
    KEY_KP_ADD = 334,
    KEY_KP_ENTER = 335,
    KEY_KP_EQUAL = 336,

    KEY_BACK = 4,
    KEY_MENU = 82,
    KEY_VOLUME_UP = 24,
    KEY_VOLUME_DOWN = 25
}

enum MouseButton
{
    MOUSE_BUTTON_LEFT = 0,
    MOUSE_BUTTON_RIGHT = 1,
    MOUSE_BUTTON_MIDDLE = 2,
    MOUSE_BUTTON_SIDE = 3,
    MOUSE_BUTTON_EXTRA = 4,
    MOUSE_BUTTON_FORWARD = 5,
    MOUSE_BUTTON_BACK = 6
}

enum MouseCursor
{
    MOUSE_CURSOR_DEFAULT = 0,
    MOUSE_CURSOR_ARROW = 1,
    MOUSE_CURSOR_IBEAM = 2,
    MOUSE_CURSOR_CROSSHAIR = 3,
    MOUSE_CURSOR_POINTING_HAND = 4,
    MOUSE_CURSOR_RESIZE_EW = 5,
    MOUSE_CURSOR_RESIZE_NS = 6,
    MOUSE_CURSOR_RESIZE_NWSE = 7,
    MOUSE_CURSOR_RESIZE_NESW = 8,
    MOUSE_CURSOR_RESIZE_ALL = 9,
    MOUSE_CURSOR_NOT_ALLOWED = 10
}

enum GamepadButton
{
    GAMEPAD_BUTTON_UNKNOWN = 0,
    GAMEPAD_BUTTON_LEFT_FACE_UP = 1,
    GAMEPAD_BUTTON_LEFT_FACE_RIGHT = 2,
    GAMEPAD_BUTTON_LEFT_FACE_DOWN = 3,
    GAMEPAD_BUTTON_LEFT_FACE_LEFT = 4,
    GAMEPAD_BUTTON_RIGHT_FACE_UP = 5,
    GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = 6,
    GAMEPAD_BUTTON_RIGHT_FACE_DOWN = 7,
    GAMEPAD_BUTTON_RIGHT_FACE_LEFT = 8,
    GAMEPAD_BUTTON_LEFT_TRIGGER_1 = 9,
    GAMEPAD_BUTTON_LEFT_TRIGGER_2 = 10,
    GAMEPAD_BUTTON_RIGHT_TRIGGER_1 = 11,
    GAMEPAD_BUTTON_RIGHT_TRIGGER_2 = 12,
    GAMEPAD_BUTTON_MIDDLE_LEFT = 13,
    GAMEPAD_BUTTON_MIDDLE = 14,
    GAMEPAD_BUTTON_MIDDLE_RIGHT = 15,
    GAMEPAD_BUTTON_LEFT_THUMB = 16,
    GAMEPAD_BUTTON_RIGHT_THUMB = 17
}

enum GamepadAxis
{
    GAMEPAD_AXIS_LEFT_X = 0,
    GAMEPAD_AXIS_LEFT_Y = 1,
    GAMEPAD_AXIS_RIGHT_X = 2,
    GAMEPAD_AXIS_RIGHT_Y = 3,
    GAMEPAD_AXIS_LEFT_TRIGGER = 4,
    GAMEPAD_AXIS_RIGHT_TRIGGER = 5
}

enum MaterialMapIndex
{
    MATERIAL_MAP_ALBEDO = 0,
    MATERIAL_MAP_METALNESS = 1,
    MATERIAL_MAP_NORMAL = 2,
    MATERIAL_MAP_ROUGHNESS = 3,
    MATERIAL_MAP_OCCLUSION = 4,
    MATERIAL_MAP_EMISSION = 5,
    MATERIAL_MAP_HEIGHT = 6,
    MATERIAL_MAP_CUBEMAP = 7,
    MATERIAL_MAP_IRRADIANCE = 8,
    MATERIAL_MAP_PREFILTER = 9,
    MATERIAL_MAP_BRDF = 10
}

enum ShaderLocationIndex
{
    SHADER_LOC_VERTEX_POSITION = 0,
    SHADER_LOC_VERTEX_TEXCOORD01 = 1,
    SHADER_LOC_VERTEX_TEXCOORD02 = 2,
    SHADER_LOC_VERTEX_NORMAL = 3,
    SHADER_LOC_VERTEX_TANGENT = 4,
    SHADER_LOC_VERTEX_COLOR = 5,
    SHADER_LOC_MATRIX_MVP = 6,
    SHADER_LOC_MATRIX_VIEW = 7,
    SHADER_LOC_MATRIX_PROJECTION = 8,
    SHADER_LOC_MATRIX_MODEL = 9,
    SHADER_LOC_MATRIX_NORMAL = 10,
    SHADER_LOC_VECTOR_VIEW = 11,
    SHADER_LOC_COLOR_DIFFUSE = 12,
    SHADER_LOC_COLOR_SPECULAR = 13,
    SHADER_LOC_COLOR_AMBIENT = 14,
    SHADER_LOC_MAP_ALBEDO = 15,
    SHADER_LOC_MAP_METALNESS = 16,
    SHADER_LOC_MAP_NORMAL = 17,
    SHADER_LOC_MAP_ROUGHNESS = 18,
    SHADER_LOC_MAP_OCCLUSION = 19,
    SHADER_LOC_MAP_EMISSION = 20,
    SHADER_LOC_MAP_HEIGHT = 21,
    SHADER_LOC_MAP_CUBEMAP = 22,
    SHADER_LOC_MAP_IRRADIANCE = 23,
    SHADER_LOC_MAP_PREFILTER = 24,
    SHADER_LOC_MAP_BRDF = 25
}

enum ShaderUniformDataType
{
    SHADER_UNIFORM_FLOAT = 0,
    SHADER_UNIFORM_VEC2 = 1,
    SHADER_UNIFORM_VEC3 = 2,
    SHADER_UNIFORM_VEC4 = 3,
    SHADER_UNIFORM_INT = 4,
    SHADER_UNIFORM_IVEC2 = 5,
    SHADER_UNIFORM_IVEC3 = 6,
    SHADER_UNIFORM_IVEC4 = 7,
    SHADER_UNIFORM_SAMPLER2D = 8
}

enum ShaderAttributeDataType
{
    SHADER_ATTRIB_FLOAT = 0,
    SHADER_ATTRIB_VEC2 = 1,
    SHADER_ATTRIB_VEC3 = 2,
    SHADER_ATTRIB_VEC4 = 3
}

enum PixelFormat
{
    UNCOMPRESSED_GRAYSCALE = 1,
    UNCOMPRESSED_GRAY_ALPHA = 2,
    UNCOMPRESSED_R5G6B5 = 3,
    UNCOMPRESSED_R8G8B8 = 4,
    UNCOMPRESSED_R5G5B5A1 = 5,
    UNCOMPRESSED_R4G4B4A4 = 6,
    UNCOMPRESSED_R8G8B8A8 = 7,
    UNCOMPRESSED_R32 = 8,
    UNCOMPRESSED_R32G32B32 = 9,
    UNCOMPRESSED_R32G32B32A32 = 10,
    COMPRESSED_DXT1_RGB = 11,
    COMPRESSED_DXT1_RGBA = 12,
    COMPRESSED_DXT3_RGBA = 13,
    COMPRESSED_DXT5_RGBA = 14,
    COMPRESSED_ETC1_RGB = 15,
    COMPRESSED_ETC2_RGB = 16,
    COMPRESSED_ETC2_EAC_RGBA = 17,
    COMPRESSED_PVRT_RGB = 18,
    COMPRESSED_PVRT_RGBA = 19,
    COMPRESSED_ASTC_4x4_RGBA = 20,
    COMPRESSED_ASTC_8x8_RGBA = 21
}

enum TextureFilter
{
    TEXTURE_FILTER_POINT = 0,
    TEXTURE_FILTER_BILINEAR = 1,
    TEXTURE_FILTER_TRILINEAR = 2,
    TEXTURE_FILTER_ANISOTROPIC_4X = 3,
    TEXTURE_FILTER_ANISOTROPIC_8X = 4,
    TEXTURE_FILTER_ANISOTROPIC_16X = 5
}

enum TextureWrap
{
    TEXTURE_WRAP_REPEAT = 0,
    TEXTURE_WRAP_CLAMP = 1,
    TEXTURE_WRAP_MIRROR_REPEAT = 2,
    TEXTURE_WRAP_MIRROR_CLAMP = 3
}

enum CubemapLayout
{
    CUBEMAP_LAYOUT_AUTO_DETECT = 0,
    CUBEMAP_LAYOUT_LINE_VERTICAL = 1,
    CUBEMAP_LAYOUT_LINE_HORIZONTAL = 2,
    CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR = 3,
    CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE = 4,
    CUBEMAP_LAYOUT_PANORAMA = 5
}

enum FontType
{
    FONT_DEFAULT = 0,
    FONT_BITMAP = 1,
    FONT_SDF = 2
}

enum BlendMode
{
    BLEND_ALPHA = 0,
    BLEND_ADDITIVE = 1,
    BLEND_MULTIPLIED = 2,
    BLEND_ADD_COLORS = 3,
    BLEND_SUBTRACT_COLORS = 4,
    BLEND_CUSTOM = 5
}

enum Gesture
{
    GESTURE_NONE = 0,
    GESTURE_TAP = 1,
    GESTURE_DOUBLETAP = 2,
    GESTURE_HOLD = 4,
    GESTURE_DRAG = 8,
    GESTURE_SWIPE_RIGHT = 16,
    GESTURE_SWIPE_LEFT = 32,
    GESTURE_SWIPE_UP = 64,
    GESTURE_SWIPE_DOWN = 128,
    GESTURE_PINCH_IN = 256,
    GESTURE_PINCH_OUT = 512
}

enum CameraMode
{
    CAMERA_CUSTOM = 0,
    CAMERA_FREE = 1,
    CAMERA_ORBITAL = 2,
    CAMERA_FIRST_PERSON = 3,
    CAMERA_THIRD_PERSON = 4
}

enum CameraProjection
{
    CAMERA_PERSPECTIVE = 0,
    CAMERA_ORTHOGRAPHIC = 1
}

enum NPatchLayout
{
    NPATCH_NINE_PATCH = 0,
    NPATCH_THREE_PATCH_VERTICAL = 1,
    NPATCH_THREE_PATCH_HORIZONTAL = 2
}
@nogc{

alias TraceLogCallback = void function (int logLevel, const(char)* text, va_list args);
alias LoadFileDataCallback = ubyte* function (const(char)* fileName, uint* bytesRead);
alias SaveFileDataCallback = bool function (const(char)* fileName, void* data, uint bytesToWrite);
alias LoadFileTextCallback = char* function (const(char)* fileName);
alias SaveFileTextCallback = bool function (const(char)* fileName, char* text);
void InitWindow (int width, int height, const(char)* title);
bool WindowShouldClose ();
void CloseWindow ();
bool IsWindowReady ();
bool IsWindowFullscreen ();
bool IsWindowHidden ();
bool IsWindowMinimized ();
bool IsWindowMaximized ();
bool IsWindowFocused ();
bool IsWindowResized ();
bool IsWindowState (uint flag);
void SetWindowState (uint flags);
void ClearWindowState (uint flags);
void ToggleFullscreen ();
void MaximizeWindow ();
void MinimizeWindow ();
void RestoreWindow ();
void SetWindowIcon (Image image);
void SetWindowTitle (const(char)* title);
void SetWindowPosition (int x, int y);
void SetWindowMonitor (int monitor);
void SetWindowMinSize (int width, int height);
void SetWindowSize (int width, int height);
void SetWindowOpacity (float opacity);
void* GetWindowHandle ();
int GetScreenWidth ();
int GetScreenHeight ();
int GetRenderWidth ();
int GetRenderHeight ();
int GetMonitorCount ();
int GetCurrentMonitor ();
Vector2 GetMonitorPosition (int monitor);
int GetMonitorWidth (int monitor);
int GetMonitorHeight (int monitor);
int GetMonitorPhysicalWidth (int monitor);
int GetMonitorPhysicalHeight (int monitor);
int GetMonitorRefreshRate (int monitor);
Vector2 GetWindowPosition ();
Vector2 GetWindowScaleDPI ();
const(char)* GetMonitorName (int monitor);
void SetClipboardText (const(char)* text);
const(char)* GetClipboardText ();

void SwapScreenBuffer ();
void PollInputEvents ();
void WaitTime (float ms);

void ShowCursor ();
void HideCursor ();
bool IsCursorHidden ();
void EnableCursor ();
void DisableCursor ();
bool IsCursorOnScreen ();

void ClearBackground (Color color);
void BeginDrawing ();
void EndDrawing ();
void BeginMode2D (Camera2D camera);
void EndMode2D ();
void BeginMode3D (Camera3D camera);
void EndMode3D ();
void BeginTextureMode (RenderTexture2D target);
void EndTextureMode ();
void BeginShaderMode (Shader shader);
void EndShaderMode ();
void BeginBlendMode (int mode);
void EndBlendMode ();
void BeginScissorMode (int x, int y, int width, int height);
void EndScissorMode ();
void BeginVrStereoMode (VrStereoConfig config);
void EndVrStereoMode ();

VrStereoConfig LoadVrStereoConfig (VrDeviceInfo device);
void UnloadVrStereoConfig (VrStereoConfig config);

Shader LoadShader (const(char)* vsFileName, const(char)* fsFileName);
Shader LoadShaderFromMemory (const(char)* vsCode, const(char)* fsCode);
int GetShaderLocation (Shader shader, const(char)* uniformName);
int GetShaderLocationAttrib (Shader shader, const(char)* attribName);
void SetShaderValue (Shader shader, int locIndex, const(void)* value, int uniformType);
void SetShaderValueV (Shader shader, int locIndex, const(void)* value, int uniformType, int count);
void SetShaderValueMatrix (Shader shader, int locIndex, Matrix mat);
void SetShaderValueTexture (Shader shader, int locIndex, Texture2D texture);
void UnloadShader (Shader shader);

Ray GetMouseRay (Vector2 mousePosition, Camera camera);
Matrix GetCameraMatrix (Camera camera);
Matrix GetCameraMatrix2D (Camera2D camera);
Vector2 GetWorldToScreen (Vector3 position, Camera camera);
Vector2 GetWorldToScreenEx (Vector3 position, Camera camera, int width, int height);
Vector2 GetWorldToScreen2D (Vector2 position, Camera2D camera);
Vector2 GetScreenToWorld2D (Vector2 position, Camera2D camera);

void SetTargetFPS (int fps);
int GetFPS ();
float GetFrameTime ();
double GetTime ();

int GetRandomValue (int min, int max);
void SetRandomSeed (uint seed);
void TakeScreenshot (const(char)* fileName);
void SetConfigFlags (uint flags);

void TraceLog (int logLevel, const(char)* text, ...);
void SetTraceLogLevel (int logLevel);
void* MemAlloc (int size);
void* MemRealloc (void* ptr, int size);
void MemFree (void* ptr);

void SetTraceLogCallback (TraceLogCallback callback);
void SetLoadFileDataCallback (LoadFileDataCallback callback);
void SetSaveFileDataCallback (SaveFileDataCallback callback);
void SetLoadFileTextCallback (LoadFileTextCallback callback);
void SetSaveFileTextCallback (SaveFileTextCallback callback);

ubyte* LoadFileData (const(char)* fileName, uint* bytesRead);
void UnloadFileData (ubyte* data);
bool SaveFileData (const(char)* fileName, void* data, uint bytesToWrite);
char* LoadFileText (const(char)* fileName);
void UnloadFileText (char* text);
bool SaveFileText (const(char)* fileName, char* text);
bool FileExists (const(char)* fileName);
bool DirectoryExists (const(char)* dirPath);
bool IsFileExtension (const(char)* fileName, const(char)* ext);
int GetFileLength (const(char)* fileName);
const(char)* GetFileExtension (const(char)* fileName);
const(char)* GetFileName (const(char)* filePath);
const(char)* GetFileNameWithoutExt (const(char)* filePath);
const(char)* GetDirectoryPath (const(char)* filePath);
const(char)* GetPrevDirectoryPath (const(char)* dirPath);
const(char)* GetWorkingDirectory ();
const(char)* GetApplicationDirectory ();
char** GetDirectoryFiles (const(char)* dirPath, int* count);
void ClearDirectoryFiles ();
bool ChangeDirectory (const(char)* dir);
bool IsFileDropped ();
char** GetDroppedFiles (int* count);
void ClearDroppedFiles ();
c_long GetFileModTime (const(char)* fileName);

ubyte* CompressData (ubyte* data, int dataLength, int* compDataLength);
ubyte* DecompressData (ubyte* compData, int compDataLength, int* dataLength);
char* EncodeDataBase64 (const(ubyte)* data, int dataLength, int* outputLength);
ubyte* DecodeDataBase64 (ubyte* data, int* outputLength);

bool SaveStorageValue (uint position, int value);
int LoadStorageValue (uint position);

void OpenURL (const(char)* url);

bool IsKeyPressed (int key);
bool IsKeyDown (int key);
bool IsKeyReleased (int key);
bool IsKeyUp (int key);
void SetExitKey (int key);
int GetKeyPressed ();
int GetCharPressed ();

bool IsGamepadAvailable (int gamepad);
const(char)* GetGamepadName (int gamepad);
bool IsGamepadButtonPressed (int gamepad, int button);
bool IsGamepadButtonDown (int gamepad, int button);
bool IsGamepadButtonReleased (int gamepad, int button);
bool IsGamepadButtonUp (int gamepad, int button);
int GetGamepadButtonPressed ();
int GetGamepadAxisCount (int gamepad);
float GetGamepadAxisMovement (int gamepad, int axis);
int SetGamepadMappings (const(char)* mappings);

bool IsMouseButtonPressed (int button);
bool IsMouseButtonDown (int button);
bool IsMouseButtonReleased (int button);
bool IsMouseButtonUp (int button);
int GetMouseX ();
int GetMouseY ();
Vector2 GetMousePosition ();
Vector2 GetMouseDelta ();
void SetMousePosition (int x, int y);
void SetMouseOffset (int offsetX, int offsetY);
void SetMouseScale (float scaleX, float scaleY);
float GetMouseWheelMove ();
void SetMouseCursor (int cursor);

int GetTouchX ();
int GetTouchY ();
Vector2 GetTouchPosition (int index);
int GetTouchPointId (int index);
int GetTouchPointCount ();

void SetGesturesEnabled (uint flags);
bool IsGestureDetected (int gesture);
int GetGestureDetected ();
float GetGestureHoldDuration ();
Vector2 GetGestureDragVector ();
float GetGestureDragAngle ();
Vector2 GetGesturePinchVector ();
float GetGesturePinchAngle ();

void SetCameraMode (Camera camera, int mode);
void UpdateCamera (Camera* camera);

void SetCameraPanControl (int keyPan);
void SetCameraAltControl (int keyAlt);
void SetCameraSmoothZoomControl (int keySmoothZoom);
void SetCameraMoveControls (int keyFront, int keyBack, int keyRight, int keyLeft, int keyUp, int keyDown);

void SetShapesTexture (Texture2D texture, Rectangle source);

void DrawPixel (int posX, int posY, Color color);
void DrawPixelV (Vector2 position, Color color);
void DrawLine (int startPosX, int startPosY, int endPosX, int endPosY, Color color);
void DrawLineV (Vector2 startPos, Vector2 endPos, Color color);
void DrawLineEx (Vector2 startPos, Vector2 endPos, float thick, Color color);
void DrawLineBezier (Vector2 startPos, Vector2 endPos, float thick, Color color);
void DrawLineBezierQuad (Vector2 startPos, Vector2 endPos, Vector2 controlPos, float thick, Color color);
void DrawLineBezierCubic (Vector2 startPos, Vector2 endPos, Vector2 startControlPos, Vector2 endControlPos, float thick, Color color);
void DrawLineStrip (Vector2* points, int pointCount, Color color);
void DrawCircle (int centerX, int centerY, float radius, Color color);
void DrawCircleSector (Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color);
void DrawCircleSectorLines (Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color);
void DrawCircleGradient (int centerX, int centerY, float radius, Color color1, Color color2);
void DrawCircleV (Vector2 center, float radius, Color color);
void DrawCircleLines (int centerX, int centerY, float radius, Color color);
void DrawEllipse (int centerX, int centerY, float radiusH, float radiusV, Color color);
void DrawEllipseLines (int centerX, int centerY, float radiusH, float radiusV, Color color);
void DrawRing (Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color);
void DrawRingLines (Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color);
void DrawRectangle (int posX, int posY, int width, int height, Color color);
void DrawRectangleV (Vector2 position, Vector2 size, Color color);
void DrawRectangleRec (Rectangle rec, Color color);
void DrawRectanglePro (Rectangle rec, Vector2 origin, float rotation, Color color);
void DrawRectangleGradientV (int posX, int posY, int width, int height, Color color1, Color color2);
void DrawRectangleGradientH (int posX, int posY, int width, int height, Color color1, Color color2);
void DrawRectangleGradientEx (Rectangle rec, Color col1, Color col2, Color col3, Color col4);
void DrawRectangleLines (int posX, int posY, int width, int height, Color color);
void DrawRectangleLinesEx (Rectangle rec, float lineThick, Color color);
void DrawRectangleRounded (Rectangle rec, float roundness, int segments, Color color);
void DrawRectangleRoundedLines (Rectangle rec, float roundness, int segments, float lineThick, Color color);
void DrawTriangle (Vector2 v1, Vector2 v2, Vector2 v3, Color color);
void DrawTriangleLines (Vector2 v1, Vector2 v2, Vector2 v3, Color color);
void DrawTriangleFan (Vector2* points, int pointCount, Color color);
void DrawTriangleStrip (Vector2* points, int pointCount, Color color);
void DrawPoly (Vector2 center, int sides, float radius, float rotation, Color color);
void DrawPolyLines (Vector2 center, int sides, float radius, float rotation, Color color);
void DrawPolyLinesEx (Vector2 center, int sides, float radius, float rotation, float lineThick, Color color);

bool CheckCollisionRecs (Rectangle rec1, Rectangle rec2);
bool CheckCollisionCircles (Vector2 center1, float radius1, Vector2 center2, float radius2);
bool CheckCollisionCircleRec (Vector2 center, float radius, Rectangle rec);
bool CheckCollisionPointRec (Vector2 point, Rectangle rec);
bool CheckCollisionPointCircle (Vector2 point, Vector2 center, float radius);
bool CheckCollisionPointTriangle (Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3);
bool CheckCollisionLines (Vector2 startPos1, Vector2 endPos1, Vector2 startPos2, Vector2 endPos2, Vector2* collisionPoint);
bool CheckCollisionPointLine (Vector2 point, Vector2 p1, Vector2 p2, int threshold);
Rectangle GetCollisionRec (Rectangle rec1, Rectangle rec2);

Image LoadImage (const(char)* fileName);
Image LoadImageRaw (const(char)* fileName, int width, int height, int format, int headerSize);
Image LoadImageAnim (const(char)* fileName, int* frames);
Image LoadImageFromMemory (const(char)* fileType, const(ubyte)* fileData, int dataSize);
Image LoadImageFromTexture (Texture2D texture);
Image LoadImageFromScreen ();
void UnloadImage (Image image);
bool ExportImage (Image image, const(char)* fileName);
bool ExportImageAsCode (Image image, const(char)* fileName);

Image GenImageColor (int width, int height, Color color);
Image GenImageGradientV (int width, int height, Color top, Color bottom);
Image GenImageGradientH (int width, int height, Color left, Color right);
Image GenImageGradientRadial (int width, int height, float density, Color inner, Color outer);
Image GenImageChecked (int width, int height, int checksX, int checksY, Color col1, Color col2);
Image GenImageWhiteNoise (int width, int height, float factor);
Image GenImageCellular (int width, int height, int tileSize);

Image ImageCopy (Image image);
Image ImageFromImage (Image image, Rectangle rec);
Image ImageText (const(char)* text, int fontSize, Color color);
Image ImageTextEx (Font font, const(char)* text, float fontSize, float spacing, Color tint);
void ImageFormat (Image* image, int newFormat);
void ImageToPOT (Image* image, Color fill);
void ImageCrop (Image* image, Rectangle crop);
void ImageAlphaCrop (Image* image, float threshold);
void ImageAlphaClear (Image* image, Color color, float threshold);
void ImageAlphaMask (Image* image, Image alphaMask);
void ImageAlphaPremultiply (Image* image);
void ImageResize (Image* image, int newWidth, int newHeight);
void ImageResizeNN (Image* image, int newWidth, int newHeight);
void ImageResizeCanvas (Image* image, int newWidth, int newHeight, int offsetX, int offsetY, Color fill);
void ImageMipmaps (Image* image);
void ImageDither (Image* image, int rBpp, int gBpp, int bBpp, int aBpp);
void ImageFlipVertical (Image* image);
void ImageFlipHorizontal (Image* image);
void ImageRotateCW (Image* image);
void ImageRotateCCW (Image* image);
void ImageColorTint (Image* image, Color color);
void ImageColorInvert (Image* image);
void ImageColorGrayscale (Image* image);
void ImageColorContrast (Image* image, float contrast);
void ImageColorBrightness (Image* image, int brightness);
void ImageColorReplace (Image* image, Color color, Color replace);
Color* LoadImageColors (Image image);
Color* LoadImagePalette (Image image, int maxPaletteSize, int* colorCount);
void UnloadImageColors (Color* colors);
void UnloadImagePalette (Color* colors);
Rectangle GetImageAlphaBorder (Image image, float threshold);
Color GetImageColor (Image image, int x, int y);

void ImageClearBackground (Image* dst, Color color);
void ImageDrawPixel (Image* dst, int posX, int posY, Color color);
void ImageDrawPixelV (Image* dst, Vector2 position, Color color);
void ImageDrawLine (Image* dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color);
void ImageDrawLineV (Image* dst, Vector2 start, Vector2 end, Color color);
void ImageDrawCircle (Image* dst, int centerX, int centerY, int radius, Color color);
void ImageDrawCircleV (Image* dst, Vector2 center, int radius, Color color);
void ImageDrawRectangle (Image* dst, int posX, int posY, int width, int height, Color color);
void ImageDrawRectangleV (Image* dst, Vector2 position, Vector2 size, Color color);
void ImageDrawRectangleRec (Image* dst, Rectangle rec, Color color);
void ImageDrawRectangleLines (Image* dst, Rectangle rec, int thick, Color color);
void ImageDraw (Image* dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint);
void ImageDrawText (Image* dst, const(char)* text, int posX, int posY, int fontSize, Color color);
void ImageDrawTextEx (Image* dst, Font font, const(char)* text, Vector2 position, float fontSize, float spacing, Color tint);

Texture2D LoadTexture (const(char)* fileName);
Texture2D LoadTextureFromImage (Image image);
TextureCubemap LoadTextureCubemap (Image image, int layout);
RenderTexture2D LoadRenderTexture (int width, int height);
void UnloadTexture (Texture2D texture);
void UnloadRenderTexture (RenderTexture2D target);
void UpdateTexture (Texture2D texture, const(void)* pixels);
void UpdateTextureRec (Texture2D texture, Rectangle rec, const(void)* pixels);

void GenTextureMipmaps (Texture2D* texture);
void SetTextureFilter (Texture2D texture, int filter);
void SetTextureWrap (Texture2D texture, int wrap);

void DrawTexture (Texture2D texture, int posX, int posY, Color tint);
void DrawTextureV (Texture2D texture, Vector2 position, Color tint);
void DrawTextureEx (Texture2D texture, Vector2 position, float rotation, float scale, Color tint);
void DrawTextureRec (Texture2D texture, Rectangle source, Vector2 position, Color tint);
void DrawTextureQuad (Texture2D texture, Vector2 tiling, Vector2 offset, Rectangle quad, Color tint);
void DrawTextureTiled (Texture2D texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, float scale, Color tint);
void DrawTexturePro (Texture2D texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint);
void DrawTextureNPatch (Texture2D texture, NPatchInfo nPatchInfo, Rectangle dest, Vector2 origin, float rotation, Color tint);
void DrawTexturePoly (Texture2D texture, Vector2 center, Vector2* points, Vector2* texcoords, int pointCount, Color tint);

Color Fade (Color color, float alpha);
int ColorToInt (Color color);
Vector4 ColorNormalize (Color color);
Color ColorFromNormalized (Vector4 normalized);
Vector3 ColorToHSV (Color color);
Color ColorFromHSV (float hue, float saturation, float value);
Color ColorAlpha (Color color, float alpha);
Color ColorAlphaBlend (Color dst, Color src, Color tint);
Color GetColor (uint hexValue);
Color GetPixelColor (void* srcPtr, int format);
void SetPixelColor (void* dstPtr, Color color, int format);
int GetPixelDataSize (int width, int height, int format);

Font GetFontDefault ();
Font LoadFont (const(char)* fileName);
Font LoadFontEx (const(char)* fileName, int fontSize, int* fontChars, int glyphCount);
Font LoadFontFromImage (Image image, Color key, int firstChar);
Font LoadFontFromMemory (const(char)* fileType, const(ubyte)* fileData, int dataSize, int fontSize, int* fontChars, int glyphCount);
GlyphInfo* LoadFontData (const(ubyte)* fileData, int dataSize, int fontSize, int* fontChars, int glyphCount, int type);
Image GenImageFontAtlas (const(GlyphInfo)* chars, Rectangle** recs, int glyphCount, int fontSize, int padding, int packMethod);
void UnloadFontData (GlyphInfo* chars, int glyphCount);
void UnloadFont (Font font);
bool ExportFontAsCode (Font font, const(char)* fileName);

void DrawFPS (int posX, int posY);
void DrawText (const(char)* text, int posX, int posY, int fontSize, Color color);
void DrawTextEx (Font font, const(char)* text, Vector2 position, float fontSize, float spacing, Color tint);
void DrawTextPro (Font font, const(char)* text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint);
void DrawTextCodepoint (Font font, int codepoint, Vector2 position, float fontSize, Color tint);
void DrawTextCodepoints (Font font, int* codepoints, int count, Vector2 position, float fontSize, float spacing, Color tint);

int MeasureText (const(char)* text, int fontSize);
Vector2 MeasureTextEx (Font font, const(char)* text, float fontSize, float spacing);
int GetGlyphIndex (Font font, int codepoint);
GlyphInfo GetGlyphInfo (Font font, int codepoint);
Rectangle GetGlyphAtlasRec (Font font, int codepoint);

int* LoadCodepoints (const(char)* text, int* count);
void UnloadCodepoints (int* codepoints);
int GetCodepointCount (const(char)* text);
int GetCodepoint (const(char)* text, int* bytesProcessed);
const(char)* CodepointToUTF8 (int codepoint, int* byteSize);
char* TextCodepointsToUTF8 (int* codepoints, int length);

int TextCopy (char* dst, const(char)* src);
bool TextIsEqual (const(char)* text1, const(char)* text2);
uint TextLength (const(char)* text);
const(char)* TextFormat (const(char)* text, ...);
const(char)* TextSubtext (const(char)* text, int position, int length);
char* TextReplace (char* text, const(char)* replace, const(char)* by);
char* TextInsert (const(char)* text, const(char)* insert, int position);
const(char)* TextJoin (const(char*)* textList, int count, const(char)* delimiter);
const(char*)* TextSplit (const(char)* text, char delimiter, int* count);
void TextAppend (char* text, const(char)* append, int* position);
int TextFindIndex (const(char)* text, const(char)* find);
const(char)* TextToUpper (const(char)* text);
const(char)* TextToLower (const(char)* text);
const(char)* TextToPascal (const(char)* text);
int TextToInteger (const(char)* text);

void DrawLine3D (Vector3 startPos, Vector3 endPos, Color color);
void DrawPoint3D (Vector3 position, Color color);
void DrawCircle3D (Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, Color color);
void DrawTriangle3D (Vector3 v1, Vector3 v2, Vector3 v3, Color color);
void DrawTriangleStrip3D (Vector3* points, int pointCount, Color color);
void DrawCube (Vector3 position, float width, float height, float length, Color color);
void DrawCubeV (Vector3 position, Vector3 size, Color color);
void DrawCubeWires (Vector3 position, float width, float height, float length, Color color);
void DrawCubeWiresV (Vector3 position, Vector3 size, Color color);
void DrawCubeTexture (Texture2D texture, Vector3 position, float width, float height, float length, Color color);
void DrawCubeTextureRec (Texture2D texture, Rectangle source, Vector3 position, float width, float height, float length, Color color);
void DrawSphere (Vector3 centerPos, float radius, Color color);
void DrawSphereEx (Vector3 centerPos, float radius, int rings, int slices, Color color);
void DrawSphereWires (Vector3 centerPos, float radius, int rings, int slices, Color color);
void DrawCylinder (Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color);
void DrawCylinderEx (Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color);
void DrawCylinderWires (Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color);
void DrawCylinderWiresEx (Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color);
void DrawPlane (Vector3 centerPos, Vector2 size, Color color);
void DrawRay (Ray ray, Color color);
void DrawGrid (int slices, float spacing);

Model LoadModel (const(char)* fileName);
Model LoadModelFromMesh (Mesh mesh);
void UnloadModel (Model model);
void UnloadModelKeepMeshes (Model model);
BoundingBox GetModelBoundingBox (Model model);

void DrawModel (Model model, Vector3 position, float scale, Color tint);
void DrawModelEx (Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint);
void DrawModelWires (Model model, Vector3 position, float scale, Color tint);
void DrawModelWiresEx (Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint);
void DrawBoundingBox (BoundingBox box, Color color);
void DrawBillboard (Camera camera, Texture2D texture, Vector3 position, float size, Color tint);
void DrawBillboardRec (Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector2 size, Color tint);
void DrawBillboardPro (Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint);

void UploadMesh (Mesh* mesh, bool dynamic);
void UpdateMeshBuffer (Mesh mesh, int index, void* data, int dataSize, int offset);
void UnloadMesh (Mesh mesh);
void DrawMesh (Mesh mesh, Material material, Matrix transform);
void DrawMeshInstanced (Mesh mesh, Material material, Matrix* transforms, int instances);
bool ExportMesh (Mesh mesh, const(char)* fileName);
BoundingBox GetMeshBoundingBox (Mesh mesh);
void GenMeshTangents (Mesh* mesh);
void GenMeshBinormals (Mesh* mesh);

Mesh GenMeshPoly (int sides, float radius);
Mesh GenMeshPlane (float width, float length, int resX, int resZ);
Mesh GenMeshCube (float width, float height, float length);
Mesh GenMeshSphere (float radius, int rings, int slices);
Mesh GenMeshHemiSphere (float radius, int rings, int slices);
Mesh GenMeshCylinder (float radius, float height, int slices);
Mesh GenMeshCone (float radius, float height, int slices);
Mesh GenMeshTorus (float radius, float size, int radSeg, int sides);
Mesh GenMeshKnot (float radius, float size, int radSeg, int sides);
Mesh GenMeshHeightmap (Image heightmap, Vector3 size);
Mesh GenMeshCubicmap (Image cubicmap, Vector3 cubeSize);

Material* LoadMaterials (const(char)* fileName, int* materialCount);
Material LoadMaterialDefault ();
void UnloadMaterial (Material material);
void SetMaterialTexture (Material* material, int mapType, Texture2D texture);
void SetModelMeshMaterial (Model* model, int meshId, int materialId);

ModelAnimation* LoadModelAnimations (const(char)* fileName, uint* animCount);
void UpdateModelAnimation (Model model, ModelAnimation anim, int frame);
void UnloadModelAnimation (ModelAnimation anim);
void UnloadModelAnimations (ModelAnimation* animations, uint count);
bool IsModelAnimationValid (Model model, ModelAnimation anim);

bool CheckCollisionSpheres (Vector3 center1, float radius1, Vector3 center2, float radius2);
bool CheckCollisionBoxes (BoundingBox box1, BoundingBox box2);
bool CheckCollisionBoxSphere (BoundingBox box, Vector3 center, float radius);
RayCollision GetRayCollisionSphere (Ray ray, Vector3 center, float radius);
RayCollision GetRayCollisionBox (Ray ray, BoundingBox box);
RayCollision GetRayCollisionModel (Ray ray, Model model);
RayCollision GetRayCollisionMesh (Ray ray, Mesh mesh, Matrix transform);
RayCollision GetRayCollisionTriangle (Ray ray, Vector3 p1, Vector3 p2, Vector3 p3);
RayCollision GetRayCollisionQuad (Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4);

void InitAudioDevice ();
void CloseAudioDevice ();
bool IsAudioDeviceReady ();
void SetMasterVolume (float volume);

Wave LoadWave (const(char)* fileName);
Wave LoadWaveFromMemory (const(char)* fileType, const(ubyte)* fileData, int dataSize);
Sound LoadSound (const(char)* fileName);
Sound LoadSoundFromWave (Wave wave);
void UpdateSound (Sound sound, const(void)* data, int sampleCount);
void UnloadWave (Wave wave);
void UnloadSound (Sound sound);
bool ExportWave (Wave wave, const(char)* fileName);
bool ExportWaveAsCode (Wave wave, const(char)* fileName);

void PlaySound (Sound sound);
void StopSound (Sound sound);
void PauseSound (Sound sound);
void ResumeSound (Sound sound);
void PlaySoundMulti (Sound sound);
void StopSoundMulti ();
int GetSoundsPlaying ();
bool IsSoundPlaying (Sound sound);
void SetSoundVolume (Sound sound, float volume);
void SetSoundPitch (Sound sound, float pitch);
void SetSoundPan (Sound sound, float pan);
Wave WaveCopy (Wave wave);
void WaveCrop (Wave* wave, int initSample, int finalSample);
void WaveFormat (Wave* wave, int sampleRate, int sampleSize, int channels);
float* LoadWaveSamples (Wave wave);
void UnloadWaveSamples (float* samples);

Music LoadMusicStream (const(char)* fileName);
Music LoadMusicStreamFromMemory (const(char)* fileType, ubyte* data, int dataSize);
void UnloadMusicStream (Music music);
void PlayMusicStream (Music music);
bool IsMusicStreamPlaying (Music music);
void UpdateMusicStream (Music music);
void StopMusicStream (Music music);
void PauseMusicStream (Music music);
void ResumeMusicStream (Music music);
void SeekMusicStream (Music music, float position);
void SetMusicVolume (Music music, float volume);
void SetMusicPitch (Music music, float pitch);
void SetMusicPan (Music music, float pan);
float GetMusicTimeLength (Music music);
float GetMusicTimePlayed (Music music);

AudioStream LoadAudioStream (uint sampleRate, uint sampleSize, uint channels);
void UnloadAudioStream (AudioStream stream);
void UpdateAudioStream (AudioStream stream, const(void)* data, int frameCount);
bool IsAudioStreamProcessed (AudioStream stream);
void PlayAudioStream (AudioStream stream);
void PauseAudioStream (AudioStream stream);
void ResumeAudioStream (AudioStream stream);
bool IsAudioStreamPlaying (AudioStream stream);
void StopAudioStream (AudioStream stream);
void SetAudioStreamVolume (AudioStream stream, float volume);
void SetAudioStreamPitch (AudioStream stream, float pitch);
void SetAudioStreamPan (AudioStream stream, float pan);
void SetAudioStreamBufferSizeDefault (int size);

}