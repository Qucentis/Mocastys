//
//  NavigationBarScene.h
//  KBC
//
//  Created by Rakesh on 08/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLImageButton.h"
#import "NavigationButton.h"
#import "GLScene.h"

@interface NavigationBar : GLElement
{
    GLImageButton *topLeftBackGroundImageView;
    GLImageButton *topRightBackGroundImageView;
    
    GLImageButton *bottomRightBackGroundImageView;
    
    NavigationButton *currentTopLeftBarButton;
    NavigationButton *currentTopRightBarButton;
    NavigationButton *currentBottomRightBarButton;
    
    GLScene *currentScene;

}

@property (nonatomic,assign) GLScene *currentScene;

+(NavigationBar *)sharedNavigationBar;

@end
