//
//  BatchRenderer.m
//  Dabble
//
//  Created by Rakesh on 06/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLRenderer.h"

@implementation GLRenderer

-(id)initWithVertexShader:(NSString *)vertexShaderName andFragmentShader:(NSString *)fragmentShaderName
{
    if (self = [super init])
    {
        UNIFORM_MVPMATRIX = -1;
        shaderManager = [GLShaderManager sharedGLShaderManager];
        mvpMatrixManager = [MVPMatrixManager sharedMVPMatrixManager];
        program = [shaderManager getShaderByVertexShaderFileName:vertexShaderName andFragmentShaderFileName:fragmentShaderName];
        shaderType = program.shaderType;        
        primitive = GL_TRIANGLES;
        
        switch (shaderType) {
            case ShaderAttributeMatrixVertexColor:
                _vertexDataSize = sizeof(InstancedVertexColorData);
                [self setupMatrixVertexColorRenderer];
                break;
            case ShaderAttributeMatrixVertexColorTexture:
                _vertexDataSize = sizeof(InstancedTextureVertexColorData);
                [self setupMatrixVertexColorTextureRenderer];
                break;
            case ShaderAttributeVertexColor:
                _vertexDataSize = sizeof(VertexColorData);
                [self setupVertexColorRenderer];
                break;
            case ShaderAttributeVertexColorTexture:
                _vertexDataSize = sizeof(TextureVertexColorData);
                [self setupVertexColorTextureRenderer];
                break;
            case ShaderAttributeVertexColorPointSize:
                _vertexDataSize = sizeof(PointVertexColorSizeData);
                [self setupVertexColorPointSizeRenderer];
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)setupMatrixVertexColorRenderer
{
    ATTRIB_MVPMATRIX = [program attributeIndex:@"mvpmatrix"];
    ATTRIB_VERTEX = [program attributeIndex:@"vertex"];
    ATTRIB_COLOR = [program attributeIndex:@"color"];
    primitive = GL_TRIANGLES;
    
    fnDrawVBO  = (void (*)(id, SEL))[self methodForSelector:@selector(drawMatrixVertexColorRendererWithVBO)];
    selDrawVBO = @selector(drawMatrixVertexColorRendererWithVBO);
    
    fnDrawArray  = (void (*)(id, SEL))[self methodForSelector:@selector(drawMatrixVertexColorRendererWithArray)];
    selDrawArray = @selector(drawMatrixVertexColorRendererWithArray);
    
}

-(void)drawMatrixVertexColorRendererWithVBO
{
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 0);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 1);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 2);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 3);
    
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 0, 4, GL_FLOAT, 0,  sizeof(InstancedVertexColorData), (GLvoid*)0);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 1, 4, GL_FLOAT, 0,  sizeof(InstancedVertexColorData), (GLvoid*)16);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 2, 4, GL_FLOAT, 0,  sizeof(InstancedVertexColorData), (GLvoid*)32);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 3, 4, GL_FLOAT, 0,  sizeof(InstancedVertexColorData), (GLvoid*)48);
    
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(InstancedVertexColorData),
                          (GLvoid*)sizeof(Matrix3D));
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(InstancedVertexColorData),
                          (GLvoid*)sizeof(Matrix3D)+sizeof(Vertex3D));
    
    
    glDrawArrays(primitive, 0, dataCount);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)drawMatrixVertexColorRendererWithArray
{
    InstancedVertexColorData *data = (InstancedVertexColorData *)vertexData;

    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 0);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 1);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 2);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 3);
    
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 0, 4, GL_FLOAT, 0,
                          sizeof(InstancedVertexColorData), &data[0].mvpMatrix[0]);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 1, 4, GL_FLOAT, 0,
                          sizeof(InstancedVertexColorData), &data[0].mvpMatrix[4]);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 2, 4, GL_FLOAT, 0,
                          sizeof(InstancedVertexColorData), &data[0].mvpMatrix[8]);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 3, 4, GL_FLOAT, 0,
                          sizeof(InstancedVertexColorData), &data[0].mvpMatrix[12]);
    
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(InstancedVertexColorData),
                          &data[0].vertex);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(InstancedVertexColorData),
                          &data[0].color);
    
    
    glDrawArrays(primitive, 0, dataCount);
}


