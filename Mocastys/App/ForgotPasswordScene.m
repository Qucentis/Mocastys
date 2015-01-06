//
//  ForgotPasswordScene.m
//  KBC
//
//  Created by Rakesh on 30/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "ForgotPasswordScene.h"
#import "AppTheme.h"
#import "AppDelegate.h"
#import "Server.h"

@implementation ForgotPasswordScene

-(id)init
{
    if (self == [super init])
    {
        verticalScrollView = [[GLVerticalScrollElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:verticalScrollView];
        [verticalScrollView release];
        verticalScrollView.heightOfContent = 100;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            userNameFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height - 150, 296, 43)];
        }
        else
        {
             userNameFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height/2 + 43, 296, 43)];
        }

        [userNameFieldSet setNumberOfTextFields:1];
        [userNameFieldSet setPlaceholder:@"email" atIndex:0];
        [userNameFieldSet setTitle:@"Reset password"];
        [userNameFieldSet setImageName:@"g_sc_glyph-email" OfType:@"png" AtIndex:0];
        
        [verticalScrollView addElement:userNameFieldSet];
        [userNameFieldSet release];
        
        
    
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        backImageButton.acceptsTouches = NO;
        backImageButton.buttonType = NavigationButtonTypeBack;
        
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];
        
        NavigationButton *rightImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 30, 30)];
        [rightImageButton setImage:@"g_navBar_glyph-done" ofType:@"png"];
        rightImageButton.buttonType = NavigationButtonTypeDone;
        rightImageButton.acceptsTouches = NO;
        
        self.rightNavigationBarButton = rightImageButton;
        [rightImageButton release];
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [verticalScrollView addElement:logoImageView];
        [logoImageView release];
        
        self.rightNavigationBarButtonColor = greenNavigationBarButtonColor;

        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            disclaimerButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height - 195, 205, 35)];
        }
        else
        {
            disclaimerButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height/2  , 205, 35)];
        }
        
        [disclaimerButton setBackgroundColor:Color4BFromHex(0xffffff00)];;
        [disclaimerButton setBackgroundHightlightColor:Color4BFromHex(0xffffff00)];
        [disclaimerButton setImage:@"g_button_bkg" ofType:@"png"];
        
        [disclaimerButton setImageColor:Color4BFromHex(0x000000b3)];
        [disclaimerButton setImageHighlightColor:Color4BFromHex(0x111111b3)];
        
        [disclaimerButton.textLabel setTextColor:Color4BFromHex(0xffffffff)];
        [disclaimerButton.textLabel setFont:@"Lato-Bold" withSize:15];
        [disclaimerButton.textLabel setText:@"Disclaimer" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [verticalScrollView addElement:disclaimerButton];
        [disclaimerButton addTarget:self andSelector:@selector(disclaimerClicked)];
                [disclaimerButton release];

    }
    return self;
}

-(void)disclaimerClicked
{
    self.appDelegate.disclaimerScene.fromScene = 3;
    [self.appDelegate moveMainPage:9];
}

-(void)leftBarButtonClicked
{
    [self.appDelegate moveMainPage:0];
}

-(void)rightBarButtonClicked
{
    [self resetPassword];
}

-(void)sceneDidDisappear
{
    [userNameFieldSet reset];
}
-(void)sceneDidAppear
{
    director.useOverlayOpenGLView = YES;
}

-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0)
    {
        [[userNameFieldSet getUITextFieldAtIndex:0]becomeFirstResponder];
    }
    else if (alertView.tag == 1)
    {
        [self.appDelegate moveMainPage:0];
    }
}

-(void)resetPassword
{
    NSString *username = [userNameFieldSet getUITextFieldAtIndex:0].text;
    if (![self IsValidEmail:username Strict:YES])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 0;
        [alertView show];
        [alertView release];
        return;
    }
    
    Server *server = [Server sharedServer];
    self.acceptsTouches = NO;
    [server getAccessTokenWithCompletionBlock:^(NSDictionary *responseDict1,NSArray *errors1)
     {
        if (errors1 == nil)
        {
            [server resetPassword:username withCompletionBlock:^(NSDictionary *responseDict2,NSArray *errors2)
             {
                if (errors2 == nil)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"An email has been sent to you containing information on how to reset your password."
                                                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                    alertView.tag = 1;
                    [alertView release];

                }
                 else
                 {
                     ServerError *error2 = errors2[0];
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:error2.errorString
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alertView show];
                     [alertView release];
                 }
                self.acceptsTouches = YES;
             }];
        }
         else
         {
             ServerError *error = errors1[0];
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:error.errorString
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             alertView.tag = 0;
             [alertView show];
             [alertView release];
             self.acceptsTouches = YES;
         }
    }];
}


-(void)goBack
{
    [self.appDelegate moveRegisterPage:0];
}

@end
