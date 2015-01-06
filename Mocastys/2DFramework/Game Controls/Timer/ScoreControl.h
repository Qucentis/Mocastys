//
//  TimerControl.h
//  Dabble
//
//  Created by Rakesh on 03/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "ElasticCounter.h"
#import "SoundManager.h"

#define SCORECONTROLEVENT_TOUCHDOWN 1
#define SCORECONTROLEVENT_TOUCHUP 2
#define SCORECONTROLEVENT_TOUCHCANCELLED 3

@class ScoreControl;

@protocol ScoreControlDelegate
-(void)scoreControl:(ScoreControl *)sender withEvent:(int)eventType;
@end

@interface ScoreControl : GLElement 
{
    CGFloat timeLeft;
    CGFloat *numberSizes;
    
    GLShaderProgram *textureShaderProgram;
    FontSpriteSheet *fontSpriteSheet;
    
    InstancedTextureVertexColorData *vertexData;
    int vertexDataCount;
    
    GLRenderer *textureRenderer;
    
    NSMutableArray *counterControls;
    
    NSArray *numberArray;
    
    BOOL *running;
    int visibleCount;
    CGFloat widthPerCounter;
    
    CGFloat offsetVisibleX;
    
    UITextAlignment textAlignment;
    
    Color4B backgroundHighlightColor;
    Color4B backgroundNormalColor;
    
    SoundManager *soundManager;
}

-(void)setBackgroundColor:(Color4B)backgroundColor;
-(void)setBackgroundHighlightColor:(Color4B)highlightColor;

-(void)setTextAlignment:(UITextAlignment)_textAlignment;
-(void)setFont:(NSString *)font withSize:(CGFloat)size;
-(void)stop;
-(void)setValue:(long long)value inDuration:(CGFloat)time;
-(CGFloat)getVisibleWidth;

@property (nonatomic) Color4B textColor;
@property (nonatomic,retain) NSObject<ScoreControlDelegate> *delegate;

@end
