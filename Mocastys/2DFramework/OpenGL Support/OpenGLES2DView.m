//
//  OpenGLES2DView.m
//  KBC
//
//  Created by Rakesh on 07/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "OpenGLES2DView.h"
#import "GLScene.h"


@implementation OpenGLES2DView

@synthesize currentScene;

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

#pragma mark -
- (BOOL)createFramebuffer {
	
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
    
	return YES;
}

- (id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame])) {
        
        animator = [Animator sharedAnimator];
        
        if ([self respondsToSelector:@selector(contentScaleFactor)])
        {
            self.contentScaleFactor = [[UIScreen mainScreen] scale];
        }
        
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		eaglLayer.opaque = YES;
#if TARGET_IPHONE_SIMULATOR
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
#else
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
        
#endif
        GLDirector *director = [GLDirector sharedDirector];
        if (director.eaglContext == nil)
        {
            context= [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
            director.eaglContext = context;
        }
        else
            context = director.eaglContext;
        
		
		if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer]) {
			[self release];
			return nil;
		}
		
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
        glViewport(0, 0, backingWidth, backingHeight);
		glDisable(GL_ALPHA_TEST);
        
        NSLog(@"%d %d %f %f",backingWidth,backingHeight,self.frame.size.width,self.frame.size.height);
        
        [[MVPMatrixManager sharedMVPMatrixManager] setOrthoProjection:-self.frame.size.width
                                                                     :0 :-self.frame.size.height
                                                                     :0 :-1 :1000];
		glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        glEnable(GL_SCISSOR_TEST);
        
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
		[context presentRenderbuffer:GL_RENDERBUFFER_OES];
        
	}
	self.multipleTouchEnabled = NO;
	return self;
}


- (id)initWithFrame:(CGRect)frame isOpaque:(BOOL)opaque
{
	if((self = [super initWithFrame:frame])) {
        
        animator = [Animator sharedAnimator];
        
        if ([self respondsToSelector:@selector(contentScaleFactor)])
        {
            self.contentScaleFactor = [[UIScreen mainScreen] scale];
        }
        
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		eaglLayer.opaque = opaque;
#if TARGET_IPHONE_SIMULATOR
		if (opaque)
        {
            eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
        }
        else
            eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                            kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
#else
        if (opaque)
        {
            eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil];
        }
        else
            eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
             kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
#endif
        GLDirector *director = [GLDirector sharedDirector];
        if (director.eaglContext == nil)
        {
            context= [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
            director.eaglContext = context;
        }
        else
            context = director.eaglContext;
        
		
		if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer]) {
			[self release];
			return nil;
		}
		
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
        glViewport(0, 0, backingWidth, backingHeight);
		glDisable(GL_ALPHA_TEST);
        
        NSLog(@"%d %d %f %f",backingWidth,backingHeight,self.frame.size.width,self.frame.size.height);
        
        [[MVPMatrixManager sharedMVPMatrixManager] setOrthoProjection:-self.frame.size.width
                                                                     :0 :-self.frame.size.height
                                                                     :0 :-1 :1000];
		glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        glEnable(GL_SCISSOR_TEST);
        
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
		[context presentRenderbuffer:GL_RENDERBUFFER_OES];
        
	}
	self.multipleTouchEnabled = NO;
	return self;
}


-(void)drawView
{
    [self bindBuffers];
    glViewport(0, 0, backingWidth, backingHeight);
    [[MVPMatrixManager sharedMVPMatrixManager] setOrthoProjection:-self.frame.size.width
                                                                 :0 :-self.frame.size.height
                                                                 :0 :-1 :1000];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    glScissor(bounds.origin.x * [[UIScreen mainScreen]scale] , bounds.origin.y * [[UIScreen mainScreen]scale], bounds.size.width * [[UIScreen mainScreen]scale], bounds.size.height* [[UIScreen mainScreen]scale]);
    [GLDirector sharedDirector].clippingRect = bounds;
    
    [[MVPMatrixManager sharedMVPMatrixManager]resetModelViewMatrixStack];
    [currentScene resetZCoordinate];
    [currentScene drawElement];
    [animator update];
    glFlush();
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


-(void)bindBuffers
{
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
}


-(void)clear
{
    [self bindBuffers];
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


-(void)setScene:(GLScene *)scene
{
	if (currentScene != nil)
		[currentScene sceneMadeInActive];
    self.currentScene.openGLView = self;
	self.currentScene = scene;
    [self.currentScene sceneMadeActive];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
        [currentScene touchBegan:t withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
        
        [currentScene touchMoved:t withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
        [currentScene touchEnded:t withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
        [currentScene touchEnded:t withEvent:event];
}


-(void)pauseTimer
{
    [currentScene sceneMadeInActive];
}

-(void)resumeTimer
{
    [currentScene sceneMadeActive];
}



- (void)dealloc {
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteFramebuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
    
	[super dealloc];
}

@end
