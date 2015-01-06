uniform sampler2D texture;
varying lowp vec2 fragmentTextureCoordinates;
varying lowp vec4 textureFragColor;

void main()
{
    lowp vec4 texel =  texture2D(texture, fragmentTextureCoordinates);
  
    gl_FragColor = textureFragColor * texel;// vec4(texel.r / texel.a, texel.g/ texel.a, texel.b / texel.a, texel.a);
}