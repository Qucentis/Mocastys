//
//  RegisterScene.h
//  KBC
//
//  Created by Rakesh on 18/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLScene.h"
#import "GLButton.h"
#import "Server.h"
#import "GLTextFieldSet.h"
#import "GLVerticalScrollElement.h"

@interface RegisterScene : GLScene <UIAlertViewDelegate>
{
    GLElement *fullScreenElement;
    Server *server;
    
    GLTextFieldSet *loginFieldSet;
    GLTextFieldSet *profileFieldSet;
    GLVerticalScrollElement *verticalScrollView;
    
    
    int currentState;
    GLLabel *errorLabel;
    GLImageButton *navBarButton;
    
    GLImageButton *disclaimerButton;
    
}

@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *fullName;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *phone;


@end
