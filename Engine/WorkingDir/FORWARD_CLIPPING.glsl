#ifdef FORWARD_CLIPPING

#if defined(VERTEX) ///////////////////////////////////////////////////

layout(location = 0) in vec3 position;

uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;

void main()
{
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);
}

#elif defined(FRAGMENT) ///////////////////////////////////////////////


out vec4 fragColor;

void main()
{
    fragColor = vec4(0.0, 0.0, 1.0, 1.0); 
}

#endif
#endif
