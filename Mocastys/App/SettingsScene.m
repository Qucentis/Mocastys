//
//  SettingsScene.m
//  KBC
//
//  Created by Rakesh on 21/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "SettingsScene.h"
#import "AppTheme.h"
#import "AppDelegate.h"
#import "Server.h"
#import "DataManager.h"
#import "ChatListScene.h"
//#import <Parse/Parse.h>

@implementation SettingsScene

-(id)init
{
    if (self = [super init])
    {
        GLVerticalScrollElement *verticalScrollView = [[GLVerticalScrollElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:verticalScrollView];
        [verticalScrollView release];
        verticalScrollView.heightOfContent = 100;
    
        NavigationButton *rightImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 30, 30)];
        [rightImageButton setImage:@"g_navBar_glyph-forward" ofType:@"png"];
        [rightImageButton setBackgroundColor:Color4BFromHex(0x000000)];
        [rightImageButton setBackgroundHightlightColor:Color4BFromHex(0x000000)];
        [rightImageButton setImageHighlightColor:Color4BFromHex(0xffffffff)];
        rightImageButton.buttonType = NavigationButtonTypeForward;
        
        self.rightNavigationBarButton = rightImageButton;
        [rightImageButton release];
        
        self.rightNavigationBarButtonColor = Color4BFromHex(0x0);
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [verticalScrollView addElement:logoImageView];
        [logoImageView release];
        
        
        
        logoutButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height/2 +25 , 205, 35)];
        disclaimerButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 205/2,self.frame.size.height/2 - 25, 205, 35)];
        
        
        [logoutButton setBackgroundColor:Color4BFromHex(0xffffff00)];;
        [logoutButton setBackgroundHightlightColor:Color4BFromHex(0xffffff00)];
        [logoutButton setImage:@"g_button_bkg" ofType:@"png"];
        
        [logoutButton setImageColor:Color4BFromHex(0x000000b3)];
        [logoutButton setImageHighlightColor:Color4BFromHex(0x111111b3)];
        
        [logoutButton.textLabel setTextColor:Color4BFromHex(0xffffffff)];
        [logoutButton.textLabel setFont:@"Lato-Bold" withSize:15];
        [logoutButton.textLabel setText:@"Logout" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [verticalScrollView addElement:logoutButton];
        [logoutButton release];
        [logoutButton addTarget:self andSelector:@selector(logout)];
        
        [disclaimerButton setBackgroundColor:Color4BFromHex(0xffffff00)];;
        [disclaimerButton setBackgroundHightlightColor:Color4BFromHex(0xffffff00)];
        [disclaimerButton setImage:@"g_button_bkg" ofType:@"png"];
        
        [disclaimerButton setImageColor:Color4BFromHex(0x000000b3)];
        [disclaimerButton setImageHighlightColor:Color4BFromHex(0x111111b3)];
        
        [disclaimerButton.textLabel setTextColor:Color4BFromHex(0xffffffff)];
        [disclaimerButton.textLabel setFont:@"Lato-Bold" withSize:15];
        [disclaimerButton.textLabel setText:@"Disclaimer" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [verticalScrollView addElement:disclaimerButton];
        [disclaimerButton release];
        [disclaimerButton addTarget:self andSelector:@selector(showDisclaimer)];
    }
    
    return self;
}

-(void)showDisclaimer
{
    self.appDelegate.disclaimerScene.fromScene = 1;
    [self.appDelegate moveMainPage:8];
}

-(void)logout
{
    Server *server = [Server sharedServer];
     NSString *channelName = [NSString stringWithFormat:@"user_%@",server.userName];
   // PFInstallation *currentInstallation = [PFInstallation currentInstallation];
   // [currentInstallation removeObject:channelName forKey:@"channels"];
   // [currentInstallation saveInBackground];
    
    [[Server sharedServer]resetAuthorizationToken];
    [[DataManager sharedDataManager]clearData];
    [self.appDelegate moveContainerPage:0 andMainPage:4];
}


-(void)rightBarButtonClicked
{
    [self.appDelegate moveMainPage:1];
}

@end
