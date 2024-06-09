#ifdef WATER_SHADER

#if defined(VERTEX) ///////////////////////////////////////////////////

layout(location = 0) in vec3 aPosition;

out vec4 clipSpace;

uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;

void main()
{
    clipSpace = projectionMatrix * viewMatrix * modelMatrix * vec4(aPosition, 1.0);
    gl_Position = clipSpace;
}

#elif defined(FRAGMENT) ///////////////////////////////////////////////

in vec4 clipSpace;

out vec4 fragColor;

uniform sampler2D reflectionTexture;
uniform sampler2D refractionTexture;

void main()
{
    vec2 ndc = (clipSpace.xy/clipSpace.w) / 2.0 + 0.5;
    vec2 reflectTexCoords = vec2(ndc.x, 1.0 -ndc.y);
    vec2 refractTexCoords = vec2(ndc.x, ndc.y);

    vec4 reflectColor = texture(reflectionTexture, reflectTexCoords);
    vec4 refractColor = texture(refractionTexture, refractTexCoords);

    //fragColor = mix(reflectColor, refractColor, 0.5);

    fragColor = vec4(0.0f, 0.0f, 1.0f, 1.0f);
   
}

#endif
#endif
