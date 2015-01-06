//
//  DisclaimerScene.m
//  KBC
//
//  Created by Rakesh on 10/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "DisclaimerScene.h"
#import "GLVerticalScrollElement.h"
#import "AppDelegate.h"

@implementation DisclaimerScene

-(id)init
{
    if (self = [super init])
    {
        GLVerticalScrollElement *verticalScrollElement = [[GLVerticalScrollElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        verticalScrollElement.heightOfContent = 600;
        [self addElement:verticalScrollElement];
        [verticalScrollElement release];
        
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        backImageButton.buttonType = NavigationButtonTypeBack;
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            titleLabel = [[GLLabel alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 100, self.frame.size.width, 30)];
        
            disclaimerLabel = [[GLLabel alloc]initWithFrame:CGRectMake(15, -305, self.frame.size.width - 30, self.frame.size.height+200)];
                    [disclaimerLabel setFont:@"Lato-Regular" withSize:15];
                    [titleLabel setFont:@"Lato-Bold" withSize:20];
        }
        else
        {
            titleLabel = [[GLLabel alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 130, self.frame.size.width, 30)];
            
            disclaimerLabel = [[GLLabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height - 140)];
                    [disclaimerLabel setFont:@"Lato-Regular" withSize:20];
                    [titleLabel setFont:@"Lato-Bold" withSize:25];
        }


        [titleLabel setTextColor:Color4BFromHex(0x000000ff)];
        [titleLabel setText:@"Disclaimer" withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
        [verticalScrollElement addElement:titleLabel];
        [titleLabel release];
        
        NSString *text = @"This app is provided as is without any warranty whatsoever. This app is intended to be used for playful communication between friends.\n\This app is not intended for emergency communication.\n\nMessages are not stored or cached on our servers after they have been read by the recipients.\n\nWhile we strive to protect our users' privacy, we cannot guarantee a 100% fail-proof system.\n\nWe advice against using This app to communicate with strangers. We also advice against sharing personal information with strangers.\n\nAn updated version of this disclaimer can be found on our site.\n\nThis app is a proof of concept and as such is constantly evolving; features may be added or deleted in the future.";
        

        [disclaimerLabel setTextColor:Color4BFromHex(0x000000ff)];
        [disclaimerLabel setText:text withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentTop];
        [verticalScrollElement addElement:disclaimerLabel];
        [disclaimerLabel release];
        
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [verticalScrollElement addElement:logoImageView];
        [logoImageView release];
    }
    return self;
}

-(void)leftBarButtonClicked
{
    if (self.fromScene == 1)
        [self.appDelegate moveMainPage:4];
    else  if (self.fromScene == 2)
        [self.appDelegate moveRegisterPage:1];
    else if (self.fromScene == 3)
    [self.appDelegate moveMainPage:6];
}

@end
