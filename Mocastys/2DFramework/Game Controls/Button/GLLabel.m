//
//  GLLabel.m
//  Dabble
//
//  Created by Rakesh on 24/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLLabel.h"

@implementation GLLabel

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        self.acceptsTouches = NO;
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"StringTextureShader"];
        
        textureVertexColorData = malloc(sizeof(TextureVertexColorData) * 6);
        self.textColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        verticalTextAlignment = UITextAlignmentMiddle;
        horizontalTextAlignment = UITextAlignmentCenter;
        _usesTextureManager = NO;
        
        for (int i = 0;i<6;i++)
        {
            textureVertexColorData[i].color = self.textColor;
        }
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        self.acceptsTouches = NO;
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"StringTextureShader"];
        
        textureVertexColorData = malloc(sizeof(TextureVertexColorData) * 6);
        self.textColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        verticalTextAlignment = UITextAlignmentMiddle;
        horizontalTextAlignment = UITextAlignmentCenter;
        _usesTextureManager = NO;
        
        for (int i = 0;i<6;i++)
        {
            textureVertexColorData[i].color = self.textColor;
        }

    }
    return self;
}

-(void)setMarginHorizontal:(CGFloat)hMargin andVertical:(CGFloat)vMargin
{
    _marginHorizontal = hMargin;
    _marginVertical = vMargin;
}

-(void)setText:(NSString *)text withHorizontalAlignment:(UITextAlignment)htextAlignment andVerticalAlignment:(UITextVerticalAlignment)vtextAlignment
{
    if (_text != nil)
    {
//        NSLog(@"%d",_text.retainCount);
        [_text release];
    }
    _text = [text retain];
    horizontalTextAlignment = htextAlignment;
    verticalTextAlignment = vtextAlignment;
    [self setupLabel];
}

-(void)setFont:(NSString *)font withSize:(CGFloat)size
{
    _font = [UIFont fontWithName:font size:size];
    [self setupLabel];
}

-(void)setTextColor:(Color4B)textColor
{
    _textColor = textColor;
    for (int i = 0;i<6;i++)
    {
        textureVertexColorData[i].color = self.textColor;
    }
}

-(void)setRequiresMipMap:(BOOL)_requiresMipMap
{
    requiresMipMap = _requiresMipMap;
    [texture generateMipMap];
}

-(void)setUsesTextureManager:(BOOL)usesTextureManager
{
    if (texture != nil && !_usesTextureManager)
    {
        if (!texture.wasCachedInTextureManager)
        {
            [texture release];
            texture = nil;
        }
    }
    
    _usesTextureManager = usesTextureManager;
    
    [self setupLabel];
}

-(void)setupLabel
{
    if (texture != nil && !texture.wasCachedInTextureManager)
        [texture release];
    
    if (self.text == nil)
        return;
    
    if (_usesTextureManager)
    {
        texture = [textureManager getStringTexture:self.text dimensions:self.frame.size horizontalAlignment:horizontalTextAlignment verticalAlignment:verticalTextAlignment fontName:self.font.fontName fontSize:self.font.pointSize];
    }
    else
    {
        texture = [[Texture2D alloc]initWithString:self.text dimensions:self.frame.size horizontalAlignment:horizontalTextAlignment verticalAlignment:verticalTextAlignment fontName:self.font.fontName fontSize:self.font.pointSize];
    }
    if (requiresMipMap)
    {
        [texture generateMipMap];
    }

    Vertex3D *vertices = [texture getTextureVertices];
    TextureCoord *texCoords = [texture getTextureCoordinates];
    for (int i = 0;i<6;i++)
    {
        textureVertexColorData[i].vertex = vertices[i];
        textureVertexColorData[i].texCoord = texCoords[i];
    }
    
}

-(void)draw
{
    if (texture != nil)
    {
        [mvpMatrixManager pushModelViewMatrix];
        [mvpMatrixManager translateInX:self.frame.size.width/2
                                     Y:self.frame.size.height/2 Z:1];
        [mvpMatrixManager scaleByXScale:self.scaleInsideElement.x YScale:self.scaleInsideElement.y ZScale:1];
        [mvpMatrixManager translateInX:self.originInsideElement.x Y:self.originInsideElement.y Z:0];
        glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
        [textureRenderer setTexture:texture];
        [textureRenderer drawWithArray:textureVertexColorData andCount:6];
        glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
        [mvpMatrixManager popModelViewMatrix];
    }
   
}

-(void)dealloc
{
    if (texture!= nil && texture.wasCachedInTextureManager)
        [texture release];
    free(textureVertexColorData);
    if (_text != nil)
        [_text release];
    [super dealloc];
}
@end
