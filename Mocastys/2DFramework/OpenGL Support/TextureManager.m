//
//  TextureManager.m
//  MusiMusi
//
//  Created by Rakesh BS on 9/4/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import "TextureManager.h"

@interface TextureManager (Private)
-(Texture2D *)loadTexture:(NSString *)texture_name;
@end


@implementation TextureManager

+(TextureManager *)sharedTextureManager
{
	static TextureManager *sharedInstance;
	
	@synchronized(self)
	{
		if (!sharedInstance)
		{
			sharedInstance = [[TextureManager alloc]init];
		}
	}
	return sharedInstance;
}

-(id)init
{
	if (self = [super init])
	{
		texture_dictionary = [[NSMutableDictionary alloc]init];
	}
	return self;
}

-(Texture2D *)loadTexture:(NSString *)texture_name
{
	NSString *imgPath = [[NSBundle mainBundle]resourcePath];
	imgPath = [imgPath stringByAppendingFormat:@"/%@",texture_name];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL exists = [fileManager isReadableFileAtPath:imgPath];
    
	if (exists)
	{
        UIImage *img = [UIImage imageNamed:texture_name];
		return [[Texture2D alloc]initWithImage:img];
	}
	return nil;
}

-(Texture2D *)getStringTexture:(NSString *)string dimensions:(CGSize)cgSize
           horizontalAlignment:(UITextAlignment)alignment verticalAlignment:(UITextVerticalAlignment)vAlignment
					  fontName:(NSString *)font
					  fontSize:(int)size
{
    NSString *key = [NSString stringWithFormat:@"%@%d%@%d%f%f",string,size,font,alignment,cgSize.width,cgSize.height];
    
	if ([texture_dictionary objectForKey:key] != nil)
	{
		return (Texture2D *)[texture_dictionary objectForKey:key];
	}
	else
	{
		Texture2D *tex = [[Texture2D alloc]initWithString:string
											   dimensions:cgSize
                                      horizontalAlignment:alignment verticalAlignment:vAlignment
												 fontName:font
												 fontSize:size];
		
		if (tex != nil)
		{
			[texture_dictionary setObject:tex forKey:key];
            tex.wasCachedInTextureManager = YES;
            [tex release];
			return tex;
		}
	}
	return nil;
}


-(Texture2D *)getStringTexture:(NSString *)texture_name
{
	if ([texture_dictionary objectForKey:texture_name] != nil)
	{
		return (Texture2D *)[texture_dictionary objectForKey:texture_name];
	}
	else
	{
		Texture2D *tex = [[Texture2D alloc]initWithString:texture_name
											   dimensions:CGSizeMake(200,30)
                                      horizontalAlignment:UITextAlignmentCenter verticalAlignment:UITextAlignmentMiddle
												 fontName:@"Arial-BoldMT"
												 fontSize:16];
        
		if (tex != nil)
		{
			[texture_dictionary setObject:tex forKey:texture_name];
            tex.wasCachedInTextureManager = YES;
            [tex release];
			return tex;
		}
	}
	return nil;
}


-(Texture2D *)getTextureWithName:(NSString *)texture_name OfType:(NSString *)type
{
	if ([texture_dictionary objectForKey:texture_name] != nil)
	{
		return (Texture2D *)[texture_dictionary objectForKey:texture_name];
	}
	else
	{
		NSString *filename = [NSString stringWithFormat:@"%@",texture_name];
        if ([UIScreen mainScreen].scale > 1.0)
        {
            filename = [NSString stringWithFormat:@"%@%@",filename,@"@2x"];
        }

        Texture2D *tex = [self loadTexture:[NSString stringWithFormat:@"%@.%@",filename,type]];
        if (tex != nil)
        {
            [texture_dictionary setObject:tex forKey:texture_name];
            tex.wasCachedInTextureManager = YES;
            [tex release];
            return tex;
		}
	}
	return nil;
}

-(FontSpriteSheet *)getFontSpriteSheetOfFontName:(NSString *)fontName andSize:(CGFloat)size andType:(int)fontSpriteType
{
    NSString *key = [NSString stringWithFormat:@"%@%f%d",fontName,size,fontSpriteType];
    
    if ([texture_dictionary objectForKey:key] == nil)
    {
        FontSpriteSheet *spriteSheet = [[FontSpriteSheet alloc]initWithType:fontSpriteType andFontName:fontName andFontSize:size];
        [texture_dictionary setObject:spriteSheet forKey:key];
        spriteSheet.wasCachedInTextureManager = YES;
        [spriteSheet release];

    }
    return texture_dictionary[key];    
}

-(void)delete_Texture:(NSString *)texture_name
{
	[texture_dictionary removeObjectForKey:texture_name];
}

@end
