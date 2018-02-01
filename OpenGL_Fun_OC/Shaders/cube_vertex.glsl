#version 300 es
layout(location = 0) in vec4 position;
layout(location = 1) in vec4 aColorPosition;
//layout(location = 2) in vec4 aTextureCoordinate;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

out vec4 colorPosition;
//out vec4 textureCoordinate;

void main() {
    gl_Position = position;
    colorPosition = aColorPosition;
//    textureCoordinate = aTextureCoordinate;
}
