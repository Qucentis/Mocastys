//
//  GLImageView.h
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"

@interface GLImageView : GLElement
{
    GLRenderer *textureRenderer;
    
    TextureVertexColorData *textureVertexColorData;
    
    Texture2D *buttonTexture;
    Color4B backgroundColor;
    Color4B imageColor;
    Color4B backgroundHightlightColor;
    Color4B imageHighlightColor;
    
}

@property (nonatomic) GLuint blendModeSrc;
@property (nonatomic) GLuint blendModeDest;
@property (nonatomic,assign) NSObject *target;
@property (nonatomic) SEL selector;
@property (nonatomic) BOOL usesTextureManager;

-(void)setUIImage:(UIImage *)image;
-(void)setImage:(NSString *)imageName ofType:(NSString *)type;
-(void)setTexture:(Texture2D *)texture;
-(void)setBackgroundColor:(Color4B)_color;
-(void)setBackgroundHightlightColor:(Color4B)_color;
-(void)setImageHighlightColor:(Color4B)_color;
-(void)setImageColor:(Color4B)_color;
-(void)setHighlight:(BOOL)highlight InDuration:(CGFloat)duration afterDelay:(CGFloat)delay;
-(void)setImageAsync:(NSString *)imageName ofType:(NSString *)type;
-(void)setImageWithPathAsync:(NSString *)imageName ofType:(NSString *)type;

-(Animation *)changeImageColorFrom:(Color4B)startColor To:(Color4B)endColor withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;

@end
