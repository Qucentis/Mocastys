//
//  MessageScene.m
//  KBC
//
//  Created by Rakesh on 07/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "MessageScene.h"
#import "AppDelegate.h"
#import "SwipeGestureRecognizer.h"
#import "DataManager.h"
#import "AppTheme.h"
#import "GLElement.h"

#define ANIMATION_MESSAGE_OPEN 1
#define ANIMATION_CONTACT_SCALE 2
#define ANIMATION_CONTACT_WIGGLE 3

@implementation MessageScene

-(id)init
{
    if (self = [super init])
    {
        
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        backImageButton.buttonType = NavigationButtonTypeBack;
        
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];

        
        self.rightNavigationBarButtonColor = Color4BFromHex(0x0);
        
        NavigationButton *actionImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 93, 93)];
        [actionImageButton setImage:@"g_actionButton_glyph-reply" ofType:@"png"];
        actionImageButton.buttonType = NavigationButtonTypeReply;
        
        self.actionBarButton = actionImageButton;
        [actionImageButton release];

        horizontalSwipeGestureRecognizer = [[SwipeGestureRecognizer alloc]init];
        [self addGestureRecognizer:horizontalSwipeGestureRecognizer];
        [horizontalSwipeGestureRecognizer setGestures:GESTURE_HORIZONTALSWIPE];
        [horizontalSwipeGestureRecognizer addTarget:self andSelector:@selector(scrollDetected:)];
        [horizontalSwipeGestureRecognizer release];
        
        int height = 200;
        int offset = 0;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            height = 400;
            offset = 50;
        }
        
        currentMessageElement = [[MessageElement alloc]
                                 initWithFrame:CGRectMake(20, self.frame.size.height/2 - height/2, self.frame.size.width - 40, height)];
        [self addElement:currentMessageElement];
        [currentMessageElement release];
        
        previousImageButton = [[GLImageButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 120 - offset, 40, 36)];
        [previousImageButton setImage:@"mv_paginationLabel_left_bkg" ofType:@"png"];
        [previousImageButton setImageColor:Color4BFromHex(0x00000088)];
        [previousImageButton setImageHighlightColor:Color4BFromHex(0x000000ee)];
        previousImageButton.enabled = NO;
        [self addElement:previousImageButton];
        [previousImageButton.textLabel setFont:@"Lato-Light" withSize:20];
        [previousImageButton.textLabel setTextColor:Color4BFromHex(0xffffffff)];
        previousImageButton.textLabel.originInsideElement = CGPointMake(-7, 0);
        [previousImageButton release];
        
        nextImageButton = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40, self.frame.size.height - 120 - offset, 40, 36)];
        [nextImageButton setImage:@"mv_paginationLabel_right_bkg" ofType:@"png"];
        [nextImageButton setImageColor:Color4BFromHex(0x00000088)];
        [nextImageButton setImageHighlightColor:Color4BFromHex(0x000000ee)];
        nextImageButton.enabled = NO;
        [nextImageButton.textLabel setFont:@"Lato-Light" withSize:20];
        [nextImageButton.textLabel setTextColor:Color4BFromHex(0xffffffff)];
        nextImageButton.textLabel.originInsideElement = CGPointMake(7, 0);
        [self addElement:nextImageButton];
        [nextImageButton release];
        
        self.lastUpdateTime = [NSDate date];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotified:) name:@"MessagesUpdatedNotification" object:nil];
      
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [self addElement:logoImageView];
        [logoImageView release];

        
    }
    return self;
}

-(void)updateNotified:(NSNotification *)notification
{
    [self setPaginationButtons];
}

-(void)leftBarButtonClicked
{
    [self.appDelegate moveMainPage:1];
}

-(void)actionBarButtonClicked
{
    [DataManager sharedDataManager].replyUsername = self.friend.username;
    [self.appDelegate moveMainPage:11 andComposePage:1];
}

-(void)sceneWillAppear
{
    self.currentMessage = self.friend.messages[self.friend.messages.count - 1];
    [currentMessageElement setMessage:self.currentMessage];
    previousImageButton.originOfElement = CGPointMake(-40, 0);
    previousImageButton.hidden = YES;
    nextImageButton.originOfElement = CGPointMake(40, 0);
    nextImageButton.hidden = YES;
    self.lastUpdateTime = [NSDate date];
    secondsElapsed = 0;
    [self setPaginationButtons];
    
}

