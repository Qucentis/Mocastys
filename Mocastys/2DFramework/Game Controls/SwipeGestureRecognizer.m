//
//  SwipeGestureRecognizer.m
//  KBC
//
//  Created by Rakesh on 02/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "SwipeGestureRecognizer.h"

@implementation SwipeGestureRecognizer

-(void)setGestures:(int)gestures
{
    gestureSieve = gestures;
}

-(void)addTarget:(NSObject *)_target andSelector:(SEL)_selector
{
    target = _target;
    selector = _selector;
}

-(BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.parent.acceptsTouches)
        return NO;
    startPoint = [touch locationInGLElement:self.parent];
    [touchesInElement addObject:touch];
    detected = NO;
    return NO;
}
-(BOOL)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![touchesInElement containsObject:touch])
        return NO;
    
    CGPoint l = [touch locationInGLElement:self.parent];
    
    distX = fabs(startPoint.x - l.x);
    distY = fabs(startPoint.y - l.y);
    
    if ((distX > 10 || distY > 10) && !detected)
    {
        if (distX > distY && (gestureSieve&GESTURE_HORIZONTALSWIPE))
        {
            detected = YES;
            [target performSelector:selector withObject:[NSArray arrayWithObjects:touch,
                                                         [NSNumber numberWithFloat:distX],[NSNumber numberWithInt:GESTURE_HORIZONTALSWIPE],nil]];
        }
        else if (distX <= distY && (gestureSieve&GESTURE_VERTICALSWIPE))
        {
            detected = YES;
            [target performSelector:selector withObject:[NSArray arrayWithObjects:touch,
                                                         [NSNumber numberWithFloat:distY],[NSNumber numberWithInt:GESTURE_VERTICALSWIPE],nil]];
        }
    }
    
    return NO;
}

-(BOOL)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [touchesInElement removeObject:touch];
    detected = NO;
    return NO;
}

-(void)dealloc
{
    [super dealloc];
}


@end
