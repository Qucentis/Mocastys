//
//  GLButton.h
//  Dabble
//
//  Created by Rakesh on 19/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLLabel.h"
#import "SoundManager.h"

@interface GLImageButton : GLElement 
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
@property (nonatomic,retain) GLLabel *textLabel;
@property (nonatomic,readonly) Color4B backgroundColor;
@property (nonatomic,readonly) Color4B imageColor;
@property (nonatomic,readonly) Color4B backgroundHightlightColor;
@property (nonatomic,readonly) Color4B imageHighlightColor;

-(void)setImage:(NSString *)imageName ofType:(NSString *)type;
-(void)setBackgroundColor:(Color4B)_color;
-(void)setBackgroundHightlightColor:(Color4B)_color;
-(void)setImageHighlightColor:(Color4B)_color;
-(void)setImageColor:(Color4B)_color;
-(void)setStringTextureRenderer:(BOOL)use;
-(void)setTexture:(Texture2D *)texture;

-(void)addTarget:(NSObject *)target andSelector:(SEL)selector;


-(Animation *)changeImageColorFrom:(Color4B)startColor To:(Color4B)endColor withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;
@end
