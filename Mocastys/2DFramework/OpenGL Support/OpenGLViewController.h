//
//  OpenGLViewController.h
//  GameDemo
//
//  Created by Rakesh on 12/11/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLES2DView.h"

@interface OpenGLViewController : UIViewController {
	UIInterfaceOrientation interfaceOrientation;
    OpenGLES2DView *rootOpenGLView;
    OpenGLES2DView *overlayOpenGLView;
}

@property (nonatomic,readonly) OpenGLES2DView *rootOpenGLView;
@property (nonatomic,readonly) OpenGLES2DView *overlayOpenGLView;
@property (nonatomic,readonly) UIInterfaceOrientation interfaceOrientation;

-(id)initWithInterfaceOrientation:(UIInterfaceOrientation)_interfaceOrientation;
@end
