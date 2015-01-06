//
//  DataManager.m
//  KBC
//
//  Created by Rakesh on 15/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

@synthesize friends,openedMessages;

+(DataManager *)sharedDataManager
{
    static DataManager *sharedInstance;
	
	@synchronized(self)
	{
		if (!sharedInstance)
		{
			sharedInstance = [[DataManager alloc]init];
		}
	}
	return sharedInstance;
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(id)init
{
    if (self = [super init])
    {
        openedMessages = [[NSMutableArray alloc]init];
        self.messageFromCompose = @"";
        
    }
    return self;
}

-(void)clearData
{
    if (dataSavePath != nil)
        [dataSavePath release];
    dataSavePath = nil;
    self.messageFromCompose = nil;
    self.friends = nil;
}

-(void)readDataForUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    
    if (userName != nil && dataSavePath == nil)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@.file",userName];
        
        dataSavePath = [[[self applicationDocumentsDirectory]
                         stringByAppendingPathComponent:fileName]retain];
        
    }
    
    [self readDataFromArchive];
    
    [openedMessages removeAllObjects];
    
    for (Friend *f in self.friends)
    {
        for (Message *m in f.messages)
        {
            m.owner = f;
            if (m.timeOpened != nil)
            {
                if (![openedMessages containsObject:m])
                {
                    [self openMessage:m];
                }
            }
        }
    }
    
    for (int i = 0;i < openedMessages.count;i++)
    {
        Message *m = openedMessages[i];
        int s = fabs([m.timeOpened timeIntervalSinceNow]);
        if (s >= m.duration)
        {
            [[DataManager sharedDataManager]deleteMessage:m];
            i--;
        }
    }

    
    if (friends == nil)
    {
        friends = [[NSMutableArray alloc]init];
        [self createFakeData];
    }
}

-(void)saveDataToArchive
{
    if (dataSavePath == nil)
    {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    
    if (userName != nil)
    {
        NSString *hashUsername = [NSString stringWithFormat:@"%d",[userName hash]];
        NSString *fileName = [NSString stringWithFormat:@"%@.file",hashUsername];
        
        dataSavePath = [[[self applicationDocumentsDirectory]
                         stringByAppendingPathComponent:fileName]retain];
    }
    }
    
    [NSKeyedArchiver archiveRootObject:friends toFile:dataSavePath];
}

-(void)readDataFromArchive
{
    self.friends = [NSKeyedUnarchiver unarchiveObjectWithFile:dataSavePath];
}

-(void)addFriend:(Friend *)friend
{
    NSUInteger newIndex = [friends indexOfObject:friend
                                 inSortedRange:(NSRange){0, [friends count]}
                                       options:NSBinarySearchingInsertionIndex
                               usingComparator:^NSComparisonResult(Friend *obj1, Friend *obj2) {
                                
                                   if (obj1.firstName == nil)
                                       obj1.firstName = @"";
                                   if (obj1.lastName == nil)
                                       obj1.lastName = @"";
                                   
                                   if (obj2.firstName == nil)
                                       obj2.firstName = @"";
                                   if (obj2.lastName == nil)
                                       obj2.lastName = @"";
                                   
                                   NSString *name1 = [NSString stringWithFormat:@"%@ %@ %@",obj1.firstName,obj1.lastName,obj1.username];
                                    NSString *name2 = [NSString stringWithFormat:@"%@ %@ %@",obj2.firstName,obj2.lastName,obj2.username];
                                   return [name1 compare:name2];
                               }];
    [friends insertObject:friend atIndex:newIndex];
}

-(Friend *)findFriendWithUsername:(NSString *)username
{
    for (Friend *friend in friends)
    {
        if ([username isEqualToString:friend.username])
            return friend;
    }
    return nil;
}

-(void)addMessage:(Message *)message ForUserName:(NSString *)username
{
    Friend *friend = [self findFriendWithUsername:username];
    [friend.messages addObject:message];
}

-(void)openMessage:(Message *)m
{
    for (Message *m1 in openedMessages)
    {
        if ([m.messageID isEqualToString:m1.messageID])
            return;
    }
    [openedMessages addObject:m];
}

-(void)deleteMessage:(Message *)m
{
    [m.owner.messagesByID removeObjectForKey:m.messageID];
    [m.owner.messages removeObject:m];
    [openedMessages removeObject:m];
}

-(NSArray *)getFriendsWithMessages
{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    for (Friend *friend in friends)
    {
        if (friend.messages.count > 0)
        {
            [returnArr addObject:friend];
        }
    }
    return returnArr;
}

-(void)createFakeData
{
 /*
    Friend *friend1 = [[Friend alloc]init];
    friend1.username = @"rakesh";
    friend1.email = @"rakeshbs@gmail.com";
    friend1.firstName = @"Rakesh";
    friend1.lastName = @"B S";
    [self addFriend:friend1];
    
    Friend *friend3 = [[Friend alloc]init];
    friend3.username = @"nikhil";
    friend3.email = @"x1101x@gmail.com";
    friend3.firstName = @"Nikhil";
    friend3.lastName = @"Mohan";
    [self addFriend:friend3];
  
    
    Friend *friend4 = [[Friend alloc]init];
    friend4.username = @"kande";
    friend4.email = @"kande@gmail.com";
    friend4.firstName = @"Kande-Bure";
    friend4.lastName = @"Kamara";
    [self addFriend:friend4];
    
    
    Friend *friend2 = [[Friend alloc]init];
    friend2.username = @"jikku";
    friend2.email = @"jikkujose@gmail.com";
    friend2.firstName = @"Jikku";
    friend2.lastName = @"Jose";
    [self addFriend:friend2];
    
  
    [self saveDataToArchive];*/
}

@end
