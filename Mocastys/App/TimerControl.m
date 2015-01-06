//
//  TimerControl.m
//  KBC
//
//  Created by Rakesh on 30/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "TimerControl.h"

#define MAX_VALUE 70.0f

@implementation TimerControl

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        shown = YES;
        imageView = [[GLImageView alloc]init];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            [imageView setImage:@"c_rt_timer_bkg-iPad" ofType:@"png"];
            CIRCLE_SIZE = 80.0;
            fontSize = 28;
            ignoreTouchRadius = 5000;
        }
        else
        {
            [imageView setImage:@"c_rt_timer_bkg" ofType:@"png"];
            CIRCLE_SIZE = 40.0;
            fontSize = 14;
            ignoreTouchRadius = 2500;
        }
        imageView.blendModeSrc = GL_SRC_ALPHA;
        [imageView setImageColor:Color4BFromHex(0xffffffaa)];
        
        textView = [[GLButton alloc]init];
        textView.buttonLabel.usesTextureManager = YES;
        self.center = CGPointMake(_frame.size.width/2,_frame.size.height/2);
        
        [self addElement:imageView];
        [imageView release];
        [self addElement:textView];
        [textView release];
        imageView.acceptsTouches = NO;
        textView.acceptsTouches = NO;
    }
    return self;
}

-(void)elementDidAppear
{
    [super elementDidAppear];
   // shown = YES;
}

-(void)showInDuration:(CGFloat)duration afterDelay:(CGFloat)delay
{
    if (shown)
        return;
    self.enabled = YES;
    shown= YES;
    if (duration == 0)
    {
        textView.scaleOfElement = CGPointMake(1, 1);
        imageView.scaleOfElement = CGPointMake(1, 1);
        return;
    }
    
    textView.scaleOfElement = CGPointMake(0, 0);
    imageView.scaleOfElement = CGPointMake(0, 0);

    EasingAnimation *animation1 = (EasingAnimation *)[imageView scaleFrom:CGPointMake(0, 0) To:CGPointMake(1, 1) withDuration:duration afterDelay:delay usingCurve:EasingOrdered];
    animation1.easingType = EaseOut;
    EasingAnimation *animation2 = (EasingAnimation *)[textView scaleFrom:CGPointMake(0, 0) To:CGPointMake(1, 1) withDuration:duration afterDelay:delay usingCurve:EasingOrdered];
    animation2.easingType = EaseOut;
    
    
}

-(void)hideInDuration:(CGFloat)duration afterDelay:(CGFloat)delay
{
    if (!shown)
        return;
    self.enabled = NO;
    shown = NO;
    if (duration == 0)
    {
        textView.scaleOfElement = CGPointMake(0, 0);
        imageView.scaleOfElement = CGPointMake(0, 0);
        return;
    }
    textView.scaleOfElement = CGPointMake(1, 1);
    imageView.scaleOfElement = CGPointMake(1, 1);
    
    [imageView scaleFrom:CGPointMake(1, 1) To:CGPointMake(0, 0) withDuration:duration afterDelay:delay usingCurve:EasingOrdered];
    [textView scaleFrom:CGPointMake(1, 1) To:CGPointMake(0, 0) withDuration:duration afterDelay:delay usingCurve:EasingOrdered];
    

}


-(void)setValue:(int)value
{
    
    if (abs(_value - value)>20)
        return;
    _value = value;
    if (_value >= 60)
        _value = 60;
    else if (_value < 10)
        _value = 10;
    CGFloat x = -self.radius * cosf(M_PI * _value/MAX_VALUE) + self.center.x;
    CGFloat y = self.radius * sinf(M_PI * _value/MAX_VALUE) + self.center.y;
    
    imageView.frame = CGRectMake(x - CIRCLE_SIZE/2, y - CIRCLE_SIZE/2, CIRCLE_SIZE, CIRCLE_SIZE);
    textView.frame = CGRectMake(x - CIRCLE_SIZE/2, y - CIRCLE_SIZE/2, CIRCLE_SIZE, CIRCLE_SIZE);
   [textView setText:[NSString stringWithFormat:@"%d",_value] withFont:@"Lato-Bold" andSize:fontSize andHorizontalTextAligntment:UITextAlignmentCenter andVerticalTextAlignment:UITextAlignmentMiddle];
    [textView setTextColor:(Color4B){0,0,0,255}];
    [self.delegate changeValueOfTimerControl:_value];
     
}


-(BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint l = [touch locationInGLElement:self];
    
    CGFloat radius = (l.x - self.center.x) * (l.x - self.center.x) +
    (l.y - self.center.y) * (l.y - self.center.y);
    
    if (radius < ignoreTouchRadius)
        return NO;
    
    CGRect absframe = self.absoluteFrame;
    if (l.x >= 0 && l.y >=0 && l.x <=absframe.size.width && l.y<=absframe.size.height)
    {
        for (GLElement *element in subElements.reverseObjectEnumerator)
        {
            if ([element touchBegan:touch withEvent:event])
                return YES;
        }
        
        if (!self.acceptsTouches)
            return NO;
        if (!self.enabled)
            return NO;
        
        [touchesInElement addObject:touch];
        [self touchBeganInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        return YES;
    }
    
    return NO;
}
-(BOOL)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    for (GLElement *element in subElements.reverseObjectEnumerator)
    {
        if ([element touchMoved:touch withEvent:event])
            return YES;
    }
    
    
    if (!self.acceptsTouches)
        return NO;
    if (!self.enabled)
        return NO;
    
    if ([touchesInElement containsObject:touch])
    {
        [self touchMovedInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        return YES;
    }
    return NO;
}
-(BOOL)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    for (GLElement *element in subElements.reverseObjectEnumerator)
    {
        if ([element touchEnded:touch withEvent:event])
            return YES;
    }
    
    
    if (!self.acceptsTouches)
        return NO;
    if (!self.enabled)
        return NO;
    
    
    if ([touchesInElement containsObject:touch])
    {
        CGPoint touchPoint = [touch locationInGLElement:self];
        CGRect absframe = self.absoluteFrame;
        if (touchPoint.x >= 0 && touchPoint.y >= 0 &&
            touchPoint.x <= absframe.size.width && touchPoint.y <=absframe.size.height)
            [self touchEndedInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        else
            [self touchCancelledInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        [touchesInElement removeObject:touch];
        return YES;
    }
    return NO;
}


-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    CGPoint l = [touch locationInGLElement:self];
    if ((l.x - self.center.x) == 0.0f)
        return;
    CGFloat angle = atan2f((l.x - self.center.x),(l.y - self.center.y));
    int side = ((angle * MAX_VALUE)/ M_PI)+ 30;
    self.value = side;
    
    [self.delegate setActiveTimerControl];
}
-(void)touchMovedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    CGPoint l = [touch locationInGLElement:self];
    if ((l.y - self.center.y) == 0.0f)
        return;
        CGFloat angle = atan2f((l.x - self.center.x),(l.y - self.center.y));
    int side = ((angle * MAX_VALUE)/ M_PI) + 30;
    self.value = side;
}
-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self.delegate setInactiveTimerControl];
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self.delegate setInactiveTimerControl];
}
 


-(void)dealloc
{
    self.delegate = nil;
       [super dealloc];
}

@end
