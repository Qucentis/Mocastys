//
//  UITouch+UITouch_GLElement.m
//  Dabble
//
//  Created by Rakesh on 31/05/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "UITouch+GLElement.h"
#import "GLElement.h"

@implementation UITouch (UITouch_GLElement)

-(CGPoint)locationInGLElement:(GLElement *)element
{
    CGPoint locationInView = [self locationInView:element.openGLView];
    CGPoint locationInOpenGLView = CGPointMake(locationInView.x,
                                               element.openGLView.frame.size.height - locationInView.y);
        CGRect frame = element.absoluteFrame;

    CGPoint loc = CGPointMake(locationInOpenGLView.x - frame.origin.x,
                       locationInOpenGLView.y - frame.origin.y);
    return loc;
}
@end
