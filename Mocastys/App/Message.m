//
//  Message.m
//  KBC
//
//  Created by Rakesh on 15/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "Message.h"

@implementation Message

-(id)initWithCoder:(NSCoder *)decoder {
    if ((self=[super init]))
    {
        self.messageID = [decoder decodeObjectForKey:@"messageID"];
        self.duration = [decoder decodeInt32ForKey:@"duration"];
        self.timeSent = [decoder decodeObjectForKey:@"sentTime"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.timeOpened = [decoder decodeObjectForKey:@"timeOpened"];

    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.messageID forKey:@"messageID"];
    [encoder encodeObject:self.timeSent forKey:@"sentTime"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:self.timeOpened forKey:@"timeOpened"];
    [encoder encodeInt32: self.duration forKey:@"duration"];
}


-(NSString *)description
{
    return [NSString stringWithFormat: @"Id: %@ Message : %@ ",self.messageID,self.message];
}

@end
