//
//  Friends.h
//  KBC
//
//  Created by Rakesh on 15/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "Message.h"

@interface Friend : NSObject

@property (nonatomic) ABRecordID recordID;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *phoneNo;
@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic,retain) NSString *imagePath;
@property (nonatomic,retain) NSDate *lastMessageTime;
@property (nonatomic,retain) NSMutableDictionary *messagesByID;

-(void)addMessage:(Message *)m;

@end
