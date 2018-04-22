#version 300 es
layout(location = 0) in vec4 position;
layout(location = 1) in vec3 normal;

uniform mat4 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;

uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform vec3 lightPosition;

out vec3 color;

void main() {
	
	vec4 eyeSpaceNormal = normalMatrix * vec4(normal, 1.0);
	vec4 eyeSpacePosition = modelViewMatrix * position;
	
	vec3 lightDirection = normalize(lightPosition - eyeSpacePosition.xyz);
	float diffuseFactor = max(dot(eyeSpaceNormal.xyz, lightDirection), 0.0);
	
	vec3 viewDirection = vec3(0, 0, 1);
	vec3 halfPlane = normalize(lightDirection - viewDirection);
	float specularFactor = pow(max(dot(eyeSpaceNormal.xyz, halfPlane), 0.0), 256.0);
	
	color = ambientColor + diffuseFactor * diffuseColor + specularFactor * specularColor;
    gl_Position = modelViewProjectionMatrix * position;
}
