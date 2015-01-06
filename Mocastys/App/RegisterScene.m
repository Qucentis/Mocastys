//
//  RegisterScene.m
//  KBC
//
//  Created by Rakesh on 18/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "RegisterScene.h"
#import "AppTheme.h"
#import "AppDelegate.h"
//#import <Parse/Parse.h>

#define STATE_USERNAME 1
#define STATE_EMAIL 2
#define STATE_PASSWORD 3
#define STATE_EMAILLABEL 4


@implementation RegisterScene

-(id)init
{
    if (self = [super init])
    {
        server = [Server sharedServer];
        
        verticalScrollView = [[GLVerticalScrollElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:verticalScrollView];
        [verticalScrollView release];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            loginFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height - 190, 296, 86)];
        }
        else
        {
            loginFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height/2 + 100, 296, 86)];
        }
        [verticalScrollView addElement:loginFieldSet];
        [loginFieldSet release];
        
        [loginFieldSet setNumberOfTextFields:2];
        [loginFieldSet setPlaceholder:@"username" atIndex:0];
        [loginFieldSet setPlaceholder:@"password" atIndex:1];
        [loginFieldSet getUITextFieldAtIndex:1].secureTextEntry = YES;
        
        [loginFieldSet setImageName:@"g_sc_glyph-userName" OfType:@"png" AtIndex:0];
        [loginFieldSet setImageName:@"g_sc_glyph-password" OfType:@"png" AtIndex:1];
        [loginFieldSet setTitle:@"Login"];
        [loginFieldSet addTarget:self andSelector:@selector(glTextFieldBeginEditing:) forEvent:GLTextFieldSetBeginEditing];
        loginFieldSet.tag = 1;
        [loginFieldSet addTarget:self andSelector:@selector(glTextFieldSetChange:) forEvent:GLTextFieldSetChangeFieldSet];
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            profileFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height - 370, 296, 86)];
            if (self.openGLView.frame.size.height < 500)
                verticalScrollView.heightOfContent = self.frame.size.height - 90;
            else
                verticalScrollView.heightOfContent = self.frame.size.height - 160;
        }
        else
        {
            profileFieldSet = [[GLTextFieldSet alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 302/2, self.frame.size.height/2 - 90, 296, 86)];
            verticalScrollView.heightOfContent = self.frame.size.height - 216;
        }
        [verticalScrollView addElement:profileFieldSet];
        [profileFieldSet setNumberOfTextFields:3];
        [profileFieldSet setPlaceholder:@"full name" atIndex:0];
        [profileFieldSet setPlaceholder:@"email" atIndex:1];
        [profileFieldSet setPlaceholder:@"phone" atIndex:2];
        [profileFieldSet setTitle:@"Profile Information"];
        
        [profileFieldSet setImageName:@"g_sc_glyph-fullName" OfType:@"png" AtIndex:0];
        [profileFieldSet setImageName:@"g_sc_glyph-email" OfType:@"png" AtIndex:1];
        [profileFieldSet setImageName:@"g_sc_glyph-phone" OfType:@"png" AtIndex:2];
        [profileFieldSet addTarget:self andSelector:@selector(glTextFieldBeginEditing:) forEvent:GLTextFieldSetBeginEditing];
        profileFieldSet.tag = 2;
        [profileFieldSet addTarget:self andSelector:@selector(glTextFieldSetChange:) forEvent:GLTextFieldSetChangeFieldSet];
        
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        [backImageButton setBackgroundColor:Color4BFromHex(0x000000)];
        [backImageButton setBackgroundHightlightColor:Color4BFromHex(0x000000)];
        [backImageButton setImageHighlightColor:Color4BFromHex(0xffffffff)];
        backImageButton.buttonType = NavigationButtonTypeBack;
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];
        
        NavigationButton *rightImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 30, 30)];
        [rightImageButton setImage:@"g_navBar_glyph-done" ofType:@"png"];
        [rightImageButton setBackgroundColor:Color4BFromHex(0x000000)];
        [rightImageButton setBackgroundHightlightColor:Color4BFromHex(0x000000)];
        [rightImageButton setImageHighlightColor:Color4BFromHex(0xffffffff)];
        rightImageButton.buttonType = NavigationButtonTypeDone;
        
        self.rightNavigationBarButton = rightImageButton;
        [rightImageButton release];
        
        self.rightNavigationBarButtonColor = greenNavigationBarButtonColor;
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [verticalScrollView addElement:logoImageView];
        [logoImageView release];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            disclaimerButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height - 420, 205, 35)];
        }
        else
        {
            disclaimerButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height/2 - 150 , 205, 35)];
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
    self.appDelegate.disclaimerScene.fromScene = 2;
    [self.appDelegate moveRegisterPage:2];
}

-(void)glTextFieldSetChange:(GLTextFieldSet *)textFieldSet
{
    if (textFieldSet.tag == 1)
        [profileFieldSet beginEditingTextFieldAtIndex:0];
    else if (textFieldSet.tag == 2)
        [loginFieldSet beginEditingTextFieldAtIndex:0];
    
}

-(void)glTextFieldBeginEditing:(GLTextField *)textField
{
    [verticalScrollView moveToVisibleRect:textField];
}

-(void)leftBarButtonClicked
{
    [self.appDelegate moveRegisterPage:0];
}

-(void)rightBarButtonClicked
{
    if (![self validateUserNameControl])
        return;
}

