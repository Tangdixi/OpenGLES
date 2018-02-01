#version 300 es
layout(location = 0) in vec4 position;
layout(location = 1) in vec4 aColorPosition;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

out vec4 colorPosition;

void main() {
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * position;
}
