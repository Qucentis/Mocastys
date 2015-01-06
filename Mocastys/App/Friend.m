//
//  Friends.m
//  KBC
//
//  Created by Rakesh on 15/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(void)dealloc
{
    self.email = nil;
    self.phoneNo = nil;
    self.username = nil;
    self.lastName = nil;
    self.firstName = nil;
    self.messages = nil;
    self.lastMessageTime = nil;
    [super dealloc];
}


-(id)initWithCoder:(NSCoder *)decoder {
    if ((self=[super init]))
    {
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.phoneNo = [decoder decodeObjectForKey:@"phoneNo"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.recordID = [decoder decodeInt32ForKey:@"recordID"];
        self.messages = [decoder decodeObjectForKey:@"messages"];
        self.imagePath = [decoder decodeObjectForKey:@"imagePath"];
        self.lastMessageTime = [decoder decodeObjectForKey:@"lastMessageTime"];
        self.messagesByID = [decoder decodeObjectForKey:@"messagesByID"];
        for (Message *m in self.messages)
            m.owner = self;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.phoneNo forKey:@"phoneNo"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeInt32: self.recordID forKey:@"recordID"];
    [encoder encodeObject:self.messages forKey:@"messages"];
    [encoder encodeObject:self.imagePath forKey:@"imagePath"];
    [encoder encodeObject:self.lastMessageTime forKey:@"lastMessageTime"];
    [encoder encodeObject:self.messagesByID forKey:@"messagesByID"];
}

-(void)addMessage:(Message *)m
{
    if (self.messages == nil)
    {
        _messages = [[NSMutableArray alloc]init];
    }
    if (self.messagesByID == nil)
    {
        _messagesByID = [[NSMutableDictionary alloc]init];
    }
    [self.messages addObject:m];
    [_messagesByID setObject:m forKey:m.messageID];
    self.lastMessageTime = m.timeSent;
}

-(NSString *)description
{
    return [NSString stringWithFormat: @"FName : %@ LName : %@ Phone : %@ Email : %@",self.firstName,self.lastName,self.phoneNo,self.email];
}

@end
