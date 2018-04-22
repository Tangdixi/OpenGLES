#version 300 es
precision highp float;

in vec3 color;

out vec4 fragmentColor;

void main() {
	fragmentColor = vec4(color, 1.0);
}
