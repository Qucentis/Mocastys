//
//  SpriteSheet.m
//  GameDemo
//
//  Created by Rakesh BS on 11/9/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import "FontSpriteSheet.h"
#import "Texture2D.h"

static NSString *fontCharactersUpper = @"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
static NSString *fontCharactersLower = @"a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,v,z";
static NSString *fontCharactersNumbers = @"0,1,2,3,4,5,6,7,8,9";
static NSString *fontCharactersNumbersAndAlphabets = @"0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,v,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";

@implementation FontSpriteSheet

-(void)calculateFontSpriteSheetWith:(NSString *)fontString
{
    NSArray *characterArray = [fontString componentsSeparatedByString:@","];
    
    UIFont *font = [UIFont fontWithName:self.fontName
                                   size:self.fontSize*[[UIScreen mainScreen]scale]];
    
    
    CGFloat area = 0;
    
    for (int i = 0;i<characterArray.count;i++)
    {
        CGSize dimensions = [characterArray[i] sizeWithFont:font];
        area += dimensions.height * dimensions.width;
    }
    
    CGFloat squareSide = ceilf(sqrtf(area));
    
    int col = 0;
    int row = 0;
    CGFloat lineHeight = 0,lineWidth = 0,totalHeight = 0,totalWidth = 0;
    
    for (int i = 0;i<characterArray.count;i++)
    {
        CGSize dimensions = [characterArray[i] sizeWithFont:font];
        
        lineWidth += (dimensions.width+2);
        lineHeight = (lineHeight < dimensions.height) ? dimensions.height:lineHeight;
        
        col++;
        if (lineWidth >= squareSide || i == characterArray.count - 1)
        {
            
            totalWidth = (totalWidth < lineWidth) ? lineWidth:totalWidth;
            totalHeight += lineHeight;
            col = 0;
            lineWidth = 0;
            row++;
        }
    }
    
    NSUInteger				width,
    height,
    i;
	CGContextRef			context;
	void*					data;
	CGColorSpaceRef			colorSpace;
    
    width = totalWidth;
	if((width != 1) && (width & (width - 1))) {
		i = 1;
		while(i < width)
            i *= 2;
		width = i;
	}
	height = totalHeight;
	if((height != 1) && (height & (height - 1))) {
		i = 1;
		while(i < height)
            i *= 2;
		height = i;
	}
    
    
	colorSpace = CGColorSpaceCreateDeviceGray();
	data = calloc(height, width );
	context = CGBitmapContextCreateWithData(data, width, height, 8, width ,
                                            colorSpace, (CGBitmapInfo)kCGImageAlphaNone,nil,nil);
	CGColorSpaceRelease(colorSpace);
	CGContextSetGrayFillColor(context, 1.0, 1.0);
    
    
    CGContextTranslateCTM(context, 0.0, height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    lineHeight = 0,lineWidth = 0,totalHeight = 0,totalWidth = 0,col = 0;
    
    Sprite *fontSprite = nil;
    UIGraphicsPushContext(context);
    
    
	for (int i = 0;i<characterArray.count;i++)
    {
        CGSize dimensions = [characterArray[i] sizeWithFont:font];
        
        
        CGContextTranslateCTM(context, lineWidth, totalHeight);
        [characterArray[i] drawInRect:CGRectMake(0, 0, dimensions.width, dimensions.height) withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        CGContextTranslateCTM(context, -lineWidth, -totalHeight);
        
        fontSprite = [[Sprite alloc]init];
        fontSprite.offSetX = lineWidth;
        fontSprite.offSetY = totalHeight;
        fontSprite.width = dimensions.width;
        fontSprite.height = dimensions.height;
        fontSprite.key = characterArray[i];
        fontSprite.spriteSheet = self;
        [self addSprite:fontSprite];
        [fontSprite release];
        
        lineWidth += (dimensions.width+2);
        lineHeight = (lineHeight < dimensions.height) ? dimensions.height:lineHeight;
        
        col++;
        if (lineWidth >= squareSide || i == characterArray.count - 1)
        {
            totalWidth = (totalWidth < lineWidth) ? lineWidth:totalWidth;
            totalHeight += lineHeight;
            col = 0;
            lineWidth = 0;
            row++;
        }
        
        
    }
    
    /*CGImageRef imageRef = CGBitmapContextCreateImage(context);
     UIImage* image = [[UIImage alloc] initWithCGImage:imageRef];
     
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
     NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",self.hash]]; //Add the file name
     [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]; //Write the file
     */
    
    self = [self initWithData:data pixelFormat:kTexture2DPixelFormat_A8 pixelsWide:width pixelsHigh:height contentSize:CGSizeMake(totalWidth, totalHeight)];
	
	CGContextRelease(context);
	free(data);
    
	
    [self calculateCoordinates];
    
}


-(id)initWithType:(FontSpriteType)fontSpriteType andFontName:(NSString *)fontName andFontSize:(CGFloat)fontSize
{
    if (self = [super init])
    {
        self.fontSpriteType = fontSpriteType;
        self.fontName = fontName;
        self.fontSize = fontSize;
        
        switch (fontSpriteType) {
            case FontSpriteTypeAlphabetsUppercase:
                [self calculateFontSpriteSheetWith:fontCharactersUpper];
                break;
            case FontSpriteTypeAlphabetsLowerCase:
                [self calculateFontSpriteSheetWith:fontCharactersLower];
                break;
            case FontSpriteTypeNumbers:
                [self calculateFontSpriteSheetWith:fontCharactersNumbers];
                break;
            default:
                [self calculateFontSpriteSheetWith:fontCharactersNumbersAndAlphabets];
                break;
        }
    }
    return self;
}

-(void)dealloc
{
    self.fontName = nil;
    [super dealloc];
}




@end
