//
//  NSArray+Additions.m
//  Dabble
//
//  Created by Rakesh on 27/03/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSMutableArray (Additions)

-(int)indexOfString:(NSString *)searchString
{
    if (self.count<=0)
        return -1;
    if (![self[0] isKindOfClass:[NSString class]])
    {
        return -1;
    }
    int index = 0;
    for (NSString *obj in self)
    {
        if ([obj isEqualToString:searchString])
        {
            return index;
        }
        index++;
    }
    return -1;
}


@end

@implementation NSArray (Additions)

-(int)indexOfString:(NSString *)searchString
{
    if (self.count<=0)
        return -1;
    if ([self[0] class] != [NSString class])
    {
        return -1;
    }
    int index = 0;
    for (NSString *obj in self)
    {

        if ([obj isEqualToString:searchString])
        {
            return index;
        }
        index++;
    }
    return -1;
}

@end

