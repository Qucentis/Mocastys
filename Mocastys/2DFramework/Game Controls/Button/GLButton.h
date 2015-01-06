//
//  GLButton.h
//  Dabble
//
//  Created by Rakesh on 19/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "SoundManager.h"
#import "GLLabel.h"
#import "GLImageView.h"

@interface GLButton : GLElement
{
    GLLabel *buttonLabel;
    GLImageView *backgroundImageView;
    
    Color4B backgroundColor;
    Color4B textColor;
    Color4B backgroundHightlightColor;
    Color4B textHighlightColor;
    SoundManager *soundManager;
    
}

@property (nonatomic,assign) NSObject *target;
@property (nonatomic,readonly) GLLabel *buttonLabel;
@property (nonatomic,readonly)     GLImageView *backgroundImageView;
@property (nonatomic) SEL selector;

-(void)setTextColor:(Color4B)_color;
-(void)setBackgroundColor:(Color4B)_color;
-(void)setBackgroundHightlightColor:(Color4B)_color;
-(void)setTextHighlightColor:(Color4B)_color;
-(void)addTarget:(NSObject *)target andSelector:(SEL)selector;

-(void)setFont:(NSString *)font withSize:(CGFloat)size;
-(void)setText:(NSString *)text withFont:(NSString *)font andSize:(CGFloat)size;
-(void)setText:(NSString *)text withFont:(NSString *)font andSize:(CGFloat)size andHorizontalTextAligntment:(UITextAlignment)horizAlignment andVerticalTextAlignment:(UITextVerticalAlignment)vertAlignment;
@end
