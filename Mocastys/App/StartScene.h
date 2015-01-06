//
//  StartScene.h
//  KBC
//
//  Created by Rakesh on 15/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLScene.h"
#import "GLImageButton.h"
#import "GLImageView.h"

@interface StartScene : GLScene
{
    GLImageButton *loginButton;
    GLImageButton *registerButton;
    
    GLElement *movableElement;
}
@end