-(void)setupMatrixVertexColorTextureRenderer
{
    ATTRIB_MVPMATRIX = [program attributeIndex:@"mvpmatrix"];
    ATTRIB_VERTEX = [program attributeIndex:@"vertex"];
    ATTRIB_COLOR = [program attributeIndex:@"textureColor"];
    ATTRIB_TEXTURECOORD = [program attributeIndex:@"textureCoordinate"];
    primitive = GL_TRIANGLES;
    isTexture = YES;
    
    fnDrawVBO  = (void (*)(id, SEL))[self
                                     methodForSelector:@selector(drawMatrixVertexColorTextureRendererWithVBO)];
    selDrawVBO = @selector(drawMatrixVertexColorTextureRendererWithVBO);
    
    fnDrawArray  = (void (*)(id, SEL))[self methodForSelector:@selector(drawMatrixVertexColorTextureRendererWithArray)];
    selDrawArray = @selector(drawMatrixVertexColorTextureRendererWithArray);
}

-(void)drawMatrixVertexColorTextureRendererWithVBO
{
    glEnable(GL_TEXTURE_2D);
    [self.texture bindTexture];
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 0);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 1);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 2);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 3);
    
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 0, 4, GL_FLOAT, 0,  sizeof(InstancedTextureVertexColorData), (GLvoid*)0);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 1, 4, GL_FLOAT, 0,  sizeof(InstancedTextureVertexColorData), (GLvoid*)16);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 2, 4, GL_FLOAT, 0,  sizeof(InstancedTextureVertexColorData), (GLvoid*)32);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 3, 4, GL_FLOAT, 0,  sizeof(InstancedTextureVertexColorData), (GLvoid*)48);
    
    
    glEnableVertexAttribArray(ATTRIB_TEXTURECOORD);
    glVertexAttribPointer(ATTRIB_TEXTURECOORD, 2, GL_FLOAT, GL_TRUE,  sizeof(InstancedTextureVertexColorData),
                          (GLvoid*)sizeof(Matrix3D));
    
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(InstancedTextureVertexColorData),
                          (GLvoid*)sizeof(Matrix3D)+sizeof(TextureCoord));
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(InstancedTextureVertexColorData),
                          (GLvoid*)sizeof(Matrix3D)+sizeof(Vertex3D)+sizeof(TextureCoord));
    
    glDrawArrays(primitive, 0, dataCount);
    glDisable(GL_TEXTURE_2D);

}

-(void)drawMatrixVertexColorTextureRendererWithArray
{
    glEnable(GL_TEXTURE_2D);
    [self.texture bindTexture];
    
    InstancedTextureVertexColorData *data = (InstancedTextureVertexColorData *)vertexData;
    
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 0);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 1);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 2);
    glEnableVertexAttribArray(ATTRIB_MVPMATRIX + 3);
    
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 0, 4, GL_FLOAT, 0,
                          sizeof(InstancedTextureVertexColorData), &data->mvpMatrix[0]);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 1, 4, GL_FLOAT, 0,
                          sizeof(InstancedTextureVertexColorData), &data->mvpMatrix[4]);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 2, 4, GL_FLOAT, 0,
                          sizeof(InstancedTextureVertexColorData), &data->mvpMatrix[8]);
    glVertexAttribPointer(ATTRIB_MVPMATRIX + 3, 4, GL_FLOAT, 0,
                          sizeof(InstancedTextureVertexColorData), &data->mvpMatrix[12]);
    
    
    glEnableVertexAttribArray(ATTRIB_TEXTURECOORD);
    glVertexAttribPointer(ATTRIB_TEXTURECOORD, 2, GL_FLOAT, GL_TRUE,  sizeof(InstancedTextureVertexColorData),
                          &data->texCoord);
    
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(InstancedTextureVertexColorData),
                          &data->vertex);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(InstancedTextureVertexColorData),
                          &data->color);
    
    glDrawArrays(primitive, 0, dataCount);
    glDisable(GL_TEXTURE_2D);
    
}


