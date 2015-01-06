//
//  GLShaderManager.h
//  OpenGLES2.0
//
//  Created by Rakesh on 10/03/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLShaderProgram.h"

typedef enum
{
    ShaderAttributeVertexColor = 1,
    ShaderAttributeVertexColorTexture = 2,
    ShaderAttributeMatrixVertexColor = 3,
    ShaderAttributeMatrixVertexColorTexture = 4,
    ShaderAttributeVertexColorPointSize = 5
    
}ShaderAttributeTypes;

@interface GLShaderManager : NSObject
{
    NSMutableDictionary *shaders;
}
+(id)sharedGLShaderManager;
-(GLShaderProgram *)getShaderByVertexShaderFileName:(NSString *)vertexShaderFilename andFragmentShaderFileName:(NSString *)fragmentShaderFilename;


@end
