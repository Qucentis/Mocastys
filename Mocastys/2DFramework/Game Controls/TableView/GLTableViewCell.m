//
//  GLTableViewCell.m
//  KBC
//
//  Created by Rakesh on 05/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLTableViewCell.h"
#import "GLTableView.h"

#define ANIMATION_COLOR_CHANGE 1

@implementation GLTableViewCell

-(id)init
{
    if (self = [super init])
    {
        self.hasBorder = NO;
        
        overlayFrameData = malloc(sizeof(VertexColorData) * 6);
        
        highLightColor = (Color4B){0,0,0,64};
    }
    return self;
    
}

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super init])
    {
        self.hasBorder = NO;
        
        overlayFrameData[0].vertex = (Vertex3D){.x = 0, .y = 0, .z = 0};
        overlayFrameData[1].vertex = (Vertex3D){.x = self.frame.size.width, .y = 0, .z = 0};
        overlayFrameData[2].vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height, .z = 0};
        overlayFrameData[3].vertex = (Vertex3D){.x = 0, .y = 0, .z = 0};
        overlayFrameData[4].vertex = (Vertex3D){.x = 0, .y = self.frame.size.height, .z = 0};
        overlayFrameData[5].vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height, .z = 0};
        
    }
    return self;
}

-(void)setFrame:(CGRect)_frame
{
    [super setFrame:_frame];
    frame = _frame;
    overlayFrameData[0].vertex = (Vertex3D){.x = 0, .y = 0, .z = 0};
    overlayFrameData[1].vertex = (Vertex3D){.x = self.frame.size.width, .y = 0, .z = 0};
    overlayFrameData[2].vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height, .z = 0};
    overlayFrameData[3].vertex = (Vertex3D){.x = 0, .y = 0, .z = 0};
    overlayFrameData[4].vertex = (Vertex3D){.x = 0, .y = self.frame.size.height, .z = 0};
    overlayFrameData[5].vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height, .z = 0};
    
    for (int i = 0;i< 6;i++)
    {
        overlayFrameData[i].color = (Color4B){0,0,0,0};
    }
}

-(void)setHighlightColor:(Color4B)color
{
    highLightColor = color;
}


-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    if (fading)
        return;
    highlighted = NO;
    [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_COLOR_CHANGE];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_COLOR_CHANGE];
    
    EasingAnimation *animation = (EasingAnimation *)[animator addAnimationOfType:EasingOrdered];
    animation.identifier = ANIMATION_COLOR_CHANGE;
    Color4B startColor = highLightColor;
    startColor.alpha = 0;
    Color4B endColor = highLightColor;
    animation.duration = 0.1;
    animation.delay = 0.1;
    animation.delegate = self;
    
    animation.dataType = AnimationDataTypeColor4B;
    
    [animation setStartValue:&(startColor)];
    [animation setEndValue:&(endColor)];
    
    animation.animationUpdateBlock = ^(Animation *animation)
    {
        CGFloat alpha = [animation getCurrentValueForColor4B].alpha;
        for (int i = 0;i<6;i++)
        {
            overlayFrameData[i].color.alpha = alpha;
        }
        return NO;
    };
    
    animation.animationStartedBlock = ^(Animation *animation)
    {
        if (!fading)
        {
            highlighted = !highlighted;
        }
        
        Color4B *startColor = [animation getStartValue];
        for (int i = 0;i<6;i++)
        {
            overlayFrameData[i].color = *startColor;
        }
    };
    animation.animationEndedBlock = ^(Animation *animation)
    {
        fading = NO;
        Color4B *endColor = [animation getEndValue];
        for (int i = 0;i<6;i++)
        {
            overlayFrameData[i].color = *endColor;
        }
    };
    
}
-(void)touchMovedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
	
}
-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_COLOR_CHANGE];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_COLOR_CHANGE];
    
    if (highlighted)
    {
        EasingAnimation *animation = (EasingAnimation *)[animator addAnimationOfType:EasingOrdered];
        animation.identifier = ANIMATION_COLOR_CHANGE;
        Color4B startColor = highLightColor;
        Color4B endColor = highLightColor;
        endColor.alpha = 0;
    animation.delegate = self;
        animation.duration = 0.1;
        animation.delay = 0;
        animation.dataType = AnimationDataTypeColor4B;
        [animation setStartValue:&(startColor)];
        [animation setEndValue:&(endColor)];
        
        animation.animationUpdateBlock = ^(Animation *animation)
        {
            CGFloat alpha = [animation getCurrentValueForColor4B].alpha;
            
            for (int i = 0;i<6;i++)
            {
                overlayFrameData[i].color.alpha = alpha;
            }
            return NO;
        };
        
        animation.animationStartedBlock = ^(Animation *animation)
        {
            if (!fading)
            {
                highlighted = !highlighted;
            }
            
            Color4B *startColor = [animation getStartValue];
            for (int i = 0;i<6;i++)
            {
                overlayFrameData[i].color = *startColor;
            }
        };
        animation.animationEndedBlock = ^(Animation *animation)
        {
            fading = NO;
            Color4B *endColor = [animation getEndValue];
            for (int i = 0;i<6;i++)
            {
                overlayFrameData[i].color = *endColor;
            }
        };
        
    }
    
    
    GLTableView *tableView = (GLTableView *)self.parent;
    [tableView.delegate cellSelected:self];
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_COLOR_CHANGE];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_COLOR_CHANGE];
    if (highlighted)
    {
        EasingAnimation *animation = (EasingAnimation *)[animator addAnimationOfType:EasingOrdered];
        animation.identifier = ANIMATION_COLOR_CHANGE;
        Color4B startColor = highLightColor;
        Color4B endColor = highLightColor;
        endColor.alpha = 0;
            animation.delegate = self;
        animation.duration = 0.1;
        animation.delay = 0;
        animation.dataType = AnimationDataTypeColor4B;
        [animation setStartValue:&(startColor)];
        [animation setEndValue:&(endColor)];
        
        animation.animationUpdateBlock = ^(Animation *animation)
        {
            CGFloat alpha = [animation getCurrentValueForColor4B].alpha;
            
            for (int i = 0;i<6;i++)
            {
                overlayFrameData[i].color.alpha = alpha;
            }
            return NO;
        };
        
        animation.animationStartedBlock = ^(Animation *animation)
        {
            if (!fading)
            {
                highlighted = !highlighted;
            }
            
            Color4B *startColor = [animation getStartValue];
            for (int i = 0;i<6;i++)
            {
                overlayFrameData[i].color = *startColor;
            }
        };
        animation.animationEndedBlock = ^(Animation *animation)
        {
            fading = NO;
            Color4B *endColor = [animation getEndValue];
            for (int i = 0;i<6;i++)
            {
                overlayFrameData[i].color = *endColor;
            }
        };
        
    }
}

-(void)animate
{
    
}

-(void)drawSubElements
{
    if (!highlighted && !fading)
        return;
    [mvpMatrixManager translateInX:0 Y:0 Z:1];
    [elementColorRenderer drawWithArray:overlayFrameData andCount:6];
    [mvpMatrixManager translateInX:0 Y:0 Z:-1];
}

-(void)dealloc
{
//    NSLog(@"Deallocating TableViewCell");
    free(overlayFrameData);
    [super dealloc];
}

@end
