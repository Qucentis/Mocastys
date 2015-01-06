//
//  SpriteSheet.m
//  Dabble
//
//  Created by Rakesh on 28/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "SpriteSheet.h"

@implementation Sprite


-(void)calculateCoordinates
{
    if (_textureCoordinates !=nil)
        return;
    _textureCoordinates = malloc(sizeof(TextureCoord)*6);
    _textureRect = malloc(sizeof(Vector3D)*6);
    
    CGFloat totalWidth = self.spriteSheet.pixelsWide;
    CGFloat totalHeight = self.spriteSheet.pixelsHigh;
    
    _textureCoordinates[0] = (TextureCoord) { .s = (_offSetX/totalWidth), .t = ((_offSetY+_height)/totalHeight)};
    _textureCoordinates[1] = (TextureCoord)
    {.s = ( (_offSetX+_width)/totalWidth), .t = ((_offSetY+_height)/totalHeight)};
    
    _textureCoordinates[2] = (TextureCoord)
    {.s = ( (_offSetX+_width)/totalWidth), .t = (_offSetY/totalHeight)};
    
    _textureCoordinates[3] = (TextureCoord) { .s = (_offSetX/totalWidth), .t = ((_offSetY+_height)/totalHeight)};
    _textureCoordinates[4] = (TextureCoord) { .s = (_offSetX/totalWidth), .t = (_offSetY/totalHeight)};
    _textureCoordinates[5] = (TextureCoord)
    {.s = ( (_offSetX+_width)/totalWidth), .t = (_offSetY/totalHeight)};
    
    self.textureCoordinatesCGRect = CGRectMake(_offSetX/totalWidth, _offSetY/totalHeight, _width/totalWidth, _height/totalHeight);
    
    
    CGFloat scale = [[UIScreen mainScreen]scale]*2;
    
    _textureRect[0] = (Vector3D) { .x = -_width/scale, .y = -_height/scale, .z = 0.0};
    _textureRect[1] = (Vector3D) { .x = _width/scale, .y = -_height/scale, .z = 0.0};
    _textureRect[2] = (Vector3D) { .x = _width/scale, .y = _height/scale, .z = 0.0};
    
    _textureRect[3] = (Vector3D) { .x = -_width/scale, .y =   -_height/scale, .z = 0.0};
    _textureRect[4] = (Vector3D) { .x = -_width/scale, .y = _height/scale, .z = 0.0};
    _textureRect[5] = (Vector3D) { .x = _width/scale, .y = _height/scale, .z = 0.0};
    
    self.textureCGRect = CGRectMake(-_width/scale, -_height/scale, 2*_width/scale , 2 * _height/scale);
    
}


@end

@interface SpriteSheet (Private)

@end

@implementation SpriteSheet

@synthesize spriteDictionary;

-(id)init
{
    if (self = [super init])
    {
        spriteDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)calculateCoordinates
{
    for (Sprite *s in spriteDictionary.objectEnumerator)
        [s calculateCoordinates];
}

-(Sprite *)getSpriteFromKey:(NSString *)key
{
    return (Sprite *)spriteDictionary[key];
}

-(void)addSprite:(Sprite *)sprite
{
    [spriteDictionary setObject:sprite forKey:sprite.key];
}

-(void)dealloc
{
    [spriteDictionary release];
    [super dealloc];
}

@end
