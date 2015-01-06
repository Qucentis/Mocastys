//
//  BatchRenderer.h
//  Dabble
//
//  Created by Rakesh on 06/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLShaderManager.h"
#import "GLCommon.h"
#import "MVPMatrixManager.h"
#import "Texture2D.h"

@interface GLRenderer : NSObject
{
    GLint UNIFORM_MVPMATRIX;
    
    GLuint ATTRIB_VERTEX;
    GLuint ATTRIB_COLOR;
    GLuint ATTRIB_POINTSIZE;
    GLuint ATTRIB_MVPMATRIX;
    GLuint ATTRIB_TEXTURECOORD;
    
    GLShaderManager *shaderManager;
    MVPMatrixManager *mvpMatrixManager;
    GLShaderProgram *program;
    
    ShaderAttributeTypes shaderType;
    
    GLenum primitive;
    
    bool isTexture;
    
    int dataCount;
    GLuint vbo;
    
    void *vertexData;
    
    
    void (*fnDrawVBO)(id, SEL);
    void (*fnDrawArray)(id, SEL);
    
    SEL selDrawVBO;
    SEL selDrawArray;
    
}
@property (nonatomic)  size_t vertexDataSize;
@property (nonatomic,assign) Texture2D *texture;
-(id)initWithVertexShader:(NSString *)vertexShaderName andFragmentShader:(NSString *)fragmentShaderName;
-(void)drawWithArray:(void *)data andCount:(int)count;
-(void)drawWithVBO:(GLuint)_vbo andCount:(int)count;

-(void)drawWithArray:(void *)data andCount:(int)count andPrimitive:(GLenum)_primitive;
-(void)drawWithVBO:(GLuint)_vbo andCount:(int)count  andPrimitive:(GLenum)_primitive;

@end