-(void)setupVertexColorRenderer
{
    ATTRIB_VERTEX = [program attributeIndex:@"vertex"];
    ATTRIB_COLOR = [program attributeIndex:@"color"];
    UNIFORM_MVPMATRIX = [program uniformIndex:@"mvpmatrix"];
    primitive = GL_TRIANGLES;
    
    fnDrawVBO  = (void (*)(id, SEL))[self
                                     methodForSelector:@selector(drawVertexColorRendererWithVBO)];
    selDrawVBO = @selector(drawVertexColorRendererWithVBO);
    
    fnDrawArray  = (void (*)(id, SEL))[self methodForSelector:@selector(drawVertexColorRendererWithArray)];
    selDrawArray = @selector(drawVertexColorRendererWithArray);

}

-(void)drawVertexColorRendererWithVBO
{
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    Matrix3D result;
    [mvpMatrixManager getMVPMatrix:result];
    glUniformMatrix4fv(UNIFORM_MVPMATRIX, 1, GL_FALSE, result);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(VertexColorData),0);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(VertexColorData),
                          (GLvoid*)sizeof(Vertex3D));
    
    glDrawArrays(primitive, 0, dataCount);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)drawVertexColorRendererWithArray
{
    VertexColorData *data = (VertexColorData *)vertexData;
    
    Matrix3D result;
    [mvpMatrixManager getMVPMatrix:result];
    glUniformMatrix4fv(UNIFORM_MVPMATRIX, 1, GL_FALSE, result);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(VertexColorData),&data[0].vertex);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(VertexColorData),
                          &data[0].color);
    
   glDrawArrays(primitive, 0, dataCount);
    
}

-(void)setupVertexColorTextureRenderer
{
    ATTRIB_VERTEX = [program attributeIndex:@"vertex"];
    ATTRIB_COLOR = [program attributeIndex:@"textureColor"];
    ATTRIB_TEXTURECOORD = [program attributeIndex:@"textureCoordinate"];
    UNIFORM_MVPMATRIX = [program uniformIndex:@"mvpmatrix"];
        isTexture = YES;
    primitive = GL_TRIANGLES;
    
    fnDrawVBO  = (void (*)(id, SEL))[self
                                     methodForSelector:@selector(drawVertexColorTextureRendererWithVBO)];
    selDrawVBO = @selector(drawVertexColorTextureRendererWithVBO);
    
    fnDrawArray  = (void (*)(id, SEL))[self methodForSelector:@selector(drawVertexColorTextureRendererWithArray)];
    selDrawArray = @selector(drawVertexColorRendererWithArray);
    
}

-(void)drawVertexColorTextureRendererWithVBO
{
    glEnable(GL_TEXTURE_2D);
    [self.texture bindTexture];
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    Matrix3D result;
    [mvpMatrixManager getMVPMatrix:result];
    glUniformMatrix4fv(UNIFORM_MVPMATRIX, 1, GL_FALSE, result);
    
    
    glEnableVertexAttribArray(ATTRIB_TEXTURECOORD);
    glVertexAttribPointer(ATTRIB_TEXTURECOORD, 2, GL_FLOAT, GL_TRUE,  sizeof(TextureVertexColorData),
                          0);
    
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(TextureVertexColorData),
                          (GLvoid*)sizeof(TextureCoord));
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(TextureVertexColorData),
                          (GLvoid*)sizeof(Vertex3D)+sizeof(TextureCoord));
    
    glDrawArrays(primitive, 0, dataCount);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glDisable(GL_TEXTURE_2D);

}

-(void)drawVertexColorTextureRendererWithArray
{
    glEnable(GL_TEXTURE_2D);
    
    [self.texture bindTexture];

    TextureVertexColorData *data = (TextureVertexColorData *)vertexData;
    
    Matrix3D result;
    [mvpMatrixManager getMVPMatrix:result];
    glUniformMatrix4fv(UNIFORM_MVPMATRIX, 1, GL_FALSE, result);
    
    
    glEnableVertexAttribArray(ATTRIB_TEXTURECOORD);
    glVertexAttribPointer(ATTRIB_TEXTURECOORD, 2, GL_FLOAT, GL_TRUE,  sizeof(TextureVertexColorData),
                          &data->texCoord);
    
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(TextureVertexColorData),
                           &data->vertex);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(TextureVertexColorData),
                                &data->color);
    
    glDrawArrays(primitive, 0, dataCount);
    
    glDisable(GL_TEXTURE_2D);
    
}

