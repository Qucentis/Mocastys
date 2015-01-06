attribute  vec4 vertex;
attribute  vec2 textureCoordinate;
attribute  vec4 textureColor;

uniform  mat4 mvpmatrix;

varying lowp vec2 fragmentTextureCoordinates;
varying lowp vec4 textureFragColor;

void main()
{
    gl_Position = mvpmatrix * vertex;
    fragmentTextureCoordinates = textureCoordinate;
    textureFragColor = textureColor;
}