#version 300 es
layout(location = 0) in vec4 position;
layout(location = 1) in vec3 normal;

uniform mat4 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;

out vec4 eyeSpaceNormal;
out vec4 eyeSpacePosition;

void main() {
	
	eyeSpaceNormal = normalMatrix * vec4(normal, 1.0);
	eyeSpacePosition = modelViewMatrix * position;

	gl_Position = modelViewProjectionMatrix * position;
}
