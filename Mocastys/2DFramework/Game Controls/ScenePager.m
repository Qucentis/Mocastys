//
//  ScenePager.m
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "ScenePager.h"
#import "OverlayOpenGLView.h"
#import "DisclaimerScene.h"

#define ANIMATION_MOVEPAGE 1

@implementation ScenePager

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        elements = [[NSMutableArray alloc]init];
        currentPage = -1;
        navigationBar = [NavigationBar sharedNavigationBar];
        origins = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addElement:(GLElement *)element atOrigin:(CGPoint)origin
{
    element.frame = CGRectOffset(self.frame, origin.x, origin.y);
    [origins addObject:NSStringFromCGPoint(origin)];

    [elements addObject:element];
    [element release];
    element.hidden = YES;
    element.enabled = NO;
}

-(void)setPage:(int)page animated:(BOOL)animated
{
    if (currentPage == page)
        return;
  
    GLElement *element = elements[page];
    CGPoint origin = CGPointFromString((NSString *)origins[page]);
    element.frame = CGRectOffset(self.frame, origin.x, origin.y);
    [self addElement:element];
    
    if (!element.hidden)
        return;
    if (!animated)
    {
        if (currentPage >= 0)
        {
            previousPage = currentPage;
            GLElement *prevElement = elements[previousPage];
            prevElement.hidden = YES;
            prevElement.enabled = NO;
            
            [prevElement elementWillDisappear];
            [prevElement elementDidDisappear];
        }
        
        currentPage = page;
        GLElement *currentElement = elements[currentPage];
        
        self.originInsideElement = CGPointMake(-currentElement.frame.origin.x,
                                               -currentElement.frame.origin.y);
        
        if ([currentElement isKindOfClass:[GLScene class]])
        {
            GLScene *scene = (GLScene *)currentElement;
            [navigationBar setCurrentScene:scene];
        }
        [currentElement elementWillAppear];
        [currentElement elementDidAppear];
        
        currentElement.hidden = NO;
        currentElement.enabled = YES;
    }
    else
    {
        previousPage = currentPage;
        GLElement *prevElement = elements[previousPage];
        prevElement.enabled = NO;
        
        [prevElement elementWillDisappear];
        
        currentPage = page;
        GLElement *currentElement = elements[currentPage];
        currentElement.hidden = NO;
        currentElement.enabled = NO;
        
    /*
        CGFloat xRatio = (prevElement.frame.origin.x - currentElement.frame.origin.x)/self.frame.size.width;
        CGFloat yRatio = (prevElement.frame.origin.y - currentElement.frame.origin.y)/self.frame.size.height;
        int signX = 0;
        int signY = 0;
        if (xRatio)
            signX = xRatio/fabs(xRatio);
        if (yRatio)
            signY = yRatio/fabs(yRatio);
        
        prevElement.frame = CGRectMake(signX * prevElement.frame.size.width,signY * prevElement.frame.size.height,prevElement.frame.size.width,prevElement.frame.size.height);
        
        self.originInsideElement = CGPointMake(-prevElement.frame.origin.x,
                                               -prevElement.frame.origin.y);
     */
        
    if ([currentElement isKindOfClass:[GLScene class]])
    {
        GLScene *scene = (GLScene *)currentElement;
        [navigationBar setCurrentScene:scene];
    }
          [currentElement elementWillAppear];
        
        EasingAnimation *animation = (EasingAnimation *)[self moveOriginInsideFrom:CGPointMake(-prevElement.frame.origin.x,-prevElement.frame.origin.y) To:CGPointMake(-currentElement.frame.origin.x,-currentElement.frame.origin.y) withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
        animation.order = 4;
        animation.easingType = EaseInOut;
        animation.animationEndedBlock = ^(Animation *animation)
        {
            GLElement *prevElement = elements[previousPage];
            prevElement.hidden = YES;
            prevElement.enabled = NO;

            [prevElement elementDidDisappear];
            
            GLElement *currentElement = elements[currentPage];
            self.originInsideElement = CGPointMake(-currentElement.frame.origin.x,-currentElement.frame.origin.y);
            currentElement.hidden = NO;
            currentElement.enabled = YES;
            
            [currentElement elementDidAppear];
            
        };
        
        
    }
}


-(void)elementDidAppear
{
   [self sceneDidAppear];
}

-(void)elementWillAppear
{
    [self sceneWillAppear];
}

-(void)elementDidDisappear
{
    [self sceneDidDisappear];
}

-(void)elementWillDisappear
{
    [self sceneWillDisappear];
}


-(void)sceneDidAppear
{
    GLElement *currentElement = elements[currentPage];
    [currentElement elementDidAppear];
    
}

-(void)sceneWillAppear
{
    GLElement *currentElement = elements[currentPage];
    if ([currentElement isKindOfClass:[GLScene class]])
    {
        GLScene *scene = (GLScene *)currentElement;
        [navigationBar setCurrentScene:scene];
    }
    [currentElement elementWillAppear];
}

-(void)sceneDidDisappear
{
    GLElement *currentElement = elements[currentPage];
    [currentElement elementDidDisappear];
}

-(void)sceneWillDisappear
{
    GLElement *currentElement = elements[currentPage];
    [currentElement elementWillDisappear];
    

}

-(void)update
{
    [super update];
}

-(void)draw
{
    glClearColor(1.0,1.0,1.0,1.0);
}

@end
