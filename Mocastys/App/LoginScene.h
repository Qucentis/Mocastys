//
//  LoginScene.h
//  KBC
//
//  Created by Rakesh on 10/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLScene.h"
#import "Server.h"
#import "GLLabel.h"
#import "GLButton.h"
#import "GLTextFieldSet.h"
#import "GLVerticalScrollElement.h"


@interface LoginScene : GLScene <UITextFieldDelegate,UIAlertViewDelegate>
{
    GLTextFieldSet *loginFieldSet;
    GLVerticalScrollElement *verticalScrollView;
    
    Server *server;
    GLImageButton *forgotButton;
    
}
@end
