#version 300 es
layout(location = 0) in vec4 position;
layout(location = 1) in vec3 normal;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

out vec3 v_normal;
out vec3 fragmentPosition;

void main() {
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * position;
	v_normal = normal;
	
	// Translate to world coordinate
	fragmentPosition = vec3(modelMatrix * position);
}
