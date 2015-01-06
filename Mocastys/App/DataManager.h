//
//  DataManager.h
//  KBC
//
//  Created by Rakesh on 15/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"
#import "Message.h"

@interface DataManager : NSObject
{
    NSMutableArray *friends;
    NSMutableArray *openedMessages;
    NSString *dataSavePath;
}

@property (nonatomic,retain) NSArray *selectedUsers;
@property (nonatomic,retain) NSString *replyUsername;
@property (nonatomic,retain) NSString *messageFromCompose;
@property (nonatomic) int durationFromCompose;
@property (nonatomic,retain) NSMutableArray *friends;
@property (nonatomic,readonly)     NSMutableArray *openedMessages;

+(DataManager *)sharedDataManager;
-(void)readDataForUser;
-(void)clearData;

-(void)addFriend:(Friend *)friend;
-(Friend *)findFriendWithUsername:(NSString *)username;
-(void)addMessage:(Message *)message ForUserName:(NSString *)username;
-(void)openMessage:(Message *)m;
-(void)deleteMessage:(Message *)m;
-(NSArray *)getFriendsWithMessages;
-(void)saveDataToArchive;

@end
