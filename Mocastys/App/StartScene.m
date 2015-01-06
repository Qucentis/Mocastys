//
//  StartScene.m
//  KBC
//
//  Created by Rakesh on 15/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "StartScene.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "GLVerticalScrollElement.h"

@implementation StartScene

-(id)init
{
    if (self = [super init])
    {
        GLVerticalScrollElement *verticalScrollView = [[GLVerticalScrollElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:verticalScrollView];
        [verticalScrollView release];
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 75, self.frame.size.height/2 -65, 150, 150)];
        [logoImageView setImage:@"g_logo-styled" ofType:@"png"];
        [verticalScrollView addElement:logoImageView];
        [logoImageView release];
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            movableElement = [[GLElement alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 86)];
        } else {
            movableElement = [[GLElement alloc]initWithFrame:CGRectMake(0, 320, self.frame.size.width, 86)];
        }
        [verticalScrollView addElement:movableElement];
        [movableElement release];
        
        registerButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 151, 43, 302, 43)];
        [registerButton setImage:@"w_registerButton" ofType:@"png"];
        [registerButton setBackgroundColor:Color4BFromHex(0xffffff00)];
        [registerButton setBackgroundHightlightColor:Color4BFromHex(0xffffff00)];
        [registerButton setImageColor:Color4BFromHex(0xffffffff)];
        [registerButton setImageHighlightColor:Color4BFromHex(0xfffffff)];
        [movableElement addElement:registerButton];
        [registerButton release];
        
        [registerButton addTarget:self andSelector:@selector(registerClicked)];

        
        loginButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 151, 0, 302, 43)];
        [loginButton setImage:@"w_loginButton" ofType:@"png"];
        [loginButton setBackgroundColor:Color4BFromHex(0)];
        [loginButton setBackgroundHightlightColor:Color4BFromHex(0)];
        [loginButton setImageColor:Color4BFromHex(0xffffffff)];
        [loginButton setImageHighlightColor:Color4BFromHex(0xfffffff)];
        [movableElement addElement:loginButton];
        [loginButton release];
        
        [loginButton addTarget:self andSelector:@selector(loginClicked)];
        
    }
    return self;
}

-(void)registerClicked
{
    [self.appDelegate moveRegisterPage:1];
}

-(void)loginClicked
{
    [self.appDelegate moveContainerPage:1 andMainPage:0];
}

-(void)sceneWillAppear
{
    movableElement.originOfElement = CGPointMake(0, -500);
}

-(void)moveToMessages
{
    [self.appDelegate moveContainerPage:1 andMainPage:1];
}

-(void)sceneDidAppear
{

    Server *server = [Server sharedServer];
    
    if (server.authorizationToken != nil)
    {
        [self performSelector:@selector(moveToMessages) withObject:nil afterDelay:1.0];
        [[DataManager sharedDataManager] readDataForUser];
        
        [server receiveMessagesWithCompletionBlock:^(NSArray *data,NSArray *error)
         {
             if (error == nil)
             {
                 NSNotification* notification = [NSNotification notificationWithName:@"userLoggedIn" object:self];
                 [[NSNotificationCenter defaultCenter] postNotification:notification];
                 [self performSelector:@selector(moveToMessages) withObject:nil afterDelay:1.0];
             }
             else
             {
                 [server resetAuthorizationToken];
                 EasingBackAnimation *animation = (EasingBackAnimation * )[movableElement moveOriginFrom:movableElement.originOfElement To:CGPointMake(0, 0) withDuration:0.9 afterDelay:0 usingCurve:EasingBack];
                 animation.easingType = EaseOut;
                 
             }
         }
         ];
    }
    else
    {
        EasingBackAnimation *animation = (EasingBackAnimation * )[movableElement moveOriginFrom:movableElement.originOfElement To:CGPointMake(0, 0) withDuration:0.9 afterDelay:0 usingCurve:EasingBack];
        animation.easingType = EaseOut;
        
    }
}

-(void)sceneDidDisappear
{

}

@end