-(void)setupVertexColorPointSizeRenderer
{
    UNIFORM_MVPMATRIX = [program attributeIndex:@"vertex"];
    ATTRIB_VERTEX = [program attributeIndex:@"vertex"];
    ATTRIB_COLOR = [program attributeIndex:@"color"];
    ATTRIB_POINTSIZE = [program attributeIndex:@"size"];
    primitive = GL_POINTS;
    
    
    fnDrawVBO  = (void (*)(id, SEL))[self
                                     methodForSelector:@selector(drawVertexColorPointSizeRendererWithVBO)];
    selDrawVBO = @selector(drawVertexColorPointSizeRendererWithVBO);
    
    fnDrawArray  = (void (*)(id, SEL))[self
                                       methodForSelector:@selector(drawVertexColorPointSizeRendererWithArray)];
    selDrawArray = @selector(drawVertexColorPointSizeRendererWithArray);
}

-(void)drawVertexColorPointSizeRendererWithVBO
{
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    
    Matrix3D result;
    [mvpMatrixManager getMVPMatrix:result];
    glUniformMatrix4fv(UNIFORM_MVPMATRIX, 1, GL_FALSE, result);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(PointVertexColorSizeData),0);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(PointVertexColorSizeData),
                          (GLvoid*)sizeof(Vertex3D));
    
    glEnableVertexAttribArray(ATTRIB_POINTSIZE);
    glVertexAttribPointer(ATTRIB_POINTSIZE, 1, GL_FLOAT, 0,  sizeof(PointVertexColorSizeData),
                          (GLvoid*)(sizeof(Vertex3D)+sizeof(Color4B)));
    
    glDrawArrays(primitive, 0, dataCount);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)drawVertexColorPointSizeRendererWithArray
{
    PointVertexColorSizeData *data = (PointVertexColorSizeData *)vertexData;
    
    Matrix3D result;
    [mvpMatrixManager getMVPMatrix:result];
    glUniformMatrix4fv(UNIFORM_MVPMATRIX, 1, GL_FALSE, result);
    
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 3, GL_FLOAT, 0,  sizeof(PointVertexColorSizeData),
                          &data[0].vertex);
    
    glEnableVertexAttribArray(ATTRIB_COLOR);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, GL_TRUE,  sizeof(PointVertexColorSizeData),
                          &data[0].color);
    
    glEnableVertexAttribArray(ATTRIB_POINTSIZE);
    glVertexAttribPointer(ATTRIB_POINTSIZE, 1, GL_FLOAT, 0,  sizeof(PointVertexColorSizeData),
                          &data[0].size);
    
    glDrawArrays(primitive, 0, dataCount);
    
}

-(void)drawWithArray:(void *)data andCount:(int)count
{
    vertexData = data;
    dataCount = count;
    [program use];
    fnDrawArray(self,selDrawArray);
}

-(void)drawWithVBO:(GLuint)_vbo andCount:(int)count
{
    vbo = _vbo;
    dataCount = count;
    [program use];
    fnDrawVBO(self,selDrawVBO);
}

-(void)drawWithArray:(void *)data andCount:(int)count andPrimitive:(GLenum)_primitive
{
    GLenum prevPrimitive = primitive;
    vertexData = data;
    dataCount = count;
    [program use];
    primitive = _primitive;
    fnDrawArray(self,selDrawArray);
    primitive = prevPrimitive;
}

-(void)drawWithVBO:(GLuint)_vbo andCount:(int)count  andPrimitive:(GLenum)_primitive
{
    GLenum prevPrimitive = primitive;
    vbo = _vbo;
    dataCount = count;
    [program use];
    primitive = _primitive;
    fnDrawVBO(self,selDrawVBO);
    primitive = prevPrimitive;
}



@end
