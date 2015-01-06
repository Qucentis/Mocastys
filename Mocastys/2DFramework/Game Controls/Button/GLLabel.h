//
//  GLLabel.h
//  Dabble
//
//  Created by Rakesh on 24/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"

@interface GLLabel : GLElement
{
    GLRenderer *textureRenderer;
    Texture2D *texture;
    TextureVertexColorData *textureVertexColorData;
    GLuint vbo;
    CGFloat offset;
    UITextAlignment horizontalTextAlignment;
    UITextVerticalAlignment verticalTextAlignment;
}

@property (nonatomic,readonly) UIFont *font;
@property (nonatomic) BOOL usesTextureManager;
@property (nonatomic,readonly) NSString *text;
@property (nonatomic,readonly) Color4B textColor;
@property (nonatomic,readonly) CGFloat marginVertical;
@property (nonatomic,readonly) CGFloat marginHorizontal;

-(void)setText:(NSString *)text withHorizontalAlignment:(UITextAlignment)htextAlignment andVerticalAlignment:(UITextVerticalAlignment)vtextAlignment;
-(void)setFont:(NSString *)font withSize:(CGFloat)size;
-(void)setTextColor:(Color4B)textColor;

@end
