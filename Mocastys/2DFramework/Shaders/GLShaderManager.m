//
//  GLShaderManager.m
//
//
//  Created by Rakesh on 10/03/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLShaderManager.h"
#import "GLShaderProgram.h"
#import "SynthesizeSingleton.h"


@implementation GLShaderManager

SYNTHESIZE_SINGLETON_FOR_CLASS(GLShaderManager)

-(id)init
{
    if (self = [super init])
    {
        shaders = [[NSMutableDictionary alloc]init];
    }
    return self;
}


-(ShaderAttributeTypes)getAttributeType:(NSString *)vertexShaderName
{
    if ([vertexShaderName isEqualToString:@"ColorShader"])
    {
        return ShaderAttributeVertexColor;
    }
    else  if ([vertexShaderName isEqualToString:@"TextureShader"])
    {
        return ShaderAttributeVertexColorTexture;
    }
    else  if ([vertexShaderName isEqualToString:@"InstancedTextureShader"])
    {
        return ShaderAttributeMatrixVertexColorTexture;
    }
    else  if ([vertexShaderName isEqualToString:@"InstancedColorShader"])
    {
        return ShaderAttributeMatrixVertexColor;
    }
    else if ([vertexShaderName isEqualToString:@"PointSpritesShader"])
    {
        return ShaderAttributeVertexColorPointSize;
    }
    
    return -1;
}

-(void)addAttributesOfType:(ShaderAttributeTypes)attType toShader:(GLShaderProgram *)program
{
    if (attType == ShaderAttributeVertexColor)
    {
        [program addAttribute:@"vertex"];
        [program addAttribute:@"color"];
        
    }
    else if (attType == ShaderAttributeVertexColorTexture)
    {
        [program addAttribute:@"vertex"];
        [program addAttribute:@"textureColor"];
        [program addAttribute:@"textureCoordinate"];
    }
    else if (attType == ShaderAttributeMatrixVertexColor)
    {

        [program addAttribute:@"vertex"];
        [program addAttribute:@"color"];
        [program addAttribute:@"mvpmatrix"];
    }
    else if (attType == ShaderAttributeMatrixVertexColorTexture)
    {
     
        [program addAttribute:@"vertex"];
        [program addAttribute:@"textureColor"];
        [program addAttribute:@"textureCoordinate"];
        [program addAttribute:@"mvpmatrix"];
    }
    else if (attType == ShaderAttributeVertexColorPointSize)
    {
        [program addAttribute:@"vertex"];
        [program addAttribute:@"color"];
        [program addAttribute:@"size"];
    }
}

-(GLShaderProgram *)getShaderByVertexShaderFileName:(NSString *)vertexShaderFilename andFragmentShaderFileName:(NSString *)fragmentShaderFilename
{
    NSString *key = [NSString stringWithFormat:@"%@&%@",vertexShaderFilename,fragmentShaderFilename];
    
    GLShaderProgram *shader;
    
    shader = shaders[key];
    
    ShaderAttributeTypes type = [self getAttributeType:vertexShaderFilename];
    
    if (shader == nil)
    {
        shader = [[GLShaderProgram alloc]initWithVertexShaderFilename:vertexShaderFilename
                                               fragmentShaderFilename:fragmentShaderFilename];
        shaders[key] = shader;
        [shader release];
    }
    
    [self addAttributesOfType:type toShader:shader];
    
    if (![shader link])
        NSLog(@"Link unsuccessful");
    
    shader.shaderType = type;
    return shader;
}

@end