-(void)sceneDidAppear
{
    director.useOverlayOpenGLView = YES;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (self.openGLView.frame.size.height < 500)
            verticalScrollView.heightOfContent = self.frame.size.height - 30;
        else
            verticalScrollView.heightOfContent = self.frame.size.height - 100;
    }
    else
    {
        verticalScrollView.heightOfContent = self.frame.size.height - 216;
    }

}

-(void)sceneWillAppear
{
    [loginFieldSet reset];
    [profileFieldSet reset];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [loginFieldSet beginEditingTextFieldAtIndex:0];
    }
    else if (alertView.tag == 2)
    {
        [loginFieldSet beginEditingTextFieldAtIndex:1];
    }
    else if (alertView.tag == 3)
    {
        [profileFieldSet beginEditingTextFieldAtIndex:0];
    }
    else if (alertView.tag == 4)
    {
        [profileFieldSet beginEditingTextFieldAtIndex:1];
    }
    else if (alertView.tag == 5)
    {
        [profileFieldSet beginEditingTextFieldAtIndex:2];
    }
    else if (alertView.tag == 10)
    {
         [self.appDelegate moveRegisterPage:0];
    }
    [alertView release];
}

-(BOOL)validateUserNameControl
{
    NSString *userName = [loginFieldSet getUITextFieldAtIndex:0].text;
    
    NSCharacterSet * characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:
                                                  userName];
    NSMutableCharacterSet *userNameCharacterSet = [NSCharacterSet alphanumericCharacterSet];
    [userNameCharacterSet addCharactersInString:@"_"];
    
    
    
    if ([userName isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 1;
        [alertView show];
        return NO;
    }
    
    if (userName.length < 7)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username needs atleast 7 characters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 1;
        [alertView show];
        return NO;
    }
    
    if (![userNameCharacterSet isSupersetOfSet:characterSetFromTextField])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Username!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 1;
        [alertView show];
        return NO;
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userName,@"username", nil];
    [server checkAvailability:dictionary withCompletionBlock:^(NSDictionary *responseDict1, NSArray *errors1) {
        if (errors1 == nil)
        {
            if ([responseDict1[@"available"] integerValue] == 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username already exists!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alertView.tag = 1;
                [alertView show];
            }
            else
            {
                self.userName = userName;
                if (![self validatePassword])
                    return;
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[(ServerError *)errors1[0] errorString]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertView.tag = 10;
            [alertView show];
        }

    
    }];
    [dictionary release];
    return NO;
}

-(BOOL)validateUserFullName
{

    NSString *fullName = [profileFieldSet getUITextFieldAtIndex:0].text;
    if ([[fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Full name required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 3;
        [alertView show];
        return NO;
    }
    self.fullName  = fullName;
    [self validatePhoneandEmail];
    return YES;
}


-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

-(BOOL)validatePhoneandEmail
{
    NSString *email = [profileFieldSet getUITextFieldAtIndex:1].text;
    NSString *phone = [profileFieldSet getUITextFieldAtIndex:2].text;
    
    if ([[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Email required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 4;
        [alertView show];
        return NO;

    }
    
    if (![self IsValidEmail:email Strict:YES])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 4;
        [alertView show];
        return NO;
    }
    
    if ([[phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Phone number required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 5;
        [alertView show];
        return NO;
    }
    
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:phone,@"phone",email,@"email", nil];
    [server checkAvailability:dictionary withCompletionBlock:^(NSDictionary *responseDict1, NSArray *errors1) {
        if (errors1 == nil)
        {
            if ([responseDict1[@"available"] integerValue] == 0)
            {
                if ([responseDict1[@"phone"] integerValue] == 0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Phone number already exists!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alertView.tag = 4;
                    [alertView show];
                }
                if ([responseDict1[@"email"] integerValue] == 0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Email number already exists!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alertView.tag = 5;
                }
                
                return ;
            }
            
            self.phone = phone;
            self.email = email;
            
            [self registerUser];
        }
        else
        {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[(ServerError *)errors1[0] errorString]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertView.tag = 10;
            [alertView show];
        }
    }];
    [dictionary release];
    
    return NO;
}

-(void)registerUser
{
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self.userName,@"username",self.fullName,@"name",
                                [self strippedPhoneNumber:self.phone],@"phone",self.email,@"email",self.password,@"password", nil];
    [server registerUser:dictionary withCompletionBlock:^(NSDictionary *responseDict1, NSArray *errors1) {
        if (errors1 == nil)
        {
           /* PFUser *user = [PFUser user];
            user.username = self.userName;
            user.password = self.password;
            
            // other fields can be set just like with PFObject
            
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error)
                {*/
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Registration Completed. You'll receive an email with a link to activate your account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    alertView.tag = 10;
                    [alertView show];
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
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[(ServerError *)errors1[0] errorString]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertView.tag = 10;
            [alertView show];
        }
    }];
    [dictionary release];
}

-(NSString *)strippedPhoneNumber:(NSString *)number
{
    NSString *originalString = number;
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
}

-(BOOL)validatePassword
{
    
    NSString *password = [loginFieldSet getUITextFieldAtIndex:1].text;
    
    if ([password isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Password required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 2;
        [alertView show];
        return NO;
    }
    
    if (password.length < 8)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Password needs atleast 7 characters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 2;
        [alertView show];
        return NO;
    }
    
    if (![[NSCharacterSet alphanumericCharacterSet] isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:password]])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Password can only be alphanumeric!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 2;
        [alertView show];
        return NO;
    }
    
    
    if (![password isEqualToString:password])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Password entered in both fields has to match!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alertView.tag = 2;
        [alertView show];
        return NO;
    }
    
    self.password = password;
    
    [self validateUserFullName];
    
    return NO;
}


@end
