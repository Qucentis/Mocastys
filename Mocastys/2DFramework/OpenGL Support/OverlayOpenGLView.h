//
//  NavigationBar.h
//  KBC
//
//  Created by Rakesh on 04/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootOpenGLView.h"
#import "GLImageView.h"
#import "GLImageButton.h"
#import "Animator.h"
#import "OpenGLES2DView.h"

@interface OverlayOpenGLView : OpenGLES2DView
{
    GLScene *overlayScene;
    GLScene *mainScene;
}

@property (nonatomic,readonly) GLScene *overlayScene;
@property (nonatomic,readonly) GLScene *mainScene;
@property (nonatomic) BOOL enabled;
-(void)drawView;

@end
