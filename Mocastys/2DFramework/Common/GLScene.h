//
//  CanvasClass.h
//  MusiMusi
//
//  Created by Rakesh on 17/08/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGLDrawable.h>
#import "GLElement.h"
#import "NavigationButton.h"


@interface GLScene : GLElement {
    GLElement *overlayScene;
}

@property (nonatomic,readonly) GLElement *overlayScene;
@property (nonatomic) Color4B leftNavigationBarButtonColor;
@property (nonatomic) Color4B rightNavigationBarButtonColor;
@property (nonatomic) Color4B actionBarButtonColor;

@property (nonatomic,retain) NavigationButton *leftNavigationBarButton;
@property (nonatomic,retain) NavigationButton *rightNavigationBarButton;
@property (nonatomic,retain) NavigationButton *actionBarButton;

-(void)sceneMadeActive;
-(void)sceneMadeInActive;
-(void)sceneDidAppear;
-(void)sceneWillAppear;
-(void)sceneDidDisappear;
-(void)sceneWillDisappear;
-(void)leftBarButtonClicked;
-(void)rightBarButtonClicked;
-(void)actionBarButtonClicked;
@end
