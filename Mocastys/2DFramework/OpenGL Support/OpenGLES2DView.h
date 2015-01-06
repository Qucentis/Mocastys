//
//  OpenGLES2DView.h
//  KBC
//
//  Created by Rakesh on 07/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "Animator.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@class GLScene;

@interface OpenGLES2DView : UIView
{
    EAGLContext *context;
    GLuint viewRenderbuffer, viewFramebuffer,depthBuffer,sampleFramebuffer,sampleColorRenderbuffer,sampleDepthRenderbuffer;
    GLint backingWidth, backingHeight;
    Animator *animator;
    
    GLScene *currentScene;
	CFTimeInterval currentTime;
	BOOL isActive;

}
-(void)drawView;

@property (nonatomic,retain) GLScene *currentScene;

-(void)pauseTimer;
-(void)resumeTimer;
-(void)setScene:(GLScene *)scene;

- (id)initWithFrame:(CGRect)frame isOpaque:(BOOL)opaque;
-(void)clear;
@end
