//
//  AppDelegate.h
//  KBC
//
//  Created by Rakesh on 05/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyFriendScene.h"
#import "MessageScene.h"
#import "LoginScene.h"
#import "StartScene.h"
#import "RegisterScene.h"
#import "SettingsScene.h"
#import "ForgotPasswordScene.h"
#import "DisclaimerScene.h"

@class FriendsListScene;
@class FriendsSelectScene;
@class ChatListScene;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    VerifyFriendScene *verifyScene;
    MessageScene *messageScene;
    LoginScene *loginScene;
    StartScene *startScene;
    RegisterScene *registerScene;
    FriendsListScene *friendsScene;
    SettingsScene *settingsScene;
    ForgotPasswordScene *forgotScene;
    DisclaimerScene *disclaimerScene;
    FriendsSelectScene *friendSelectScene;
    ChatListScene *chatListScene;
}

@property (nonatomic,retain)     ChatListScene *chatListScene;
@property (nonatomic,retain) VerifyFriendScene *verifyScene;
@property (nonatomic,retain) FriendsListScene *friendsScene;
@property (nonatomic,retain) MessageScene *messageScene;
@property (nonatomic,retain) DisclaimerScene *disclaimerScene;

@property (strong, nonatomic) UIWindow *window;
-(void)moveMainPage:(int)page andComposePage:(int)cPage;
-(void)moveComposePage:(int)cPage;
-(void)moveMainPage:(int)page;
-(void)moveContainerPage:(int)page andMainPage:(int)mpage;
-(void)moveRegisterPage:(int)page;
-(void)moveMainPage:(int)mpage andContainerPage:(int)page;

@end
