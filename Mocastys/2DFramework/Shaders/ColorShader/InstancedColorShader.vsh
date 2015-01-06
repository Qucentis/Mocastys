attribute  mat4 mvpmatrix;
attribute  vec4 vertex;
attribute  vec4 color;

varying lowp vec4 frag_color;

void main()
{
    gl_Position = mvpmatrix * vertex;
    frag_color = color;
}