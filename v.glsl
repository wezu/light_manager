//GLSL
#version 140
uniform mat4 p3d_ModelViewProjectionMatrix;

in vec4 p3d_Vertex;
in vec3 p3d_Normal;
in vec2 p3d_MultiTexCoord0;
uniform mat4 p3d_ModelMatrix;
out vec2 uv;
out vec4 world_pos;
out vec3 normal;

void main()
    { 
    gl_Position = p3d_ModelViewProjectionMatrix * p3d_Vertex; 
    uv=p3d_MultiTexCoord0;
    world_pos=p3d_ModelMatrix* p3d_Vertex; 
    normal=p3d_Normal;
    }
