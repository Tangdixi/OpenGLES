#version 300 es
precision mediump float;

uniform vec3 color;
uniform vec3 lightColor;

out vec4 fragmentColor;

void main() {
    fragmentColor = vec4(color * lightColor, 1.0);
}
