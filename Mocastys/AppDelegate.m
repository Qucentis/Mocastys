//
//  AppDelegate.m
//  KBC
//
//  Created by Rakesh on 05/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "AppDelegate.h"
#import "GLDirector.h"
#import "ChatListScene.h"
#import "FriendsListScene.h"
#import "ScenePager.h"
#import "ComposeScene.h"
#import "VerifyFriendScene.h"
#import "DataManager.h"
#import "AppTheme.h"
#import "RootOpenGLView.h"
#import "FriendsSelectScene.h"


@implementation AppDelegate

@synthesize verifyScene,messageScene,friendsScene,disclaimerScene,chatListScene;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

ScenePager *mainPager;
ScenePager *composePager;
ScenePager *registerPager;
ScenePager *containerPager;

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
   /* PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
*/
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [PFPush handlePush:userInfo];
    
    if ( application.applicationState == UIApplicationStateBackground)
    {
        NSLog(@"backgrounded");
        NSNotification* notification = [NSNotification notificationWithName:@"ShowChatListIfHidden" object:self];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    //[Parse setApplicationId:@"f65qB4RJbjvnSwefzhHp7bmeX8E9KBlYTUJIRnhp"
              //    clientKey:@"JqerTtVZwnj8xma65Wn6Ullcx68VFXXdCmNqDp3h"];
    
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    GLDirector *director = [GLDirector sharedDirector];
    [[GLDirector sharedDirector]setInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    startScene = [[StartScene alloc]init];
    
    ChatListScene *chatListScene = [[ChatListScene alloc]init];
    ComposeScene *composeScene = [[ComposeScene alloc]init];
    ComposeScene *replyScene = [[ComposeScene alloc]init];
    
    loginScene = [[LoginScene alloc]init];
    friendsScene = [[FriendsListScene alloc]init];
    
    verifyScene = [[VerifyFriendScene alloc]init];
    messageScene = [[MessageScene alloc]init];
    registerScene = [[RegisterScene alloc]init];
    settingsScene = [[SettingsScene alloc]init];
    forgotScene = [[ForgotPasswordScene alloc]init];
    disclaimerScene = [[DisclaimerScene alloc]init];
    friendSelectScene = [[FriendsSelectScene alloc]init];
    
    containerPager = [[ScenePager alloc]initWithFrame:CGRectMake(0, 0, director.rootOpenGLView.frame.size.width, director.rootOpenGLView.frame.size.height)];
    
    registerPager = [[ScenePager alloc]initWithFrame:CGRectMake(0, 0, director.rootOpenGLView.frame.size.width, director.rootOpenGLView.frame.size.height)];
    
    mainPager = [[ScenePager alloc]initWithFrame:CGRectMake(0, 0, director.rootOpenGLView.frame.size.width, director.rootOpenGLView.frame.size.height)];
    
    composePager = [[ScenePager alloc]initWithFrame:CGRectMake(0, 0, director.rootOpenGLView.frame.size.width, director.rootOpenGLView.frame.size.height)];
    
    
    [registerPager addElement:startScene atOrigin:CGPointMake(0, 0)];
    [registerPager addElement:registerScene atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width, 0)];
    [registerPager addElement:disclaimerScene atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width, -director.rootOpenGLView.frame.size.height)];
    [composePager addElement:friendSelectScene atOrigin:CGPointMake(0, 0)];
    [composePager addElement:composeScene
                    atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width, 0)];
    
    [mainPager addElement:loginScene atOrigin:CGPointMake(-1.0 * director.rootOpenGLView.frame.size.width,0)];
    [mainPager addElement:chatListScene atOrigin:CGPointMake(0, 0)];
    [mainPager addElement:composePager atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width,0)];
    [mainPager addElement:messageScene atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width, 0)];
    [mainPager addElement:settingsScene atOrigin:CGPointMake(-director.rootOpenGLView.frame.size.width, 0)];
    [mainPager addElement:replyScene atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width, -1.0 * director.rootOpenGLView.frame.size.height)];
    [mainPager addElement:forgotScene atOrigin:CGPointMake(0, 0)];
    [mainPager addElement:friendsScene atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width, 0)];
    [mainPager addElement:disclaimerScene atOrigin:CGPointMake(-director.rootOpenGLView.frame.size.width, -director.rootOpenGLView.frame.size.height)];
    [mainPager addElement:disclaimerScene atOrigin:CGPointMake(0, -director.rootOpenGLView.frame.size.height)];
    [mainPager addElement:verifyScene atOrigin:CGPointMake(2 * director.rootOpenGLView.frame.size.width, 0)];
    [mainPager addElement:composePager atOrigin:CGPointMake(2 * director.rootOpenGLView.frame.size.width,0)];
    
    [containerPager addElement:registerPager atOrigin:CGPointMake(0,0)];
    [containerPager addElement:mainPager atOrigin:CGPointMake(director.rootOpenGLView.frame.size.width, 0)];
    
    [registerPager setPage:0 animated:NO];
    [mainPager setPage:0 animated:NO];
    [containerPager setPage:0 animated:NO];
    
    [[GLDirector sharedDirector]presentScene:containerPager];
        [[GLDirector sharedDirector]setWindow:self.window];
        [[GLDirector sharedDirector] resumeTimer];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  //  [[PFInstallation currentInstallation]setBadge:0];
    
    return YES;
}

-(void)moveComposePage:(int)cPage
{
    [composePager setPage:cPage animated:YES];
}

-(void)moveMainPage:(int)page
{
    [mainPager setPage:page animated:YES];
}

-(void)moveRegisterPage:(int)page
{
    [registerPager setPage:page animated:YES];
}


-(void)moveContainerPage:(int)page andMainPage:(int)mpage
{
    [mainPager setPage:mpage animated:NO];
    [containerPager setPage:page animated:YES];
}

-(void)moveMainPage:(int)page andComposePage:(int)cPage
{
    [composePager setPage:cPage animated:NO];
    [mainPager setPage:page animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"backgrounding");
    GLDirector *director = [GLDirector sharedDirector];
    [director pauseTimer];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"backgrounding 2");
    GLDirector *director = [GLDirector sharedDirector];
    [director pauseTimer];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //[[PFInstallation currentInstallation]setBadge:0];
   //     [[PFInstallation currentInstallation] saveInBackground];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    GLDirector *director = [GLDirector sharedDirector];
    [director resumeTimer];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
 //   [[PFInstallation currentInstallation]setBadge:0];
   //     [[PFInstallation currentInstallation] saveInBackground];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
