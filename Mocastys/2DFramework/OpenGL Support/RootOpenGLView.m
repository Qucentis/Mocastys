//
//  OpenGLES2DView.m
//  GLFun
//
//  Created by Jeff LaMarche on 8/5/08.
//  Copyright 2008 msolidair. All rights reserved.
//

#import "RootOpenGLView.h"
#import "GLScene.h"
#import "MVPMatrixManager.h"
#import "GLDirector.h"
#import "AppTheme.h"
#import "OverlayOpenGLView.h"

@interface RootOpenGLView (Private)

@end


@implementation RootOpenGLView

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame]))
    {
        colorRenderer = [[GLRendererManager sharedGLRendererManager]getRendererWithVertexShaderName:@"ColorShader" andFragmentShaderName:@"ColorShader"];
        backgroundColorData = malloc(sizeof(VertexColorData) * 12);
        
        (backgroundColorData)->vertex = (Vertex3D){.x = 0, .y = 0,.z = 0};
        (backgroundColorData + 1)->vertex = (Vertex3D){.x = 0, .y = self.frame.size.height,.z = 0};
        (backgroundColorData + 2)->vertex = (Vertex3D){.x = self.frame.size.width, .y = 0,.z = 0};
        (backgroundColorData + 3)->vertex = (Vertex3D){.x = self.frame.size.width, .y = 0,.z = 0};
        (backgroundColorData + 4)->vertex = (Vertex3D){.x = self.frame.size.width,
            .y = self.frame.size.height,.z = 0};
        (backgroundColorData + 5)->vertex = (Vertex3D){.x = 0, .y = self.frame.size.height,.z = 0};
        
        (backgroundColorData + 6)->vertex = (Vertex3D){.x = 0, .y = self.frame.size.height-20,.z = 0};
        (backgroundColorData + 7)->vertex = (Vertex3D){.x = 0, .y = self.frame.size.height,.z = 0};
        (backgroundColorData + 8)->vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height-20,.z = 0};
        (backgroundColorData + 9)->vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height-20,.z = 0};
        (backgroundColorData + 10)->vertex = (Vertex3D){.x = self.frame.size.width,
            .y = self.frame.size.height,.z = 0};
        (backgroundColorData + 11)->vertex = (Vertex3D){.x = 0, .y = self.frame.size.height,.z = 0};
        (backgroundColorData)->color = backgroundColorBottom;
        (backgroundColorData + 1)->color = backgroundColorTop;
        (backgroundColorData + 2)->color = backgroundColorBottom;
        (backgroundColorData + 3)->color = backgroundColorBottom;
        (backgroundColorData + 4)->color = backgroundColorTop;
        (backgroundColorData + 5)->color = backgroundColorTop;
        
        (backgroundColorData + 6)->color = Color4BFromHex(0x000000ff);
        (backgroundColorData + 7)->color = Color4BFromHex(0x000000ff);
        (backgroundColorData + 8)->color = Color4BFromHex(0x000000ff);
        (backgroundColorData + 9)->color = Color4BFromHex(0x000000ff);
        (backgroundColorData + 10)->color = Color4BFromHex(0x000000ff);
        (backgroundColorData + 11)->color = Color4BFromHex(0x000000ff);
        
        director = [GLDirector sharedDirector];
        
	}
	return self;
}



-(void)drawView
{
    [self bindBuffers];
    glViewport(0, 0, backingWidth, backingHeight);
    [[MVPMatrixManager sharedMVPMatrixManager] setOrthoProjection:-self.frame.size.width
                                                                 :0 :-self.frame.size.height
                                                                 :0 :-1 :10000];

    CGRect bounds = [UIScreen mainScreen].bounds;
    glScissor(0 ,0, bounds.size.width * [[UIScreen mainScreen]scale], bounds.size.height* [[UIScreen mainScreen]scale]);
    [GLDirector sharedDirector].clippingRect = bounds;
    
    [[MVPMatrixManager sharedMVPMatrixManager]resetModelViewMatrixStack];
    [currentScene resetZCoordinate];
    [colorRenderer drawWithArray:backgroundColorData andCount:6];
    [currentScene drawElement];
    if (!director.useOverlayOpenGLView)
        [director.overlayOpenGLview.mainScene drawElement];
    [animator update];
    
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}



-(void)setScene:(GLScene *)scene
{
	if (currentScene != nil)
		[currentScene sceneMadeInActive];
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

-(void)bindBuffers
{
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
}

- (void)dealloc {
    free(backgroundColorData);
    
	[super dealloc];
}


@end
