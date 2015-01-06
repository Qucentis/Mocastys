//
//  OpenGLES2DView.h
//  GLFun
//
//  Created by Jeff LaMarche on 8/5/08.
//  Copyright 2008 msolidair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "GLCommon.h"
#import "GLRenderer.h"
#import "OpenGLES2DView.h"
#import "NavigationBar.h"

@interface RootOpenGLView : OpenGLES2DView {
    
    GLRenderer *colorRenderer;
    VertexColorData *backgroundColorData;
    NavigationBar *navigationBar;
    GLDirector *director;
}

@end
