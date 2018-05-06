#version 300 es
precision highp float;

in vec4 eyeSpaceNormal;
in vec4 eyeSpacePosition;

uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPosition;

out vec4 fragmentColor;

void main() {
	
	vec3 lightDirection = normalize(lightPosition - eyeSpacePosition.xyz);
	vec3 normal = normalize(eyeSpaceNormal.xyz);
	
	float diffuseFactor = max(dot(normal, lightDirection), 0.0);
	
	vec3 viewDirection = vec3(0.0, 0.0, 1.0);
	vec3 reflectDirection = reflect(-lightDirection, normal);
	float reflectFactor = max(dot(viewDirection, reflectDirection), 0.0);
	float specularFactor = pow(reflectFactor, 512.0);
	
	vec3 result = ambientColor + diffuseFactor * diffuseColor + specularFactor * specularColor;
	fragmentColor = vec4(result, 1.0);
}
