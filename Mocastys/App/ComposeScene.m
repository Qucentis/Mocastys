//
//  ComposeScene.m
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "ComposeScene.h"
#import "AppDelegate.h"
#import "Server.h"
#import "GLUIViewWrapper.h"
//#import <Parse/Parse.h>

#define STATE_TIMER_DISABLED 1
#define STATE_TIMER_ENABLED 2

@implementation ComposeScene

-(id)init
{
    if (self = [super init])
    {
        overlayScene = [[GLScene alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        overlayScene.acceptsTouches = NO;
        
        soundManager = [SoundManager sharedSoundManager];
        [soundManager loadSoundWithKey:@"send" soundFile:@"send_notification.aiff"];
        
        int heightOfKeyboard = 0;
        int offsetNavBar = 0;
        int offsetTextView = 0;
        int textViewHeight = 0;
        int fontSize = 0;
        int labelFontSize = 0;
        int radius = 0;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {
            heightOfKeyboard = 216;
            offsetTextView = 10;
            textViewHeight = 120;
            offsetNavBar = self.frame.size.height - 80 - textViewHeight;
            fontSize = 16;
            labelFontSize = 100;
            doneDelay = 0.1;
            sendScale = 1.0;
            startScale = 0.5;
            radius = 62;
            
            doneButton = [[GLImageButton alloc]
                          initWithFrame:CGRectMake(self.frame.size.width/2 - 130/2, heightOfKeyboard - 130/2, 130, 130)];
            doneButton.requiresMipMap = YES;
            doneButton.textLabel.requiresMipMap = YES;
            [doneButton setImage:@"c_rt_send_bkg" ofType:@"png"];
            [doneButton setBackgroundColor:Color4BFromHex(0x0)];
            [doneButton setBackgroundHightlightColor:Color4BFromHex(0x0)];
            [doneButton setImageColor:Color4BFromHex(0x000000bb)];
            [doneButton setImageHighlightColor:Color4BFromHex(0x000000ff)];;
            [doneButton.textLabel setFont:@"Lato-Bold" withSize:20];
            doneButton.textLabel.originOfElement = CGPointMake(0, 20);
            [doneButton.textLabel setText:@"DONE" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
            [overlayScene addElement:doneButton];
            [doneButton release];
            [doneButton addTarget:self andSelector:@selector(doneClicked)];
            doneButton.scaleOfElement = CGPointMake(startScale, startScale);
            
            timerControl = [[TimerControl alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 150/2, heightOfKeyboard - 150/2, 150, 150)];
            timerControl.radius = radius;
            [overlayScene addElement:timerControl];
            [timerControl release];
            timerControl.value = 10;
            timerControl.delegate = self;
            timerControl.enabled = NO;
            timerControl.scaleOfElement = CGPointMake(1.0, 1.0);
            [timerControl hideInDuration:0 afterDelay:0];
        }
        else
        {
            heightOfKeyboard = 264;
            offsetTextView = 20;
            textViewHeight = 350;
            offsetNavBar = self.frame.size.height - 150 - textViewHeight;
            fontSize = 44;
            labelFontSize = 200;
            doneDelay = 0.1;
            sendScale = 1.0;
            startScale = 0.7;
            radius = 120;
            
            doneButton = [[GLImageButton alloc]
                          initWithFrame:CGRectMake(self.frame.size.width/2 - 252/2, heightOfKeyboard - 252/2, 252, 252)];
            doneButton.requiresMipMap = YES;
            doneButton.textLabel.requiresMipMap = YES;
            [doneButton setImage:@"c_rt_send_bkg-iPad" ofType:@"png"];
            [doneButton setBackgroundColor:Color4BFromHex(0x0)];
            [doneButton setBackgroundHightlightColor:Color4BFromHex(0x0)];
            [doneButton setImageColor:Color4BFromHex(0x000000bb)];
            [doneButton setImageHighlightColor:Color4BFromHex(0x000000ff)];;
            [doneButton.textLabel setFont:@"Lato-Bold" withSize:30];
            doneButton.textLabel.originOfElement = CGPointMake(0, 30);
            [doneButton.textLabel setText:@"DONE" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
            [overlayScene addElement:doneButton];
            [doneButton release];
            [doneButton addTarget:self andSelector:@selector(doneClicked)];
            doneButton.scaleOfElement = CGPointMake(startScale, startScale);
            
            timerControl = [[TimerControl alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 300/2, heightOfKeyboard - 300/2, 300, 300)];
            timerControl.radius = radius;
            [overlayScene addElement:timerControl];
            [timerControl release];
            timerControl.value = 10;
            timerControl.delegate = self;
            timerControl.enabled = NO;
            timerControl.scaleOfElement = CGPointMake(1.0, 1.0);
            [timerControl hideInDuration:0 afterDelay:0];
        }
        
        GLUIViewWrapper *timeLabelWrapper = [[GLUIViewWrapper alloc]
                                             initWithFrame:CGRectMake(offsetTextView, offsetNavBar, self.frame.size.width - offsetTextView * 2, textViewHeight)];
        timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont fontWithName:@"Lato" size:labelFontSize];
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabelWrapper.view = timeLabel;
        [self addElement:timeLabelWrapper];
        [timeLabel release];
        
        GLUIViewWrapper *composeTextFieldWrapper = [[GLUIViewWrapper alloc]
                                                    initWithFrame:CGRectMake(offsetTextView,offsetNavBar, self.frame.size.width - 2 * offsetTextView, textViewHeight)];
        composeTextField = [[UITextView alloc]init];
        if (self.openGLView.frame.size.height > 700)
            composeTextField.frame = CGRectMake(20, 20, 280, 220);
        composeTextField.font = [UIFont fontWithName:@"Lato-Bold" size:fontSize];
        composeTextField.delegate = self;
        composeTextField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        composeTextFieldWrapper.view = composeTextField;
        [composeTextField release];
        composeTextField.delegate = self;
        [self addElement:composeTextFieldWrapper];
        [composeTextFieldWrapper release];
        
        
        
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        backImageButton.buttonType = NavigationButtonTypeBack;
        
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [self addElement:logoImageView];
        [logoImageView release];
        
       
    }
    return self;
}

-(void)leftBarButtonClicked
{
    DataManager *dataManager = [DataManager sharedDataManager];
    if (dataManager.replyUsername == nil)
        [self.appDelegate moveMainPage:1];
    else
    {
        dataManager.replyUsername = nil;
        [self.appDelegate moveMainPage:3];
    }
    

}


-(void)switchToScreenShot
{
    [self.openGLView bringSubviewToFront:timeLabel];
        composeTextField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        composeTextField.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            timeLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}

-(void)switchBack
{
    [self.openGLView bringSubviewToFront:composeTextField];
    composeTextField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
            composeTextField.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            timeLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

-(void)changeValueOfTimerControl:(int)value
{
    [DataManager sharedDataManager].durationFromCompose = value;
    timeLabel.text = [NSString stringWithFormat:@"%d",value];
}
-(void)setActiveTimerControl
{
    [self switchToScreenShot];
}
-(void)setInactiveTimerControl
{
    [self switchBack];
}

-(void)sceneWillAppear
{
    [timerControl hideInDuration:0 afterDelay:0];
    timerControl.value = [DataManager sharedDataManager].durationFromCompose;
    doneButton.scaleOfElement = CGPointMake(startScale, startScale);
    currentState = STATE_TIMER_DISABLED;
    [doneButton.textLabel setText:@"DONE" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
    timeLabel.text = [NSString stringWithFormat:@"%d",timerControl.value];
    composeTextField.text = @"";
    doneButton.enabled = YES;
}

-(void)sceneDidAppear
{
    if ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad)
        director.useOverlayOpenGLView = YES;
    [composeTextField becomeFirstResponder];
    endEditing = NO;
}

-(void)sceneWillDisappear
{
    [self switchBack];
    endEditing = YES;
     [composeTextField resignFirstResponder];
    if (currentState != STATE_TIMER_DISABLED)
    {
        [doneButton.textLabel setText:@"DONE" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [timerControl hideInDuration:0.1 afterDelay:0];

            [doneButton scaleFrom:doneButton.scaleOfElement To:CGPointMake(startScale, startScale) withDuration:0.2 afterDelay:doneDelay usingCurve:EasingBack];
        currentState= STATE_TIMER_DISABLED;
    }
    director.useOverlayOpenGLView = NO;
}

-(void)doneClicked
{
    if (currentState == STATE_TIMER_DISABLED)
    {
        currentState = STATE_TIMER_ENABLED;
        [doneButton.textLabel setText:@"SEND" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [doneButton scaleFrom:doneButton.scaleOfElement To:CGPointMake(sendScale, sendScale) withDuration:0.2 afterDelay:0 usingCurve:EasingBack];
        
        [timerControl showInDuration:0.2 afterDelay:doneDelay];
    }
    else if (currentState == STATE_TIMER_ENABLED)
    {
        doneButton.enabled = NO;
        DataManager *dataManager = [DataManager sharedDataManager];
        if (dataManager.replyUsername == nil)
        {
            Server *server = [Server sharedServer];
            [server sendMessage:composeTextField.text ToUser:dataManager.selectedUsers WithDuration:[DataManager sharedDataManager].durationFromCompose withCompletionBlock:^(NSDictionary *responseData,NSArray *errors)
             {
                 if (errors == nil)
                 {
                     NSMutableArray *channels = [[NSMutableArray alloc] init];
                     for (NSString *str in dataManager.selectedUsers)
                         [channels addObject:[NSString stringWithFormat:@"user_%@",str]];
                     
                    // PFPush *push = [[PFPush alloc] init];
                     
                  //   [push setChannels:channels];
                     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSString stringWithFormat:
                                            @"New message from %@",server.userName], @"alert",
                                           @"Increment", @"badge",
                                           @"", @"sound",
                                           nil];

                   //  [push setData:data];
                  //   [push sendPushInBackground];
                     
                    [soundManager playSoundWithKey:@"send"];
                     [self.appDelegate moveMainPage:1];
                     [channels release];
                 }
                 else
                 {
                     if (errors.count > 0)
                     {
                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[(ServerError *)errors[0] errorString] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                         [alertView show];
                         doneButton.enabled = YES;
                     }
                 }
             }];
        }
        else
        {
            Server *server = [Server sharedServer];
            [server sendMessage:composeTextField.text ToUser:[NSArray arrayWithObjects:dataManager.replyUsername, nil] WithDuration:[DataManager sharedDataManager].durationFromCompose withCompletionBlock:^(NSDictionary *responseData,NSArray *errors)
             {
                 if (errors == nil)
                 {
                     NSMutableArray *channels = [[NSMutableArray alloc] init];
                         [channels addObject:[NSString stringWithFormat:@"user_%@",dataManager.replyUsername]];
                     
                 //    PFPush *push = [[PFPush alloc] init];
                     
                //     [push setChannels:channels];
                     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSString stringWithFormat:
                                            @"New message from %@",server.userName], @"alert",
                                           @"Increment", @"badge",
                                           @"", @"sound",
                                           nil];
                     
                 //    [push setData:data];
                 //    [push sendPushInBackground];
                 
                     [soundManager playSoundWithKey:@"send"];
                      [self.appDelegate moveMainPage:3];
                     [channels release];
                                 dataManager.replyUsername = nil;
                 }
                 else
                 {
                     if (errors.count > 0)
                     {
                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[(ServerError *)errors[0] errorString] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                         [alertView show];
                         doneButton.enabled = YES;
                     }
                                 dataManager.replyUsername = nil;
                 }
             }];

        }
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (currentState != STATE_TIMER_DISABLED)
    {
        [doneButton.textLabel setText:@"DONE" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [timerControl hideInDuration:0.1 afterDelay:0];
            [doneButton scaleFrom:doneButton.scaleOfElement To:CGPointMake(startScale, startScale) withDuration:0.2 afterDelay:doneDelay usingCurve:EasingBack];
        currentState= STATE_TIMER_DISABLED;
    }
    if ([text isEqualToString:@"\n"])
    {
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 160;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    if (currentState != STATE_TIMER_DISABLED)
    {
        [doneButton.textLabel setText:@"DONE" withHorizontalAlignment:UITextAlignmentCenter andVerticalAlignment:UITextAlignmentMiddle];
        [timerControl hideInDuration:0.1 afterDelay:0];
            [doneButton scaleFrom:doneButton.scaleOfElement To:CGPointMake(startScale, startScale) withDuration:0.2 afterDelay:doneDelay usingCurve:EasingBack];
        currentState= STATE_TIMER_DISABLED;
        
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return     endEditing;
}


@end
