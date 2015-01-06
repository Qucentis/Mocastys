//
//  Message.h
//  KBC
//
//  Created by Rakesh on 15/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Friend;

@interface Message : NSObject

@property (nonatomic) int duration;
@property (nonatomic,retain) NSString *messageID;
@property (nonatomic,retain) Friend *owner;
@property (nonatomic,retain) NSDate *timeSent;
@property (nonatomic,retain) NSString *message;
@property (nonatomic,retain) NSDate *timeOpened;


@end
