#ifdef WATER_SHADER

#if defined(VERTEX) ///////////////////////////////////////////////////

layout(location = 0) in vec3 aPosition;
layout(location = 1) in vec2 aTexCoords;

out vec2 texCoords;

uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;

void main()
{
    texCoords = aTexCoords;
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(aPosition, 1.0);
}

#elif defined(FRAGMENT) ///////////////////////////////////////////////

in vec2 texCoords;

out vec4 fragColor;

uniform sampler2D reflectionTexture;
uniform sampler2D refractionTexture;

void main()
{
    vec4 reflectColor = texture(reflectionTexture, texCoords);
    vec4 refractColor = texture(refractionTexture, texCoords);

    fragColor = mix(reflectColor, refractColor, 0.5);

    //fragColor = vec4(0.0f, 0.0f, 1.0f, 1.0f);

}

#endif
#endif
