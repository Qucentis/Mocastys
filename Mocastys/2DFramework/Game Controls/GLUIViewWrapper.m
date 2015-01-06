//
//  GLUIViewWrapper.m
//  KBC
//
//  Created by Rakesh on 12/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLUIViewWrapper.h"
#import "RootOpenGLView.h"

@implementation GLUIViewWrapper

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
            self.acceptsTouches = NO;
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        self.acceptsTouches = NO;
    }
    return self;
}


-(void)update
{
    
    CGRect absFrame1 = [self absoluteFrame];
    
    self.view.frame = CGRectMake(absFrame1.origin.x, self.openGLView.frame.size.height - absFrame1.origin.y - absFrame1.size.height, absFrame1.size.width, absFrame1.size.height);
    
}

-(void)elementWillDisappear
{
    [super elementWillDisappear];
}


-(void)elementDidDisappear
{
    [super elementDidDisappear];
    [self.view resignFirstResponder];
    [self.view removeFromSuperview];
}


-(void)elementWillAppear
{
    [super elementWillAppear];
    CGRect absFrame1 = [self absoluteFrame];
    self.view.frame = CGRectMake(absFrame1.origin.x, self.openGLView.frame.size.height - absFrame1.origin.y - absFrame1.size.height, absFrame1.size.width, absFrame1.size.height);
    [director.rootOpenGLView addSubview:self.view];
}

-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    NSLog(@"here");
}

@end