-(void)scrollDetected:(NSArray *)eventArgs
{
    [self cancelTouchesInSubElements];
    [self.touchesInElement addObject:eventArgs[0]];
    [self touchBeganInElement:eventArgs[0] withIndex:[self.touchesInElement indexOfObject:eventArgs[0]]
                    withEvent:nil];
}


-(BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint l = [touch locationInGLElement:self];
    CGRect absframe = self.absoluteFrame;
    if (l.x >= 0 && l.y >=0 && l.x <=absframe.size.width && l.y<=absframe.size.height)
    {
        
        for (GLElement *element in gestureRecognizers)
        {
            ([element touchBegan:touch withEvent:event]);
        }
        
        for (GLElement *element in subElements.reverseObjectEnumerator)
        {
            if ([element touchBegan:touch withEvent:event])
                return YES;
        }
        
        if (!self.acceptsTouches)
            return NO;
        
        [touchesInElement addObject:touch];
        [self touchBeganInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        return YES;
    }
    
    return NO;
}

-(BOOL)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    touchStartPoint = [touch locationInGLElement:self];
    startOffset = currentMessageElement.originOfElement.x;
    return YES;
}

-(BOOL)touchMovedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    currentTouchPoint = [touch locationInGLElement:self];
    CGFloat xDiff = touchStartPoint.x - currentTouchPoint.x;
    currentMessageElement.originOfElement = CGPointMake(startOffset
                                                        -xDiff, 0);
    return YES;
}

-(BOOL)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    currentTouchPoint = [touch locationInGLElement:self];
    CGFloat xDiff = touchStartPoint.x - currentTouchPoint.x;
    currentMessageElement.originOfElement = CGPointMake(startOffset
                                                        -xDiff, 0);
    if (xDiff < -50)
    {
//       NSLog(@"right");
        int index = [self.friend.messages indexOfObject:self.currentMessage];
        if (index<self.friend.messages.count - 1)
        {
            EasingAnimation *animation1 = (EasingAnimation *)[currentMessageElement moveOriginFrom:currentMessageElement.originOfElement To:CGPointMake(self.frame.size.width, 0) withDuration:0.2 afterDelay:0 usingCurve:EasingOrdered];
            animation1.easingType = EaseIn;
                        timerStarted = NO;
            animation1.animationEndedBlock = ^(Animation *animation)
            {
                self.currentMessage = self.friend.messages[index + 1];
                [currentMessageElement setMessage:self.currentMessage];
                EasingAnimation *animation2 = (EasingAnimation *)[currentMessageElement moveOriginFrom:CGPointMake(-self.frame.size.width, 0) To:CGPointMake(0, 0) withDuration:0.2
                                                                                afterDelay:0 usingCurve:EasingOrdered];
                animation2.easingType = EaseInOut;
                animation2.animationEndedBlock = ^(Animation *animation3)
                {
                                timerStarted = YES;
                        [self setPaginationButtons];
                    currentMessageElement.originOfElement = CGPointMake(0, 0);
                };
            };
        }
        else
            [self resetScroll];
    }
    else if (xDiff > 50)
    {
        int index = [self.friend.messages indexOfObject:self.currentMessage];
        if (index > 0)
        {
        EasingAnimation *animation1 = (EasingAnimation *)[currentMessageElement moveOriginFrom:currentMessageElement.originOfElement To:CGPointMake(-self.frame.size.width, 0) withDuration:0.2 afterDelay:0 usingCurve:EasingOrdered];
        animation1.easingType = EaseIn;
            timerStarted = NO;
        animation1.animationEndedBlock = ^(Animation *animation)
        {
            self.currentMessage = self.friend.messages[index - 1];
            [currentMessageElement setMessage:self.currentMessage];
            EasingAnimation *animation2 = (EasingAnimation *)[currentMessageElement moveOriginFrom:CGPointMake(self.frame.size.width, 0) To:CGPointMake(0, 0) withDuration:0.2 afterDelay:0 usingCurve:EasingOrdered];
            animation2.easingType = EaseInOut;
            animation2.animationEndedBlock = ^(Animation *animation3)
            {
                timerStarted = YES;
                    [self setPaginationButtons];
                currentMessageElement.originOfElement = CGPointMake(0, 0);
            };
        };
        }
        else
            [self resetScroll];
    }
    else
    {
        [self resetScroll];
    }
    return YES;
}

-(void)setCurrentMessage:(Message *)currentMessage
{
    if (_currentMessage != nil)
        [_currentMessage release];
    _currentMessage = [currentMessage retain];
}

