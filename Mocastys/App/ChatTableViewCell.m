//
//  ChatTableViewCell.m
//  KBC
//
//  Created by Rakesh on 10/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "AppTheme.h"

@implementation ChatTableViewCell

@synthesize lastNameLabel,photoView,dateLabel;

-(id)init
{
    if (self = [super init])
    {
     
        self.frameBackgroundColor = Color4BFromHex(0xffffff22);
        
        CGFloat midY = self.frame.size.height/2;
        
        dateLabel = [[GLLabel alloc]initWithFrame:CGRectMake(90, midY-27 , 300, 23)];
        [dateLabel setFont:@"Lato-Light" withSize:14];
        [dateLabel setTextColor:(Color4B){0,0,0,255}];
        dateLabel.originInsideElement = CGPointMake(5, 0);

       [self addElement:dateLabel];
        [dateLabel release];
        
        lastNameLabel = [[GLLabel alloc]initWithFrame:CGRectMake(90, midY-5 , 130, 36)];
        [lastNameLabel setFont:@"Lato-Regular" withSize:22];
        [lastNameLabel setTextColor:(Color4B){0,0,0,255}];
        lastNameLabel.originInsideElement = CGPointMake(5, 0);
        [self addElement:lastNameLabel];
        [lastNameLabel release];
        
        photoView = [[GLImageView alloc]initWithFrame:CGRectMake(0, 2, 80, 80)];
        photoView.acceptsTouches = NO;
        [self addElement:photoView];
        [photoView release];
        
        borderElement = [[GLElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        [self addElement:borderElement];
        [borderElement setFrameBackgroundColor:Color4BFromHex(0x00000055)];
        [borderElement release];
    }
    return self;
}


-(void)animate
{
    
}


-(void)setFrame:(CGRect)_frame
{
    [super setFrame:_frame];
    CGFloat midY = self.frame.size.height/2;
    
    lastNameLabel.frame = CGRectMake(90, midY-5 , 130, 36);
    dateLabel.frame = CGRectMake(90, midY-27 , 300, 23);
    photoView.frame = CGRectMake(0, 2, 80, 80);
     borderElement.frame = CGRectMake(0, 0, self.frame.size.width, 2);
}


@end
