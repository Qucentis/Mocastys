//
//  CanvasClass.m
//
//  Created by Rakesh on 17/08/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import "GLScene.h"
#import "RootOpenGLView.h"
#import "OverlayOpenGLView.h"

@implementation GLScene

@synthesize overlayScene;

-(id)init
{
	if (self = [super init])
	{
        self.frame = CGRectMake(0, 0, director.rootOpenGLView.frame.size.width, director.rootOpenGLView.frame.size.height);
        self.clipToBounds = YES;
       
        self.leftNavigationBarButtonColor = Color4BFromHex(0x000000ff);
        self.rightNavigationBarButtonColor = Color4BFromHex(0x000000ff);
	}
	return self;
}
-(void)leftBarButtonClicked
{
    
}
-(void)rightBarButtonClicked
{
    
}

-(void)actionBarButtonClicked
{
    
}

-(void)setOriginInsideElement:(CGPoint)_originInsideElement
{
    originInsideElement = _originInsideElement;
    if (overlayScene == nil)
        return;
    director.overlayOpenGLview.overlayScene.originInsideElement = [self absoluteFrame].origin;
}

-(void)setOriginOfElement:(CGPoint)_originOfElement
{
    originInsideElement = _originOfElement;
    if (overlayScene == nil)
        return;
    director.overlayOpenGLview.overlayScene.originInsideElement = [self absoluteFrame].origin;
}


-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (overlayScene == nil)
        return;
    if (!hidden)
    {
            director.overlayOpenGLview.overlayScene.originInsideElement = [self absoluteFrame].origin;
        overlayScene.hidden = NO;
        [director.overlayOpenGLview.overlayScene addElement:self.overlayScene];
    }
    else
    {
        overlayScene.hidden = YES;
        [director.overlayOpenGLview.overlayScene removeElement:self.overlayScene];
    }
}

-(void)elementDidAppear
{
    [super elementDidAppear];
    director.useOverlayOpenGLView = NO;
    [self sceneDidAppear];
}

-(void)elementWillAppear
{
    [super elementWillAppear];
    [self sceneWillAppear];
}

-(void)elementDidDisappear
{
    [super elementDidDisappear];
    [self sceneDidDisappear];
}

-(void)elementWillDisappear
{
    [super elementWillDisappear];
    [self sceneWillDisappear];
}

-(void)update
{
    if (overlayScene == nil)
        return;
    director.overlayOpenGLview.overlayScene.originInsideElement = [self absoluteFrame].origin;
}

-(void)sceneMadeActive
{
    
}
-(void)sceneMadeInActive
{
    
}

-(void)sceneDidAppear
{
    
}

-(void)sceneWillAppear
{
    
}

-(void)sceneDidDisappear
{
    
}

-(void)sceneWillDisappear
{
    
}

-(void)dealloc
{
    [super dealloc];
 
}

@end
