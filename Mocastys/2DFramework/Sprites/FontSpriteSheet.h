//
//  SpriteSheet.h
//  GameDemo
//
//  Created by Rakesh BS on 11/9/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteSheet.h"

typedef enum
{
    FontSpriteTypeAlphabetsUppercase = 0,
    FontSpriteTypeAlphabetsLowerCase,
    FontSpriteTypeNumbers,
        FontSpriteTypeNumbersAndAlphabets
}FontSpriteType;


@interface FontSpriteSheet : SpriteSheet
{

}

@property (nonatomic,retain) NSString *fontName;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) FontSpriteType fontSpriteType;

-(id)initWithType:(FontSpriteType)type andFontName:(NSString *)fontName andFontSize:(CGFloat)fontSize;
@end