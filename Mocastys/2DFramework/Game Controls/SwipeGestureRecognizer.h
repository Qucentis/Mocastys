//
//  SwipeGestureRecognizer.h
//  KBC
//
//  Created by Rakesh on 02/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"

#define GESTURE_VERTICALSWIPE 2
#define GESTURE_HORIZONTALSWIPE 4


@interface SwipeGestureRecognizer : GLElement
{
    CGFloat distX;
    CGFloat distY;
    
    int gestureSieve;
    BOOL detected;
    CGPoint startPoint;
    
    NSObject *target;
    SEL selector;
}

-(void)setGestures:(int)gestures;
-(void)addTarget:(NSObject *)_target andSelector:(SEL)_selector;
@end
