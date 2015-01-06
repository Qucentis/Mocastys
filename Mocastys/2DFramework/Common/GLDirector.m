//
//  Director.m
//  GameDemo
//
//  Created by Rakesh on 11/11/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import "GLDirector.h"
#import "GLScene.h"
#import "OverlayOpenGLView.h"
#import "RootOpenGLView.h"

@interface GLDirector (Private)

@end


@implementation GLDirector

@synthesize window,rootOpenGLView,overlayOpenGLview,openGLViewController,currentScene;

+(GLDirector *)sharedDirector
{
	static GLDirector *dir;
	@synchronized(self)
	{
		if (dir == nil)
		{
			dir = [[GLDirector alloc]init];
        }
	}
	return dir;
}

-(id)init
{
    if (self = [super init])
    {
        defaultShadersLoaded = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        self.useOverlayOpenGLView = NO;

    }
    return self;
}

- (void)keyboardDidShow: (NSNotification *) notif{
    self.keyBoardShown = YES;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    self.keyBoardShown = NO;
}

-(void)setUseOverlayOpenGLView:(BOOL)useOverlayOpenGLView
{
    _useOverlayOpenGLView = useOverlayOpenGLView;
    overlayOpenGLview.enabled = _useOverlayOpenGLView;
    overLayClearFlag = !useOverlayOpenGLView;
}

-(void)presentScene:(NSObject *)scene
{
	if ([scene isKindOfClass:[GLScene class]])
	{
		if (openGLViewController == nil)
			[self setInterfaceOrientation:UIInterfaceOrientationPortrait];
		else
        {
            [(GLScene *)scene setOpenGLView:rootOpenGLView];
			[rootOpenGLView setScene:(GLScene *)scene];
            currentScene = scene;
		}
	}
}

-(void)clearScene:(Color4B)_clear_color
{
	glClearColor(_clear_color.red/255.0f, _clear_color.blue/255.0f, _clear_color.green/255.0f, _clear_color.alpha/255.0f);
//	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
}

-(void)setWindow:(UIWindow *)_window
{
    if (window != nil)
    {
        [window release];
    }
    window = [_window retain];
    if (openGLViewController != nil)
    {
    if ([window respondsToSelector:@selector(setRootViewController:)])
        [window setRootViewController:openGLViewController];
    else
        [window addSubview:openGLViewController.view];
	if (currentScene != nil)
		[self presentScene:currentScene];
    }
}

-(void)setInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	if (openGLViewController != nil)
	{
		[rootOpenGLView removeFromSuperview];
		[openGLViewController release];
	}
	openGLViewController = [[OpenGLViewController alloc]initWithInterfaceOrientation:orientation];
	rootOpenGLView = (RootOpenGLView *)openGLViewController.rootOpenGLView;
    overlayOpenGLview = (OverlayOpenGLView *)openGLViewController.overlayOpenGLView;

    if ([window respondsToSelector:@selector(setRootViewController:)])
        [window setRootViewController:openGLViewController];
    else
        [window addSubview:openGLViewController.view];
	if (currentScene != nil)
		[self presentScene:currentScene];
	
    if (!defaultShadersLoaded)
    {
        defaultShadersLoaded = YES;
        [self loadShaders];
    }
}

-(void)draw
{
    [rootOpenGLView drawView];
    if (overLayClearFlag)
    {
        [rootOpenGLView drawView];
        [overlayOpenGLview clear];
        overLayClearFlag = NO;
    }
    if (_useOverlayOpenGLView)
        [overlayOpenGLview drawView];
}


-(void)pauseTimer
{
	isLoopRunning = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(draw) object:nil];
    [self.displayLink invalidate];
    self.displayLink = nil;
    [rootOpenGLView pauseTimer];
    [overlayOpenGLview pauseTimer];
}

-(void)resumeTimer
{
	if (!isLoopRunning)
	{
		isLoopRunning = YES;
		self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(draw)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink.frameInterval = 1;
        [rootOpenGLView resumeTimer];
        [overlayOpenGLview resumeTimer];
	}
}



-(void)loadShaders
{
//    ColorRenderer *shader1 = [[ColorRenderer alloc]init];
  //  [shader1 release];
  /*  TextureRenderer *shader2 = [[TextureRenderer alloc]init];
    [shader2 release];
    */
}


-(void)dealloc
{

	[openGLViewController release];
	[window release];
    	[super dealloc];
}


@end
