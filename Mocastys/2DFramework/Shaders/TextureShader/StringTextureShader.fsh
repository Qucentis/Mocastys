uniform sampler2D texture;
varying lowp vec2 fragmentTextureCoordinates;
varying lowp vec4 textureFragColor;

void main()
{
    lowp vec4 texel =  vec4(textureFragColor.rgb,texture2D(texture, fragmentTextureCoordinates).a * textureFragColor.a);
    gl_FragColor = texel;
}