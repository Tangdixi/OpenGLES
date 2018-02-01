#version 300 es
precision mediump float;

in vec4 colorPosition;
//in vec4 textureCoordinate;

//uniform sampler2D aTexture;

out vec4 fragmentColor;

void main() {
//    fragmentColor = texture(aTexture, textureCoordinate);
    fragmentColor = colorPosition;
}
