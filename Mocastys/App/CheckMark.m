//
//  CheckMark.m
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "CheckMark.h"

#define ANIMATION_SCALE 1

@implementation CheckMark

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        self.clipToBounds = YES;
        self.enabled = NO;
        
        uncheckedImageView = [[GLImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addElement:uncheckedImageView];
        [uncheckedImageView setImage:@"fsl_cell_unChecked" ofType:@"png"];
        [uncheckedImageView setBackgroundColor:(Color4B){255,255,255,0}];
        [uncheckedImageView setBackgroundHightlightColor:(Color4B){255,255,255,0}];
        [uncheckedImageView setImageColor:(Color4B){255,255,255,255}];
        [uncheckedImageView setImageHighlightColor:(Color4B){255,255,255,255}];
        [uncheckedImageView release];
    
        checkedImageView =[[GLImageView alloc]initWithFrame:CGRectMake(-40, 0, 40, 40)];
        [checkedImageView setImage:@"fsl_cell_checked" ofType:@"png"];
        [self addElement:checkedImageView];
        [checkedImageView release];
        [checkedImageView setBackgroundColor:(Color4B){255,255,255,0}];
        [checkedImageView setBackgroundHightlightColor:(Color4B){255,255,255,0}];
        [checkedImageView setImageColor:(Color4B){255,255,255,255}];
        [checkedImageView setImageHighlightColor:(Color4B){255,255,255,255}];

        self.hidden = NO;
    }
    return self;
}

-(void)setState:(BOOL)ON animated:(BOOL)animated
{
    if (isON == ON)
        return;
    isON = ON;
    
    if (animated)
    {
        if (isON)
            [self moveOriginInsideFrom:self.originInsideElement To:CGPointMake(40, 0) withDuration:0.9 afterDelay:0 usingCurve:EasingElastic];
        else
        {
            EasingAnimation *animation = (EasingAnimation *)[self moveOriginInsideFrom:self.originInsideElement To:CGPointMake(0, 0) withDuration:0.3
                            afterDelay:   0 usingCurve:EasingOrdered];
            animation.easingType = EaseOut;
        }
    }
    else
    {
        if (isON)
            self.originInsideElement = CGPointMake(40, 0);
        else
            self.originInsideElement = CGPointMake(0, 0);
    }
   
}

@end
