#ifdef WATER_SHADER

#if defined(VERTEX) ///////////////////////////////////////////////////

layout(location = 0) in vec3 aPosition;

out vec4 clipSpace;
out vec2 textureCoords;

uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;


void main()
{
    clipSpace = projectionMatrix * viewMatrix * modelMatrix * vec4(aPosition, 1.0);
    gl_Position = clipSpace;
    textureCoords = vec2(aPosition.x/2.0+0.5 , aPosition.z/2.0 + 0.5);
}

#elif defined(FRAGMENT) ///////////////////////////////////////////////

in vec4 clipSpace;
in vec2 textureCoords;

out vec4 fragColor;

uniform sampler2D reflectionTexture;
uniform sampler2D refractionTexture;
uniform sampler2D dudvMap;

uniform float moveFactor;

const float waveStrength = 0.02;

void main()
{ 
    vec2 ndc = (clipSpace.xy/clipSpace.w) / 2.0 + 0.5;
    vec2 reflectTexCoords = vec2(ndc.x, 1.0-ndc.y);
    vec2 refractTexCoords = vec2(ndc.x, ndc.y);

    vec2 distortion1 = texture(dudvMap, vec2(textureCoords.x + moveFactor, textureCoords.y)).rg * 2.0 - 1.0;
    distortion1 *= waveStrength;

    vec2 distortion2 = texture(dudvMap, vec2(-textureCoords.x + moveFactor, textureCoords.y + moveFactor)).rg * 2.0 - 1.0;
    distortion2 *= waveStrength;

    vec2 totalDistortion = distortion1 + distortion2;

    reflectTexCoords += totalDistortion;
    

    refractTexCoords += totalDistortion;

    vec4 reflectColor = texture(reflectionTexture, reflectTexCoords);
    vec4 refractColor = texture(refractionTexture, refractTexCoords);

    fragColor = mix(reflectColor, refractColor, 0.5);
    fragColor = mix(fragColor, vec4(0.0, 0.3, 0.5, 1.0), 0.2);

    //fragColor = texture(dudvMap, textureCoords);

    //fragColor = vec4(0.0f, 0.0f, 1.0f, 1.0f);
   
}

#endif
#endif