-(void)sceneDidAppear
{
    timerStarted = YES;
    NSNotification* notification = [NSNotification notificationWithName:@"EnableUpdateNotification" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeClicked) name:@"ShowChatListIfHidden" object:nil];
}

-(void)sceneWillDisappear
{
    timerStarted = NO;
    NSNotification* notification = [NSNotification notificationWithName:@"DisableUpdateNotification" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowChatListIfHidden" object:nil];
}

-(void)resetScroll
{
    
    EasingAnimation *animation1 = (EasingAnimation *)[currentMessageElement moveOriginFrom:currentMessageElement.originOfElement To:CGPointMake(0, 0) withDuration:0.2 afterDelay:0 usingCurve:EasingOrdered];
    animation1.easingType = EaseOut;
}

-(void)replyClicked
{
    [DataManager sharedDataManager].replyUsername = self.friend.username;
//    [self.appDelegate moveMainPage:2 andComposePage:1];
}

-(void)closeClicked
{
    [self.appDelegate moveMainPage:1];
}

-(void)update
{
    [super update];
    if (!timerStarted)
        return;
    int secElapsed = fabs([_currentMessage.timeOpened timeIntervalSinceNow]);
    if (_currentMessage.duration-secElapsed <= 0)
    {
        [self leftBarButtonClicked];
        return;
    }
    int seconds = abs([_lastUpdateTime timeIntervalSinceNow]);
    
    if (secondsElapsed < seconds)
    {
        secondsElapsed = 0;
        BOOL changed = NO;
        self.lastUpdateTime = [NSDate date];
        NSArray *messages = [DataManager sharedDataManager].openedMessages;
        for (int i = 0;i < messages.count;i++)
        {
            Message *m = messages[i];
            int s = fabs([m.timeOpened timeIntervalSinceNow]);
            if (s >= m.duration)
            {
                [[DataManager sharedDataManager]deleteMessage:m];
                changed = YES;
                i--;
            }
        }
        if (changed)
        {
            [self setPaginationButtons];
            [[DataManager sharedDataManager]saveDataToArchive];
        }
    }
    
}

-(void)setPaginationButtons
{
    if (![self.friend.messages containsObject:self.currentMessage])
        return;
    int index = [self.friend.messages indexOfObject:self.currentMessage];
    if (index >= self.friend.messages.count - 1)
    {
        EasingAnimation *animation2 = (EasingAnimation *)[previousImageButton moveOriginFrom:previousImageButton.originInsideElement To:CGPointMake(-40, 0) withDuration:0.3 afterDelay:0 usingCurve:EasingOrdered];
        animation2.easingType = EaseOut;
        animation2.animationEndedBlock = ^(Animation *animation)
        {
            previousImageButton.hidden = YES;
        };
    }
    else if (previousImageButton.hidden)
    {
         previousImageButton.hidden = NO;
        EasingAnimation *animation2 = (EasingAnimation *)[previousImageButton moveOriginFrom:previousImageButton.originOfElement To:CGPointMake(0, 0) withDuration:0.3 afterDelay:0 usingCurve:EasingOrdered];
        animation2.easingType = EaseOut;
        animation2.animationEndedBlock = ^(Animation *animation)
        {
            
        };
    }
    
    if (index == 0)
    {
        EasingAnimation *animation2 = (EasingAnimation *)[nextImageButton moveOriginFrom:nextImageButton.originOfElement To:CGPointMake(40, 0) withDuration:0.3 afterDelay:0 usingCurve:EasingOrdered];
        animation2.easingType = EaseOut;
        animation2.animationEndedBlock = ^(Animation *animation)
        {
            nextImageButton.hidden = YES;
        };
    }
    else if (nextImageButton.hidden)
    {
        nextImageButton.hidden = NO;
        EasingAnimation *animation2 = (EasingAnimation *)[nextImageButton moveOriginFrom:nextImageButton.originOfElement To:CGPointMake(0, 0) withDuration:0.3 afterDelay:0 usingCurve:EasingOrdered];
        animation2.easingType = EaseOut;
        animation2.animationEndedBlock = ^(Animation *animation)
        {
            
        };
    }
    [nextImageButton.textLabel setText:[NSString stringWithFormat:@"%d", index] withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    [previousImageButton.textLabel setText:[NSString stringWithFormat:@"%d",self.friend.messages.count - index - 1] withHorizontalAlignment:UITextAlignmentRight andVerticalAlignment:UITextAlignmentMiddle];

}

@end
