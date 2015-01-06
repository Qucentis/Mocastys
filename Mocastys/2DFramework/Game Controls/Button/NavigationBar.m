//
//  NavigationBarScene.m
//  KBC
//
//  Created by Rakesh on 08/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "NavigationBar.h"
#import "OverlayOpenGLView.h"

@implementation NavigationBar

@synthesize currentScene;

CGFloat navigationBarButtonWidth;
CGFloat navigationBarButtonHeight;
CGFloat navBarBorderWidth;
CGFloat actionBarButtonWidth;
CGFloat actionBarButtonHeight;

+(NavigationBar *)sharedNavigationBar
{
    static NavigationBar *navBar = nil;
    @synchronized(self)
    {
        if (navBar == nil)
        {
            navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 20)];
        }
    }
    return navBar;
}

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        [director.overlayOpenGLview.mainScene addElement:self];
        [self createControls];
        self.acceptsTouches = NO;
        
    }
    return self;
}


-(void)createControls
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        navBarBorderWidth = 6;
        navigationBarButtonWidth = navigationBarButtonHeight = 63;
        actionBarButtonWidth = actionBarButtonHeight = 93;
        topLeftBackGroundImageView = [[GLImageButton alloc]initWithFrame:CGRectMake(0,self.frame.size.height, 63, 63)];
        topRightBackGroundImageView = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width -63,self.frame.size.height, 63, 63)];
        bottomRightBackGroundImageView = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width -93,-93, 93, 93)];
        [topLeftBackGroundImageView setImage:@"g_navBar_left_bkg" ofType:@"png"];
        [topRightBackGroundImageView setImage:@"g_navBar_right_bkg" ofType:@"png"];
        [bottomRightBackGroundImageView setImage:@"g_actionButton_bkg" ofType:@"png"];
    } else
    {
        navBarBorderWidth = 8;
        navigationBarButtonWidth = navigationBarButtonHeight = 94;
        actionBarButtonWidth = actionBarButtonHeight = 139;
        
        topLeftBackGroundImageView = [[GLImageButton alloc]initWithFrame:CGRectMake(0,self.frame.size.height, 94, 94)];
        topRightBackGroundImageView = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width -94,self.frame.size.height, 94, 94)];
        bottomRightBackGroundImageView = [[GLImageButton alloc]initWithFrame:CGRectMake(self.frame.size.width -139,-139, 139, 139)];
        [topLeftBackGroundImageView setImage:@"g_navBar_left_bkg-iPad" ofType:@"png"];
        [topRightBackGroundImageView setImage:@"g_navBar_right_bkg-iPad" ofType:@"png"];
        [bottomRightBackGroundImageView setImage:@"g_actionButton_bkg-iPad" ofType:@"png"];
    }
    
    
    
    [topLeftBackGroundImageView setImageColor:Color4BFromHex(0x000000bb)];
    [self addElement:topLeftBackGroundImageView];
    topLeftBackGroundImageView.hidden = YES;
    topLeftBackGroundImageView.clipToBounds = YES;
    [topLeftBackGroundImageView addTarget:self andSelector:@selector(leftButtonClicked)];
    [topLeftBackGroundImageView setBackgroundColor:Color4BFromHex(0x000000)];
    [topLeftBackGroundImageView setBackgroundHightlightColor:Color4BFromHex(0x000000)];
    [topLeftBackGroundImageView release];
    
    [self addElement:topRightBackGroundImageView];
    [topRightBackGroundImageView setImageColor:Color4BFromHex(0x000000bb)];
    topRightBackGroundImageView.hidden = YES;
    topRightBackGroundImageView.clipToBounds = YES;
    [topRightBackGroundImageView addTarget:self andSelector:@selector(rightButtonClicked)];
    [topRightBackGroundImageView setBackgroundColor:Color4BFromHex(0x000000)];
    [topRightBackGroundImageView setBackgroundHightlightColor:Color4BFromHex(0x000000)];
    [topRightBackGroundImageView release];
    
    [bottomRightBackGroundImageView setImageColor:Color4BFromHex(0x000000bb)];
    [self addElement:bottomRightBackGroundImageView];
    bottomRightBackGroundImageView.hidden = YES;
    bottomRightBackGroundImageView.clipToBounds = YES;
    [bottomRightBackGroundImageView addTarget:self andSelector:@selector(actionButtonClicked)];
    [bottomRightBackGroundImageView setBackgroundColor:Color4BFromHex(0x000000)];
    [bottomRightBackGroundImageView setBackgroundHightlightColor:Color4BFromHex(0x000000)];
    [bottomRightBackGroundImageView release];
    
    
}

