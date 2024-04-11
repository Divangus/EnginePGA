#ifdef RENDER_TO_BB

#if defined(VERTEX) ///////////////////////////////////////////////////

layout(location = 0) in vec3 aPosition;
layout(location = 1) in vec3 aNormal;
layout(location = 2) in vec2 aTexCoord;
//layout(location = 3) in vec3 aTangent;
//layout(location = 4) in vec3 aBitangent;

struct Light
        glViewport(0, 0, app->displaySize.x, app->displaySize.y);

        glBindFramebuffer(GL_FRAMEBUFFER, app->framebufferHandle);

        GLuint drawBuffers[] = { app->colorAttachmentHandle };
        glDrawBuffers(ARRAY_COUNT(drawBuffers), drawBuffers);


        glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        const Program& texturedMeshProgram = app->programs[app->renderToBackBufferShader];
        glUseProgram(texturedMeshProgram.handle);

        glBindBufferRange(GL_UNIFORM_BUFFER, BINDING(0), app->localUniformBuffer.handle, app->globalParamsOffset, app->globalParamsSize);


        for (auto it = app->entities.begin(); it != app->entities.end(); ++it)
        {
                    
            glBindBufferRange(GL_UNIFORM_BUFFER, BINDING(1), app->localUniformBuffer.handle, it->localParamsOffset, it->localParamsSize);            

            Model& model = app->models[it->modelIndex];
            Mesh& mesh = app->meshes[model.meshIdx];

            //glUniformMatrix4fv(glGetUniformLocation(texturedMeshProgram.handle, "WVP"), 1, GL_FALSE, &WVP[0][0]);

            for (u32 i = 0; i < mesh.submeshes.size(); ++i)
            {
                GLuint vao = FindVAO(mesh, i, texturedMeshProgram);
                glBindVertexArray(vao);

                u32 subMeshmaterialIdx = model.materialIdx[i];
                Material& subMeshMaterial = app->materials[subMeshmaterialIdx];

                glActiveTexture(GL_TEXTURE0);
                glBindTexture(GL_TEXTURE_2D, app->textures[subMeshMaterial.albedoTextureIdx].handle);
                glUniform1i(app->texturedMeshProgram_uTexture, 0);

                SubMesh& submesh = mesh.submeshes[i];
                glDrawElements(GL_TRIANGLES, submesh.indices.size(), GL_UNSIGNED_INT, (void*)(u64)submesh.indexOffset);
            }

        }
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

    }
    break;
{
	uint type;
	vec3 color;
	vec3 direction;
	vec3 position;
};

layout(binding = 0, std140) uniform GlobalParams
{
	vec3 uCameraPosition;
	uint uLightCount;
	Light uLight[16];
};


out vec2 vTexCoord;
out vec3 vPosition; // in worldspace
out vec3 vNormal;  // in worldspace
out vec3 vViewDir;

layout(binding = 1, std140) uniform LocalParams
{
	mat4 uWorldMatrix;
	mat4 uWorldViewProjectionMatrix;
};

void main()
{
	vTexCoord = aTexCoord;

	vPosition = vec3(uWorldMatrix * vec4(aPosition,1.0));
	vNormal = vec3(uWorldMatrix * vec4(aNormal,0.0));
	vViewDir = uCameraPosition - vPosition;
	float clippingScale = 1.0;

	gl_Position = uWorldViewProjectionMatrix * vec4(aPosition, clippingScale);
}

#elif defined(FRAGMENT) ///////////////////////////////////////////////

struct Light
{
	uint type;
	vec3 color;
	vec3 direction;
	vec3 position;
};

layout(binding = 0, std140) uniform GlobalParams
{
	vec3 uCameraPosition;
	uint uLightCount;
	Light uLight[16];
};


in vec2 vTexCoord;
in vec3 vPosition; // in worldspace
in vec3 vNormal;  // in worldspace
in vec3 vViewDir;

uniform sampler2D uTexture;
layout(location = 0) out vec4 oColor;

void CalculateBlitVars(in Light light ,out vec3 ambient, out vec3 diffuse, out vec3 specular)
{
			vec3 lightDir = normalize(light.direction);

			float ambientStrenght = 0.2;
			ambient = ambientStrenght * light.color;

			float diff = max(dot(vNormal, lightDir), 0.0f);
			diffuse = diff * light.color;

			float specularStrength = 0.1f;
			vec3 reflectDir = reflect(-lightDir, vNormal);
			vec3 normalViewDir = normalize(vViewDir);
			float spec = pow(max(dot(normalViewDir, reflectDir), 0.0f), 32);
			specular = specularStrength * spec * light.color;
}

void main()
{
	vec4 textureColor = texture(uTexture, vTexCoord);
	vec4 finalColor = vec4(0.0);
	for(int i = 0; i < uLightCount; ++i)
	{
		
		vec3 lightResult = vec3(0.0f);

		vec3 ambient = vec3(0.0);
		vec3 diffuse = vec3(0.0);
		vec3 specular = vec3(0.0);

		if(uLight[i].type == 0)
		{
			Light light = uLight[i];

			CalculateBlitVars(light, ambient, diffuse, specular);

			lightResult = ambient + diffuse + specular;
			finalColor += vec4(lightResult, 1.0) * textureColor;

		}
		else
		{
			Light light = uLight[i];

			float constant = 1.0f;
			float linear = 0.09f;
			float quadratic = 0.032f;
			float distance = length(light.position - vPosition);
			float attenuation = 1.0f / (constant + linear * distance + quadratic * (distance * distance));

			CalculateBlitVars(light, ambient, diffuse, specular);

			lightResult = (ambient * attenuation) + (diffuse * attenuation) + (specular * attenuation);
			finalColor += vec4(lightResult, 1.0) * textureColor;
		}
	}

	oColor = finalColor;
}

#endif
#endif