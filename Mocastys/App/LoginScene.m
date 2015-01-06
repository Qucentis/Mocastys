//
//  LoginScene.m
//  KBC
//
//  Created by Rakesh on 10/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "LoginScene.h"
#import "AppDelegate.h"
#import "AppTheme.h"
#import "DataManager.h"
//#import <Parse/Parse.h>

@implementation LoginScene

-(id)init
{
    if (self = [super init])
    {
        server = [Server sharedServer];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            loginFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height - 190, 296, 86)];
        }
        else
        {
            loginFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height/2 + 43, 296, 86)];
        }
        
        verticalScrollView = [[GLVerticalScrollElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:verticalScrollView];
        [verticalScrollView release];
        verticalScrollView.heightOfContent = 100;
        [verticalScrollView addElement:loginFieldSet];
        
        [loginFieldSet release];
        
        [loginFieldSet setNumberOfTextFields:2];
        [loginFieldSet setPlaceholder:@"username" atIndex:0];
        [loginFieldSet setPlaceholder:@"password" atIndex:1];
        
        [loginFieldSet setImageName:@"g_sc_glyph-userName" OfType:@"png" AtIndex:0];
        [loginFieldSet setImageName:@"g_sc_glyph-password" OfType:@"png" AtIndex:1];
        [loginFieldSet setTitle:@"Login"];
        
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        [backImageButton setBackgroundColor:Color4BFromHex(0x000000)];
        [backImageButton setBackgroundHightlightColor:Color4BFromHex(0x000000)];
        [backImageButton setImageHighlightColor:Color4BFromHex(0xffffffff)];
        backImageButton.acceptsTouches = NO;
        backImageButton.buttonType = NavigationButtonTypeBack;
        
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];
        
        NavigationButton *rightImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 30, 30)];
        [rightImageButton setImage:@"g_navBar_glyph-done" ofType:@"png"];
        [rightImageButton setBackgroundColor:Color4BFromHex(0x000000)];
        [rightImageButton setBackgroundHightlightColor:Color4BFromHex(0x000000)];
        [rightImageButton setImageHighlightColor:Color4BFromHex(0xffffffff)];
        rightImageButton.acceptsTouches = NO;
        rightImageButton.buttonType = NavigationButtonTypeDone;
        
        self.rightNavigationBarButton = rightImageButton;
        [rightImageButton release];
        
        self.rightNavigationBarButtonColor = greenNavigationBarButtonColor;
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47,40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [verticalScrollView addElement:logoImageView];
        [logoImageView release];
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            forgotButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height - 235, 205, 35)];
        }
        else
        {
             forgotButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height/2  , 205, 35)];
        }
        
        [forgotButton setBackgroundColor:Color4BFromHex(0xffffff00)];;
        [forgotButton setBackgroundHightlightColor:Color4BFromHex(0xffffff00)];
        [forgotButton setImage:@"g_button_bkg" ofType:@"png"];
        
        [forgotButton setImageColor:Color4BFromHex(0x000000b3)];
        [forgotButton setImageHighlightColor:Color4BFromHex(0x111111b3)];
       
        [forgotButton.textLabel setTextColor:Color4BFromHex(0xffffffff)];
        [forgotButton.textLabel setFont:@"Lato-Bold" withSize:15];
        [forgotButton.textLabel setText:@"Reset Password" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [verticalScrollView addElement:forgotButton];
        [forgotButton release];
        [forgotButton addTarget:self andSelector:@selector(forgotClicked)];
        
    }
    return self;
}


-(void)forgotClicked
{
    [self.appDelegate moveMainPage:6];
}

-(void)leftBarButtonClicked
{
    [self.appDelegate moveContainerPage:0 andMainPage:0];
}

-(void)rightBarButtonClicked
{
    [self loginIfRequired];
}

-(void)sceneWillAppear
{
    [loginFieldSet reset];
}

-(void)sceneDidAppear
{
     director.useOverlayOpenGLView = NO;
    UITextField *passwordField = [loginFieldSet getUITextFieldAtIndex:1];
    passwordField.secureTextEntry = YES;
    
}

-(void)sceneWillDisappear
{
    
}

-(void)loginIfRequired
{
    [server loginWithUserName:[loginFieldSet getUITextFieldAtIndex:0].text
                  andPassword:[loginFieldSet getUITextFieldAtIndex:1].text withCompletionBlock:^(NSDictionary *dictionary,NSArray *errors)
     {
         if (errors == nil)
         {
            /* [PFUser logInWithUsernameInBackground:[loginFieldSet getUITextFieldAtIndex:0].text
                                          password:[loginFieldSet getUITextFieldAtIndex:1].text
                                             block:^(PFUser *user, NSError *error) {
                 if (!error)
                 {
                     [[PFInstallation currentInstallation]
                      setObject:[PFUser currentUser] forKey:@"owner"];
                     */
             
                NSString *channelName = [NSString stringWithFormat:@"user_%@",[loginFieldSet getUITextFieldAtIndex:0].text];
             //   PFInstallation *currentInstallation = [PFInstallation currentInstallation];
          //   [currentInstallation setChannels:@[channelName]];
//                [currentInstallation addUniqueObject:channelName forKey:@"channels"];
           //     [currentInstallation saveInBackground];
             
                     [[DataManager sharedDataManager] readDataForUser];
                     NSNotification* notification = [NSNotification notificationWithName:@"userLoggedIn" object:self];
                     [[NSNotificationCenter defaultCenter] postNotification:notification];
                     [self moveToMessages];
               /*  }
                 else
                 {
                     NSString *errorString = [error userInfo][@"error"];
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [alertView show];
                 }
             }];*/
            
         }
         else
         {
             ServerError *error = (ServerError *)errors[0];
             if (error.errorCode == 40)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Username or password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alertView show];
             }
             else if (error.errorCode == 41)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Username or password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 [alertView show];
             }
         }
     }
     ];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [alertView release];
}

-(void)moveToMessages
{
    [self.appDelegate moveMainPage:1];
}

@end
