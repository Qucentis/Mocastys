//
//  GLButton.m
//  Dabble
//
//  Created by Rakesh on 19/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLButton.h"

#define ANIMATION_HIGHLIGHT 1
#define ANIMATION_NORMAL 2


@implementation GLButton

@synthesize buttonLabel,backgroundImageView;

-(id)init
{
    if (self = [super init])
    {
        textColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        backgroundColor = (Color4B){.red = 0,.green = 0,.blue = 0,.alpha = 128};
        backgroundHightlightColor = textColor;
        textHighlightColor = backgroundColor;
        
        backgroundImageView = [[GLImageView alloc]init];
        [self addElement:backgroundImageView];
        [backgroundImageView release];
        
        buttonLabel = [[GLLabel alloc]init];
        [self addElement:buttonLabel];
        [buttonLabel release];
        
        backgroundImageView.acceptsTouches = NO;
    }
    return self;
}

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        textColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        backgroundColor = (Color4B){.red = 0,.green = 0,.blue = 0,.alpha = 128};
        backgroundHightlightColor = textColor;
        textHighlightColor = backgroundColor;
        
        backgroundImageView = [[GLImageView alloc]initWithFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
        [self addElement:backgroundImageView];
        [backgroundImageView release];
        
        buttonLabel = [[GLLabel alloc]initWithFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
        [self addElement:buttonLabel];
        [buttonLabel release];
        
        backgroundImageView.acceptsTouches = NO;
    }
    return self;
}

-(void)setFrame:(CGRect)_frame
{
    [super setFrame:_frame];
    [buttonLabel setFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
    [backgroundImageView setFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
            backgroundImageView.acceptsTouches = NO;
}

-(void)setFont:(NSString *)font withSize:(CGFloat)size
{
    [buttonLabel setFont:font withSize:size];
}

-(void)setText:(NSString *)text withFont:(NSString *)font andSize:(CGFloat)size
{
    [buttonLabel setFont:font withSize:size];
    [buttonLabel setText:text withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
}
-(void)setText:(NSString *)text withFont:(NSString *)font andSize:(CGFloat)size andHorizontalTextAligntment:(UITextAlignment)horizAlignment andVerticalTextAlignment:(UITextVerticalAlignment)vertAlignment
{
    [buttonLabel setFont:font withSize:size];
    [buttonLabel setText:text withHorizontalAlignment:horizAlignment
    andVerticalAlignment:vertAlignment];
}


-(void)setRequiresMipMap:(BOOL)_requiresMipMap
{
    [buttonLabel setRequiresMipMap:_requiresMipMap];
}


-(void)setHighlight:(BOOL)highlight InDuration:(CGFloat)duration afterDelay:(CGFloat)delay
{
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_NORMAL];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_HIGHLIGHT];
    [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_NORMAL];
    [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_HIGHLIGHT];
    
    if (highlight)
    {
        Animation *animation  = [animator addCustomAnimationFor:self withIdentifier:ANIMATION_HIGHLIGHT withDuration:duration afterDelayInSeconds:delay];
        animation.animationUpdateBlock = ^(Animation *anim)
        {
            CGFloat animationRatio = [anim getAnimatedRatio];
            
            CGFloat red = getEaseOutQuad(backgroundColor.red, backgroundHightlightColor.red, animationRatio);
            CGFloat green = getEaseOutQuad(backgroundColor.green, backgroundHightlightColor.green, animationRatio);
            CGFloat blue = getEaseOutQuad(backgroundColor.blue, backgroundHightlightColor.blue, animationRatio);
            CGFloat alpha = getEaseOutQuad(backgroundColor.alpha, backgroundHightlightColor.alpha, animationRatio);
            CGFloat tred = getEaseOutQuad(textColor.red, textHighlightColor.red, animationRatio);
            CGFloat tgreen = getEaseOutQuad(textColor.green, textHighlightColor.green, animationRatio);
            CGFloat tblue = getEaseOutQuad(textColor.blue, textHighlightColor.blue, animationRatio);
            
            
            Color4B intermediate = (Color4B){.red = red, .green = green, .blue = blue,.alpha =  alpha};
            Color4B tintermediate = (Color4B){.red = tred, .green = tgreen, .blue = tblue,.alpha = buttonLabel.textColor.alpha};
            
            [buttonLabel setTextColor:tintermediate];
            [self setFrameBackgroundColor:intermediate];
            return NO;
        };
        
    }
    else
    {
        Animation *animation  = [animator addCustomAnimationFor:self withIdentifier:ANIMATION_NORMAL withDuration:duration afterDelayInSeconds:delay];
        
        animation.animationUpdateBlock = ^(Animation *anim)
        {
            CGFloat animationRatio = [anim getAnimatedRatio];
            
            
            CGFloat red = getEaseOutQuad(backgroundHightlightColor.red, backgroundColor.red, animationRatio);
            CGFloat green = getEaseOutQuad(backgroundHightlightColor.green, backgroundColor.green, animationRatio);
            CGFloat blue = getEaseOutQuad(backgroundHightlightColor.blue, backgroundColor.blue, animationRatio);
            CGFloat alpha = getEaseOutQuad(backgroundHightlightColor.alpha, backgroundColor.alpha, animationRatio);
            
            
            
            CGFloat tred = getEaseOutQuad(textHighlightColor.red, textColor.red, animationRatio);
            CGFloat tgreen = getEaseOutQuad(textHighlightColor.green, textColor.green, animationRatio);
            CGFloat tblue = getEaseOutQuad(textHighlightColor.blue, textColor.blue, animationRatio);
            
            
            Color4B intermediate = (Color4B){.red = red, .green = green, .blue = blue,.alpha =  alpha};
            Color4B tintermediate = (Color4B){.red = tred, .green = tgreen, .blue = tblue,.alpha = buttonLabel.textColor.alpha};
            
            [buttonLabel setTextColor:tintermediate];
            [self setFrameBackgroundColor:intermediate];
            
            return NO;
        };
        
    }
}

-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self setHighlight:YES InDuration:0.2 afterDelay:0];
}

-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self setHighlight:NO InDuration:0.2 afterDelay:0];
    [_target performSelector:_selector];
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self setHighlight:NO InDuration:0.2 afterDelay:0];
}

-(void)addTarget:(NSObject *)target andSelector:(SEL)selector
{
    self.target = target;
    self.selector = selector;
}

-(void)setBackgroundColor:(Color4B)_color
{
    backgroundColor = _color;
    self.frameBackgroundColor = _color;
}

-(void)setTextColor:(Color4B)_color
{
    textColor = _color;
    [buttonLabel setTextColor:textColor];
}

-(void)setBackgroundHightlightColor:(Color4B)_color
{
    backgroundHightlightColor = _color;
}
-(void)setTextHighlightColor:(Color4B)_color
{
    textHighlightColor = _color;
}


-(void)dealloc
{
    self.target = nil;
    [super dealloc];
}

@end
