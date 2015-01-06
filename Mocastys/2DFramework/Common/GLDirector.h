//
//  Director.h
//  GameDemo
//
//  Created by Rakesh on 11/11/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OpenGLViewController.h"

@class RootOpenGLView;
@class OverlayOpenGLView;

#define deviceiPhoneNonRetina 1;
#define deviceiPhoneRetina 2;
#define deviceiPhone5 3;
#define deviceiPadNonRetina 4;
#define deviceiPadRetina 5;

@interface GLDirector : NSObject {
	NSObject *currentScene;
	UIWindow *window;
	OpenGLViewController *openGLViewController;
	
    RootOpenGLView *rootOpenGLView;
    OverlayOpenGLView *overlayOpenGLview;
    
	NSTimer *animationTimer;
    
    BOOL defaultShadersLoaded;
    
    BOOL isLoopRunning;
    BOOL overLayClearFlag;
}

@property (nonatomic) BOOL useOverlayOpenGLView;
@property (nonatomic,retain) EAGLContext *eaglContext;
@property (nonatomic,retain) CADisplayLink *displayLink;
@property (nonatomic) BOOL keyBoardShown;
@property (nonatomic,retain) UIWindow *window;
@property (nonatomic,readonly) NSObject *currentScene;
@property (nonatomic,readonly) RootOpenGLView *rootOpenGLView;
@property (nonatomic,readonly) OverlayOpenGLView *overlayOpenGLview;
@property (nonatomic,readonly) OpenGLViewController *openGLViewController;
@property (nonatomic) CGRect clippingRect;
+(GLDirector *)sharedDirector;
-(void)presentScene:(NSObject *)scene;
-(void)setInterfaceOrientation:(UIInterfaceOrientation)orientation;
-(void)clearScene:(Color4B)_clear_color;

-(void)pauseTimer;
-(void)resumeTimer;

@end
