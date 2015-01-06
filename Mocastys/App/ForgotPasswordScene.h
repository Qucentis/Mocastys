//
//  ForgotPasswordScene.h
//  KBC
//
//  Created by Rakesh on 30/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLScene.h"
#import "GLTextFieldSet.h"
#import "GLButton.h"
#import "GLVerticalScrollElement.h"

@interface ForgotPasswordScene : GLScene
{
    GLTextFieldSet *userNameFieldSet;
    GLImageButton *disclaimerButton;
    GLVerticalScrollElement *verticalScrollView;
}
@end
