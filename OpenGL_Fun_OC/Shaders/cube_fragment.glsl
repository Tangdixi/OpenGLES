#version 300 es
precision mediump float;
in vec4 colorPosition;
out vec4 fragmentColor;
void main() {
    fragmentColor = colorPosition;
}