-(void)leftButtonClicked
{
    [currentScene leftBarButtonClicked];
}

-(void)rightButtonClicked
{
    [currentScene rightBarButtonClicked];
}

-(void)actionButtonClicked
{
    [currentScene actionBarButtonClicked];
}

-(void)setCurrentScene:(GLScene *)_currentScene
{
    currentScene = _currentScene;
    [self setTopLeftBarButton:currentScene.leftNavigationBarButton];
    [self setTopRightBarButton:currentScene.rightNavigationBarButton];
    [self setBottomRightBarButton:currentScene.actionBarButton];
}

-(void)setTopLeftBarButton:(NavigationButton *)button
{
    button.acceptsTouches = NO;
    [button setBackgroundColor:Color4BFromHex(0x000000)];
    [button setBackgroundHightlightColor:Color4BFromHex(0x000000)];
    [button setImageHighlightColor:Color4BFromHex(0xffffffff)];
    if (button == nil)
    {
        if (!topLeftBackGroundImageView.hidden)
        {
            EasingAnimation *easingAnimation = (EasingAnimation *)[topLeftBackGroundImageView
                                                                   moveOriginFrom:topLeftBackGroundImageView.originOfElement To:CGPointMake(0, 0)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            topLeftBackGroundImageView.acceptsTouches = NO;
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                topLeftBackGroundImageView.hidden = YES;
                topLeftBackGroundImageView.acceptsTouches = YES;
            };
        }
    }
    else
    {
        if (topLeftBackGroundImageView.hidden)
        {
            Color4B nColor = currentScene.leftNavigationBarButtonColor;
            nColor.alpha = 0xbb;
            Color4B hColor = currentScene.leftNavigationBarButtonColor;
            hColor.alpha = 0xee;
            [topLeftBackGroundImageView setImageColor:nColor];
            [topLeftBackGroundImageView setImageHighlightColor:hColor];
            
            topLeftBackGroundImageView.hidden = NO;
            topLeftBackGroundImageView.acceptsTouches = NO;
            EasingAnimation *easingAnimation = (EasingAnimation *)[topLeftBackGroundImageView
                                                                   moveOriginFrom:topLeftBackGroundImageView.originOfElement To:CGPointMake(0, -navigationBarButtonHeight)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                topLeftBackGroundImageView.acceptsTouches = YES;
            };
            
            
            button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 - navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
            [topLeftBackGroundImageView removeElement:currentTopLeftBarButton];
            currentTopLeftBarButton = button;
            [topLeftBackGroundImageView addElement:button];
        }
        else
        {
            Color4B nColor = currentScene.leftNavigationBarButtonColor;
            nColor.alpha = 0xbb;
            Color4B hColor = currentScene.leftNavigationBarButtonColor;
            hColor.alpha = 0xee;
            [topLeftBackGroundImageView changeImageColorFrom:topLeftBackGroundImageView.imageColor To:nColor withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
            [topLeftBackGroundImageView setImageHighlightColor:hColor];
            topLeftBackGroundImageView.acceptsTouches = YES;
            
            EasingAnimation *easingAnimation = (EasingAnimation *)[topLeftBackGroundImageView
                                                                   moveOriginFrom:topLeftBackGroundImageView.originOfElement To:CGPointMake(0, -navigationBarButtonHeight)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                topLeftBackGroundImageView.acceptsTouches = YES;
            };

            
            if (button.buttonType != currentTopLeftBarButton.buttonType)
            {
                topLeftBackGroundImageView.acceptsTouches = NO;
                
                button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 - navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
                
                [topLeftBackGroundImageView addElement:button];
                button.clipToBounds = YES;
                currentTopLeftBarButton.clipToBounds = YES;
                
                EasingAnimation *easingAnimation1 = (EasingAnimation *)[currentTopLeftBarButton
                                                                        moveOriginInsideFrom:currentTopLeftBarButton.originOfElement To:CGPointMake(0, -currentTopLeftBarButton.frame.size.height)  withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
                easingAnimation1.easingType = EaseOut;
                easingAnimation1.animationEndedBlock = ^(Animation *animation)
                {
                    [topLeftBackGroundImageView removeElement:currentTopLeftBarButton];
                    currentTopLeftBarButton.originInsideElement = CGPointMake(0, 0);
                    currentTopLeftBarButton = button;
                    
                };
                
                button.originInsideElement = CGPointMake(0, button.frame.size.height);
                EasingAnimation *easingAnimation2 = (EasingAnimation *)[button
                                                                        moveOriginInsideFrom:CGPointMake(0, button.frame.size.height)
                                                                        To:CGPointMake(0, 0)  withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
                easingAnimation2.easingType = EaseOut;
                easingAnimation2.animationEndedBlock = ^(Animation *animation)
                {
                    button.originInsideElement = CGPointMake(0, 0);
                    button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 - navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
                };
            }
            else
            {
                [topLeftBackGroundImageView removeElement:currentTopLeftBarButton];
                currentTopLeftBarButton = button;
                button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 - navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
                [topLeftBackGroundImageView addElement:button];
            }
        }
    }
}

-(void)setTopRightBarButton:(NavigationButton *)button
{
    button.acceptsTouches = NO;
    [button setBackgroundColor:Color4BFromHex(0x000000)];
    [button setBackgroundHightlightColor:Color4BFromHex(0x000000)];
    [button setImageHighlightColor:Color4BFromHex(0xffffffff)];
    if (button == nil)
    {
        if (!topRightBackGroundImageView.hidden)
        {
            topRightBackGroundImageView.acceptsTouches = NO;
            EasingAnimation *easingAnimation = (EasingAnimation *)[topRightBackGroundImageView
                                                                   moveOriginFrom:topRightBackGroundImageView.originOfElement To:CGPointMake(0, 0)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                topRightBackGroundImageView.hidden = YES;
                topRightBackGroundImageView.acceptsTouches = YES;
            };
        }
    }
    else
    {
        if (topRightBackGroundImageView.hidden)
        {
            Color4B nColor = currentScene.rightNavigationBarButtonColor;
            nColor.alpha = 0xbb;
            Color4B hColor = currentScene.rightNavigationBarButtonColor;
            hColor.alpha = 0xee;
            [topRightBackGroundImageView setImageColor:nColor];
            [topRightBackGroundImageView setImageHighlightColor:hColor];
            
            topRightBackGroundImageView.hidden = NO;
                        topRightBackGroundImageView.acceptsTouches = NO;
            EasingAnimation *easingAnimation = (EasingAnimation *)[topRightBackGroundImageView
                                                                   moveOriginFrom:topRightBackGroundImageView.originOfElement To:CGPointMake(0,-navigationBarButtonHeight)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                            topRightBackGroundImageView.acceptsTouches = YES;
            };
            
            button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
            [topRightBackGroundImageView removeElement:currentTopRightBarButton];
            currentTopRightBarButton = button;
            [topRightBackGroundImageView addElement:button];
        }
        else
        {
            Color4B nColor = currentScene.rightNavigationBarButtonColor;
            nColor.alpha = 0xbb;
            Color4B hColor = currentScene.rightNavigationBarButtonColor;
            hColor.alpha = 0xee;
            [topRightBackGroundImageView setImageHighlightColor:hColor];
            [topRightBackGroundImageView changeImageColorFrom:topRightBackGroundImageView.imageColor To:nColor withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
             topRightBackGroundImageView.acceptsTouches = NO;
            
            EasingAnimation *easingAnimation = (EasingAnimation *)[topRightBackGroundImageView
                                                                   moveOriginFrom:topRightBackGroundImageView.originOfElement To:CGPointMake(0,-navigationBarButtonHeight)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                topRightBackGroundImageView.acceptsTouches = YES;
            };
            
            
            if (button.buttonType != currentTopRightBarButton.buttonType)
            {
                topRightBackGroundImageView.acceptsTouches = NO;
                 button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
                [topRightBackGroundImageView addElement:button];
                button.clipToBounds = YES;
                currentTopRightBarButton.clipToBounds = YES;
                
                
                
                EasingAnimation *easingAnimation1 = (EasingAnimation *)[currentTopRightBarButton
                                                                        moveOriginInsideFrom:currentTopRightBarButton.originOfElement To:CGPointMake(0, -currentTopRightBarButton.frame.size.height)  withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
                easingAnimation1.easingType = EaseOut;
                easingAnimation1.animationEndedBlock = ^(Animation *animation)
                {
                    [topRightBackGroundImageView removeElement:currentTopRightBarButton];
                    currentTopRightBarButton.originInsideElement = CGPointMake(0, 0);
                    currentTopRightBarButton = button;
                };

                button.originInsideElement = CGPointMake(0, button.frame.size.height);
                EasingAnimation *easingAnimation2 = (EasingAnimation *)[button
                                                                       moveOriginInsideFrom:CGPointMake(0, button.frame.size.height)
                                                                        To:CGPointMake(0, 0)  withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
                easingAnimation2.easingType = EaseOut;
                easingAnimation2.animationEndedBlock = ^(Animation *animation)
                {
                    button.originInsideElement = CGPointMake(0, 0);
                     button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
                };
            }
            else
            {
                [topRightBackGroundImageView removeElement:currentTopRightBarButton];
                currentTopRightBarButton = button;
                button.frame = CGRectMake((navigationBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (navigationBarButtonHeight-button.frame.size.height)/2 + navBarBorderWidth/2 , button.frame.size.width, button.frame.size.height);
                [topRightBackGroundImageView addElement:button];
            }
        }
    }
}


-(void)setBottomRightBarButton:(NavigationButton *)button
{
    button.acceptsTouches = NO;
    [button setBackgroundColor:Color4BFromHex(0x000000)];
    [button setBackgroundHightlightColor:Color4BFromHex(0x000000)];
    [button setImageHighlightColor:Color4BFromHex(0xffffffff)];
    
    if (button == nil)
    {
        if (!bottomRightBackGroundImageView.hidden)
        {
            bottomRightBackGroundImageView.acceptsTouches = NO;
            EasingAnimation *easingAnimation = (EasingAnimation *)[bottomRightBackGroundImageView
                                                                   moveOriginFrom:bottomRightBackGroundImageView.originOfElement To:CGPointMake(0, 0)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                bottomRightBackGroundImageView.hidden = YES;
                bottomRightBackGroundImageView.acceptsTouches = YES;
            };
        }
    }
    else
    {
        if (bottomRightBackGroundImageView.hidden)
        {
            Color4B nColor = currentScene.actionBarButtonColor;
            nColor.alpha = 0xbb;
            Color4B hColor = currentScene.actionBarButtonColor;
            hColor.alpha = 0xee;
            [bottomRightBackGroundImageView setImageHighlightColor:hColor];
            [bottomRightBackGroundImageView setImageColor:nColor];
            
            bottomRightBackGroundImageView.hidden = NO;
            bottomRightBackGroundImageView.acceptsTouches = NO;
            
            EasingAnimation *easingAnimation = (EasingAnimation *)[bottomRightBackGroundImageView
                                                                   moveOriginFrom:bottomRightBackGroundImageView.originOfElement To:CGPointMake(0, actionBarButtonHeight)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                bottomRightBackGroundImageView.acceptsTouches = YES;
            };
            
            button.frame = CGRectMake((actionBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (actionBarButtonHeight-button.frame.size.height)/2 - navBarBorderWidth/2, button.frame.size.width, button.frame.size.height);
            [bottomRightBackGroundImageView removeElement:currentTopRightBarButton];
            currentBottomRightBarButton = button;
            [bottomRightBackGroundImageView addElement:button];
        }
        else
        {
            Color4B nColor = currentScene.actionBarButtonColor;
            nColor.alpha = 0xbb;
            Color4B hColor = currentScene.actionBarButtonColor;
            hColor.alpha = 0xee;
            [bottomRightBackGroundImageView setImageHighlightColor:hColor];
            [bottomRightBackGroundImageView changeImageColorFrom:bottomRightBackGroundImageView.imageColor To:nColor withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
            bottomRightBackGroundImageView.acceptsTouches = NO;
            
            EasingAnimation *easingAnimation = (EasingAnimation *)[bottomRightBackGroundImageView
                                                                   moveOriginFrom:bottomRightBackGroundImageView.originOfElement To:CGPointMake(0, actionBarButtonHeight)                      withDuration:0.6 afterDelay:0 usingCurve:EasingOrdered];
            easingAnimation.easingType = EaseOut;
            easingAnimation.animationEndedBlock = ^(Animation *animation)
            {
                bottomRightBackGroundImageView.acceptsTouches = YES;
            };
            
            
            if (button.buttonType != currentBottomRightBarButton.buttonType)
            {
                bottomRightBackGroundImageView.acceptsTouches = NO;
                button.frame = CGRectMake((actionBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (actionBarButtonHeight-button.frame.size.height)/2 - navBarBorderWidth/2, button.frame.size.width, button.frame.size.height);
                [bottomRightBackGroundImageView addElement:button];
                button.clipToBounds = YES;
                currentBottomRightBarButton.clipToBounds = YES;
              
                EasingAnimation *easingAnimation1 = (EasingAnimation *)[currentBottomRightBarButton
                                                                        moveOriginInsideFrom:currentBottomRightBarButton.originOfElement To:CGPointMake(0, -currentBottomRightBarButton.frame.size.height)  withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
                easingAnimation1.easingType = EaseOut;
                easingAnimation1.animationEndedBlock = ^(Animation *animation)
                {
                    [bottomRightBackGroundImageView removeElement:currentBottomRightBarButton];
                    currentBottomRightBarButton.originInsideElement = CGPointMake(0, 0);
                    currentBottomRightBarButton = button;
                };
                
                button.originInsideElement = CGPointMake(0, button.frame.size.height);
                EasingAnimation *easingAnimation2 = (EasingAnimation *)[button
                                                                        moveOriginInsideFrom:CGPointMake(0, button.frame.size.height)
                                                                        To:CGPointMake(0, 0)  withDuration:0.3 afterDelay:0.2 usingCurve:EasingOrdered];
                easingAnimation2.easingType = EaseOut;
                easingAnimation2.animationEndedBlock = ^(Animation *animation)
                {
                    button.originInsideElement = CGPointMake(0, 0);
                    button.frame = CGRectMake((actionBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (actionBarButtonHeight-button.frame.size.height)/2 - navBarBorderWidth/2, button.frame.size.width, button.frame.size.height);
                };
            }
            else
            {
                [bottomRightBackGroundImageView removeElement:currentBottomRightBarButton];
                currentBottomRightBarButton = button;
                button.frame = CGRectMake((actionBarButtonWidth-button.frame.size.width)/2 + navBarBorderWidth/2, (actionBarButtonHeight-button.frame.size.height)/2 - navBarBorderWidth/2, button.frame.size.width, button.frame.size.height);
                [bottomRightBackGroundImageView addElement:button];
            }
        }
    }
}



@end
