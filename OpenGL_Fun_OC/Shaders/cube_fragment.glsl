#version 300 es
precision mediump float;

in vec3 v_normal;
in vec3 fragmentPosition;

uniform vec3 color;
uniform vec3 lightColor;
uniform vec3 lightPosition;

out vec4 fragmentColor;

vec3 ambient() {
	float ambientStrength = 0.1;
	vec3 ambient = ambientStrength * lightColor;

	return ambient;
}

void main() {
	
	// Diffuse color
	vec3 normal = normalize(v_normal);
	vec3 lightDirection = normalize(lightPosition - fragmentPosition);
	
	float diff = max(dot(normal, lightDirection), 0.0);
	vec3 diffuse = diff * lightColor;
	vec3 ambient = ambient();
	
	fragmentColor = vec4((ambient + diffuse) * color, 1.0);
}
