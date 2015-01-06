//
//  GLText.m
//  KBC
//
//  Created by Rakesh on 12/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLText.h"

@implementation GLText

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)setCharacterType:(FontSpriteType)spriteType
{
    fontSpriteSheetType = spriteType;
}

@end
