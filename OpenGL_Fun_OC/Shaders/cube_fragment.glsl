#version 300 es
precision highp float;

struct Material {
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float shininess;
};

struct Light {
	vec3 position;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};

in vec4 eyeSpaceNormal;
in vec4 eyeSpacePosition;

uniform vec3 lightPosition;

uniform Material material;
uniform Light light;

out vec4 fragmentColor;

void main() {
	
	vec3 lightDirection = normalize(light.position - eyeSpacePosition.xyz);
	vec3 normal = normalize(eyeSpaceNormal.xyz);
	
	float diffuseFactor = max(dot(normal, lightDirection), 0.0);
	
	vec3 viewDirection = vec3(0.0, 0.0, 1.0);
	vec3 reflectDirection = reflect(-lightDirection, normal);
	float reflectFactor = max(dot(viewDirection, reflectDirection), 0.0);
	float specularFactor = pow(reflectFactor, material.shininess);
	
	vec3 ambient = material.ambient * light.ambient;
	vec3 diffuse = diffuseFactor * material.diffuse * light.diffuse;
	vec3 specular = specularFactor * material.specular * light.specular;
	
	vec3 result = ambient + diffuse + specular;
	fragmentColor = vec4(result, 1.0);
}
