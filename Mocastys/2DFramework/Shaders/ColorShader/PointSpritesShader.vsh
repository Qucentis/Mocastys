
attribute vec4 vertex;
attribute vec4 color;
attribute float size;

uniform  mat4 mvpmatrix;

varying lowp vec4 frag_color;

void main()
{
    gl_Position = mvpmatrix * vertex;
    gl_PointSize = size;
    frag_color = color;
}