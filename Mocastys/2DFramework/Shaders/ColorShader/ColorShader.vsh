
attribute  vec4 vertex;
attribute  vec4 color;

uniform  mat4 mvpmatrix;

varying lowp vec4 frag_color;

void main()
{
    gl_Position = mvpmatrix * vertex;
    frag_color = color;
}