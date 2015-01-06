//
//  GLScrollView.h
//  KBC
//
//  Created by Rakesh on 02/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "SwipeGestureRecognizer.h"

@interface GLVerticalScrollElement : GLElement
{
    double speed;
    double touchStartTime;
    double delay;
    double distY;
    CGPoint touchStartPoint;
    int heightOfContent;
    SwipeGestureRecognizer *verticalSwipeRecognizer;
}

@property (nonatomic) int heightOfContent;
-(void)moveToVisibleRect:(GLElement *)element;

@end
