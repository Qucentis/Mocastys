//
//  SpriteSheet.h
//  Dabble
//
//  Created by Rakesh on 28/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "Texture2D.h"

#define SPRITESHEET_TYPE_FONT 1
#define SPRITESHEET_TYPE_IMAGE 2
#define SPRITESHEET_TYPE_MIXED 3

#define SPRITE_TYPE_FONT 1
#define SPRITE_TYPE_IMAGE 2


@class Sprite;

@interface SpriteSheet : Texture2D
{
    NSMutableDictionary *spriteDictionary;
    int spriteSheetType;
}

@property (nonatomic,readonly) NSMutableDictionary *spriteDictionary;

-(void)addSprite:(Sprite *)sprite;
-(Sprite *)getSpriteFromKey:(NSString *)key;
-(void)calculateCoordinates;
@end

@interface Sprite : NSObject

@property (nonatomic) int spriteType;
@property (nonatomic) CGFloat offSetX;
@property (nonatomic) CGFloat offSetY;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGRect textureCGRect;
@property (nonatomic,retain) NSString *key;
@property (nonatomic) Vector3D *textureRect;
@property (nonatomic) TextureCoord *textureCoordinates;
@property (nonatomic) CGRect textureCoordinatesCGRect;
@property (nonatomic,retain) SpriteSheet *spriteSheet;

@end