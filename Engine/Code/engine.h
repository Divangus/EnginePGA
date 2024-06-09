//
// engine.h: This file contains the types and functions relative to the engine.
//

#pragma once

#include "platform.h"
#include "BufferSuppFunctions.h"
#include "ModelLoadingFunctions.h"
#include "Globals.h"

const VertexV3V2 vertices[] = {
    {glm::vec3(-1.0,-1.0,0.0), glm::vec2(0.0,0.0)},
    {glm::vec3(1.0,-1.0,0.0), glm::vec2(1.0,0.0)},
    {glm::vec3(1.0,1.0,0.0), glm::vec2(1.0,1.0)},
    {glm::vec3(-1.0,1.0,0.0), glm::vec2(0.0,1.0)},
};

const u16 indices[] =
{
    0,1,2,
    0,2,3
};

enum WaterScenePart
{
    REFLECTION,
    REFRACTION
};

struct App
{
    void processInput(GLFWwindow* window);

    void LoadWaterVAO();

    void UpdateEntityBuffer(bool mouse);

    //void UpdateWatterBuffer();

    void RenderWater(const Program& aBindedProgram);

    //void PassWaterScene(Camera camera, GLenum colorAttachment, WaterScenePart part);

    void ConfigureFrameBuffer(FrameBuffer& aConfigFB);

    FrameBuffer CreateFrameBuffer();

    GLuint CreateTextureAttachment(int width, int height);

    GLuint CreateDepthAttachment(int width, int height);

    //void ConfigFrameBuffer(FrameBuffer& frameBuffer, GLuint& colorAttachment, GLuint& depthHandle);
    
    void ConfigureWaterBuffer(FrameBuffer& aConfigFB, GLuint& colorAttach, GLuint& depth);

    float GetHeight(glm::mat4 transformMat);

    void RenderGeometry(const Program& aBindedProgram, vec4 clippingPlane);

    void CreateDirectLight(vec3 color, vec3 direction, vec3 position);

    void CreatePointLight(vec3 color, vec3 direction, vec3 position);

    const GLuint CreateTexture(const bool isFloatingPoint = false);

    //models
    u32 CubeModelIndex;
    u32 SphereModelIndex;

    ////camera
    //glm::vec3 cameraPos = glm::vec3(0.0f, 0.0f, 3.0f);
    //glm::vec3 cameraFront = glm::vec3(0.0f, 0.0f, -1.0f);
    //glm::vec3 cameraUp = glm::vec3(0.0f, 1.0f, 0.0f);

    //float yaw;
    //float pitch;

    Camera sceneCam;

    glm::mat4 projection;
    glm::mat4 view;

    // Loop
    f32  deltaTime;
    bool isRunning;

    // Input
    Input input;

    // Graphics
    char gpuName[64];
    char openGlVersion[64];

    ivec2 displaySize;

    std::vector<Texture>    textures;
    std::vector<Material>   materials;
    std::vector<Mesh>       meshes;
    std::vector<Model>      models;
    std::vector<Program>    programs;

    // program indices
    u32 texturedGeometryProgramIdx = 0;
    
    GLuint renderToBackBufferShader;
    GLuint renderToFrameBufferShader;
    GLuint framebufferToQuadShader;
    GLuint waterShader;

    GLuint texturedMeshProgram_uTexture;
    
    // texture indices
    u32 diceTexIdx;
    u32 whiteTexIdx;
    u32 blackTexIdx;
    u32 normalTexIdx;
    u32 magentaTexIdx;

    // Mode
    Mode mode;

    // Embedded geometry (in-editor simple meshes such as
    // a screen filling quad, a cube, a sphere...)
    GLuint embeddedVertices;
    GLuint embeddedElements;

    // Location of the texture uniform in the textured quad shader
    GLuint programUniformTexture;

    // VAO object to link our screen filling quad with our textured quad shader
    GLuint vao;

    std::string openglDebugInfo;

    GLint maxUniformBufferSize;
    GLint uniformBlockAlignment; //Alignment between uniform BLOCKS!!!!
    Buffer localUniformBuffer;
    std::vector<Entity> entities;
    std::vector<Light> lights;

    //Entity water;
    glm::mat4 WaterWorldMatrix;

    GLuint globalParamsOffset;
    GLuint globalParamsSize;

    GLuint framebufferHandle;
    GLuint colorAttachmentHandle;

    FrameBuffer deferredFrameBuffer;
    WaterBuffer waterBuffers;

    GLuint waterVAO = 0;
    GLuint waterVBO = 0;
    GLuint waterEBO = 0;
};

void Init(App* app);

void Gui(App* app);

void Update(App* app);

void Render(App* app);

