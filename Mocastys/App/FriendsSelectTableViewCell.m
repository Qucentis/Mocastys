//
//  FriendsSelectTableViewCell.m
//  KBC
//
//  Created by Rakesh on 11/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "FriendsSelectTableViewCell.h"

@implementation FriendsSelectTableViewCell

@synthesize checkMark,photoView,nameLabel;

-(id)init
{
    if (self = [super init])
    {
        self.frameBackgroundColor = Color4BFromHex(0xffffff25);
        
        CGFloat midY = self.frame.size.height/2;
        
        nameLabel = [[GLLabel alloc]initWithFrame:CGRectMake(90, midY - 13, 150, 26)];
        [nameLabel setFont:@"Lato-Regular" withSize:15];
        [nameLabel setTextColor:(Color4B){0,0,0,255}];
        nameLabel.originInsideElement = CGPointMake(5, 0);
        [self addElement:nameLabel];
        [nameLabel release];
        
        checkMark = [[CheckMark alloc]initWithFrame:CGRectMake(0, 2, 40, 40)];
        [self addElement:checkMark];
        [checkMark release];
        
        photoView = [[GLImageView alloc]initWithFrame:CGRectMake(40, 2, 40, 40)];
        [self addElement:photoView];
        photoView.acceptsTouches = NO;
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
    
    nameLabel.frame = CGRectMake(90, midY - 13, 150, 26);
    photoView.frame = CGRectMake(40, 2, 40, 40);
    checkMark.frame = CGRectMake(0, 2, 40, 40);
    borderElement.frame = CGRectMake(0, 0, self.frame.size.width, 2);
    
}


@end
