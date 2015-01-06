//
//  NavigationBar.m
//  KBC
//
//  Created by Rakesh on 04/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "OverlayOpenGLView.h"
#import "GLDirector.h"
#import "GLScene.h"

@implementation OverlayOpenGLView

@synthesize overlayScene,mainScene;

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame isOpaque:NO])) {
        self.backgroundColor = [UIColor clearColor];
        self.multipleTouchEnabled = NO;
        self.userInteractionEnabled = YES;
        
        mainScene = [[GLScene alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
        mainScene.openGLView = self;
        mainScene.acceptsTouches = NO;
        
        overlayScene = [[GLScene alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)];
        overlayScene.acceptsTouches = NO;
        [mainScene addElement:overlayScene];
	}
	

	return self;
}
-(void)drawView
{
    [self bindBuffers];
    
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, backingWidth, backingHeight);
    [[MVPMatrixManager sharedMVPMatrixManager] setOrthoProjection:-self.frame.size.width
                                                                 :0 :-self.frame.size.height
                                                                 :0 :-1 :10000];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    glScissor(0 ,0, bounds.size.width * [[UIScreen mainScreen]scale], bounds.size.height* [[UIScreen mainScreen]scale]);
    [GLDirector sharedDirector].clippingRect = bounds;
    
    [[MVPMatrixManager sharedMVPMatrixManager]resetModelViewMatrixStack];
    [mainScene resetZCoordinate];
    [mainScene drawElement];
    
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
        [mainScene touchBegan:t withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
        [mainScene touchMoved:t withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
        [mainScene touchEnded:t withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mainScene cancelTouchesInElement];
    [mainScene cancelTouchesInSubElements];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [mainScene isPointInside:point];
}

-(void)bindBuffers
{
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
}


@end
