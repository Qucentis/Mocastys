//
//  GLScrollView.m
//  KBC
//
//  Created by Rakesh on 02/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLVerticalScrollElement.h"

#define ANIMATION_BOUNCEBACK 1
#define delayForTouch 0.05

#define maximumBounceBackDistance 70


@implementation GLVerticalScrollElement

@synthesize heightOfContent;

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        verticalSwipeRecognizer = [[SwipeGestureRecognizer alloc]init];
        [self addGestureRecognizer:verticalSwipeRecognizer];
        [verticalSwipeRecognizer setGestures:GESTURE_VERTICALSWIPE];
        [verticalSwipeRecognizer addTarget:self andSelector:@selector(scrollDetected:)];
        [verticalSwipeRecognizer release];
        heightOfContent = self.frame.size.height;
    }
    return self;
}

-(void)scrollDetected:(NSArray *)eventArgs
{
    [self cancelTouchesInSubElements];
    [self.touchesInElement addObject:eventArgs[0]];
    [self touchBeganInElement:eventArgs[0] withIndex:[self.touchesInElement indexOfObject:eventArgs[0]]
                    withEvent:nil];
}


-(BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint l = [touch locationInGLElement:self];
    CGRect absframe = self.absoluteFrame;
    if (l.x >= 0 && l.y >=0 && l.x <=absframe.size.width && l.y<=absframe.size.height)
    {
        [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
        [animator removeRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
        speed = 0;
        
        for (GLElement *element in gestureRecognizers)
        {
            ([element touchBegan:touch withEvent:event]);
        }
        
        for (GLElement *element in subElements.reverseObjectEnumerator)
        {
            if ([element touchBegan:touch withEvent:event])
                return YES;
        }
        
        if (!self.acceptsTouches)
            return NO;
        
        [touchesInElement addObject:touch];
        [self touchBeganInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        return YES;
    }
    
    return NO;
}
-(BOOL)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    for (GLElement *element in gestureRecognizers)
    {
        ([element touchMoved:touch withEvent:event]);
    }
    
    for (GLElement *element in subElements.reverseObjectEnumerator)
    {
        if ([element touchMoved:touch withEvent:event])
            return YES;
    }
    
    
    if (!self.acceptsTouches)
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
    
    for (GLElement *element in gestureRecognizers)
    {
        ([element touchEnded:touch withEvent:event]);
    }
    
    for (GLElement *element in subElements.reverseObjectEnumerator)
    {
        if ([element touchEnded:touch withEvent:event])
            return YES;
    }
    
    if (!self.acceptsTouches)
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
	touchStartPoint = [touch locationInGLElement:self];
    distY = 0;
    touchStartTime = CFAbsoluteTimeGetCurrent();
    [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
}
-(void)touchMovedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInGLElement:self];
    
    CGPoint newOrgin = CGPointMake(originInsideElement.x,originInsideElement.y+touchPoint.y - touchStartPoint.y);
    
    CGFloat diffHeight = heightOfContent - self.frame.size.height;
    if (diffHeight < 0)
        diffHeight = 0;
    
    if (newOrgin.y <= -maximumBounceBackDistance)
    {
        newOrgin = CGPointMake(0, -maximumBounceBackDistance);
    }
    else if  (newOrgin.y >= diffHeight + maximumBounceBackDistance)
    {
        newOrgin = CGPointMake(0, diffHeight + maximumBounceBackDistance);
    }
    self.originInsideElement = newOrgin;
    
    CGFloat cDist = distY;
    distY += (touchStartPoint.y - touchPoint.y);
    if (fabs(distY)< fabs(cDist))
    {
        distY = 0;
        touchStartTime = CFAbsoluteTimeGetCurrent();
    }
    touchStartPoint = touchPoint;
    
    
}

-(void)elementDidAppear
{
    [super elementDidAppear];
    if (director.keyBoardShown)
        heightOfContent += 216;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}


- (void)keyboardDidShow: (NSNotification *) notif{
    heightOfContent += 216;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    heightOfContent -= 216;
}

-(void)moveToVisibleRect:(GLElement *)element
{
    [self performSelector:@selector(moveToVisibleRectDelayed:) withObject:element afterDelay:0.1];
}

-(void)elementWillAppear
{
    [super elementWillAppear];
    self.originInsideElement = CGPointMake(0, 0);
}

-(void)moveToVisibleRectDelayed:(GLElement *)element
{
    if (!director.keyBoardShown)
        return;
    //    CGRect absFrame = [self absoluteFrame];
    
    CGRect relativeFrameElement = [self relativeFrameOfSubElement:element];
    if (CGRectIsEmpty(relativeFrameElement))
        return;
    
    CGFloat midY = 216 + (self.frame.size.height - 216)/2;
    
    CGFloat diffY = midY - relativeFrameElement.origin.y;
    
    CGPoint newOrgin = CGPointMake(originInsideElement.x,diffY);
    
    CGFloat diffHeight = heightOfContent - self.frame.size.height;
    if (diffHeight < 0)
        diffHeight = 0;
    
    if (newOrgin.y <= 0)
    {
        newOrgin = CGPointMake(0, 0);
    }
    else if  (newOrgin.y >= diffHeight)
    {
        newOrgin = CGPointMake(0, diffHeight);
    }
    EasingAnimation *animation = (EasingAnimation *)[self moveOriginInsideFrom:self.originInsideElement To:newOrgin withDuration:0.3 afterDelay:0 usingCurve:EasingOrdered];
    animation.easingType = EaseOut;

}

-(void)elementWillDisappear
{
    [super elementWillDisappear];
    if (director.keyBoardShown)
        heightOfContent -= 216;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    delay = CFAbsoluteTimeGetCurrent() - touchStartTime;
    speed =  distY/delay;
    speed = roundf(speed)/30;
    
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    
}

-(void)update
{
    if (fabs(speed) < 1)
        speed = 0;
    else
        speed/=1.05;
    
    
    
    CGPoint newOrgin = CGPointMake(originInsideElement.x,originInsideElement.y-roundf(speed));
    CGFloat diffHeight = heightOfContent- self.frame.size.height;
    if (diffHeight < 0)
        diffHeight = 0;
    
    if (newOrgin.y < 0 || newOrgin.y > diffHeight)
        speed /=2;
    
    
    if (newOrgin.y < -maximumBounceBackDistance)
    {
        speed = 0;
    }
    else if  (newOrgin.y >= diffHeight + maximumBounceBackDistance)
    {
        speed = 0;
    }
    if (self.touchesInElement.count == 0 && speed == 0)
    {
        if (newOrgin.y < 0)
        {
            speed = 0;
            if ([animator getCountOfRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK] == 0)
            {
                EasingAnimation *animation = (EasingAnimation *)[animator addAnimationOfType:EasingOrdered];
                animation.easingType = EaseOut;
                CGFloat startValue = newOrgin.y;
                CGFloat endval = 0;
                [animation setStartValue:&startValue OfSize:sizeof(CGFloat)];
                [animation setEndValue:&endval OfSize:sizeof(CGFloat)];
                animation.identifier = ANIMATION_BOUNCEBACK;
                animation.delegate = self;
                animation.duration = 0.3;
                animation.animationUpdateBlock = ^(Animation *anim)
                {
                    self.originInsideElement = CGPointMake(0, [anim getCurrentValueForCGFloat]);
                    return NO;
                };
                
            }
        }
        else if (newOrgin.y > diffHeight)
        {
            speed = 0;
            if ([animator getCountOfRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK] == 0)
            {
                EasingAnimation *animation = (EasingAnimation *)[animator addAnimationOfType:EasingOrdered];
                animation.easingType = EaseOut;
                CGFloat startValue = newOrgin.y;
                CGFloat endval = diffHeight;
                
                [animation setStartValue:&startValue OfSize:sizeof(CGFloat)];
                [animation setEndValue:&endval OfSize:sizeof(CGFloat)];
                animation.identifier = ANIMATION_BOUNCEBACK;
                animation.delegate = self;
                animation.duration = 0.3;
                animation.animationUpdateBlock = ^(Animation *anim)
                {
                    self.originInsideElement = CGPointMake(0, [anim getCurrentValueForCGFloat]);
                    return NO;
                };
                
            }
        }
    }
    self.originInsideElement = newOrgin;
    
}
@end
