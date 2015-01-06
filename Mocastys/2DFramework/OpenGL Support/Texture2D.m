/*
 
 File: Texture2D.m
 Abstract: Creates OpenGL 2D textures from images or text.
 
 Version: 1.7
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2008 Apple Inc. All Rights Reserved.
 
 */

#import <OpenGLES/ES1/glext.h>
#import "GLCommon.h"
#import "Texture2D.h"



//CONSTANTS:

#define kMaxTextureSize	 1024

//CLASS IMPLEMENTATIONS:

@implementation Texture2D

@synthesize contentSize=_size, pixelFormat=_format, pixelsWide=_width, pixelsHigh=_height, name=_name, maxS=_maxS, maxT=_maxT;


//------------------------------------------------------------------------------
// BEGIN CHANGES - From here to END CHANGES are not part of the original
//				   Apple sample code, modification made as allowed by license
//				   JDL - August 1, 2008 JDL
//
// This code is necessary if this class is being used in a program that has
// drawing done both with and without textures. This code needs tog get called
// once before any texture is drawn, but if you attempt to draw without a
// texture after these have been called and before any drawing with a texture
// happens, it crashes.
//------------------------------------------------------------------------------
+ (void) initialize {
	
	// These calls need to get called once for the class to work, but if they are called before OpenGL knows about any textures, it crashes,
    //	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
    //  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
}
//------------------------------------------------------------------------------
// END CHANGES
//------------------------------------------------------------------------------


+(Texture2D *)getTextureWithName:(NSString *)texture_name OfType:(NSString *)type
{
    NSString *filename = [NSString stringWithFormat:@"%@",texture_name];
    if ([UIScreen mainScreen].scale > 1.0)
    {
        filename = [NSString stringWithFormat:@"%@%@",filename,@"@2x"];
    }
    
    Texture2D *tex = [Texture2D getTexture:[NSString stringWithFormat:@"%@.%@",filename,type]];
    tex.wasCachedInTextureManager = NO;
    return tex;
	
}

+(Texture2D *)getTexture:(NSString *)texture_name
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

static int texturecount = 0;

- (id) initWithData:(const void*)data pixelFormat:(Texture2DPixelFormat)pixelFormat pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size
{
    texturecount ++;
	GLint					saveName;
	if((self = [super init])) {
		glGenTextures(1, &_name);
		
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		switch(pixelFormat) {
                
			case kTexture2DPixelFormat_RGBA8888:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
				break;
			case kTexture2DPixelFormat_RGB565:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, data);
				break;
			case kTexture2DPixelFormat_A8:
				glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, data);
				break;
			default:
				[NSException raise:NSInternalInconsistencyException format:@""];
                
		}
		glBindTexture(GL_TEXTURE_2D, saveName);
        
		_size = size;
		_width = width;
		_height = height;
		_format = pixelFormat;
		_maxS = size.width / (float)width;
		_maxT = size.height / (float)height;
        self.wasCachedInTextureManager = NO;
	}
	return self;
}

-(void)generateMipMap
{
    [self bindTexture];
    glGenerateMipmapOES(GL_TEXTURE_2D);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
}

- (void) dealloc
{
	if(_name)
        glDeleteTextures(1, &_name);
    if (textureCoordinates != nil)
        free(textureCoordinates);
    if (textureVertices != nil)
        free(textureVertices);
    texturecount -- ;
  //  NSLog(@"deallocating texture %d",texturecount);
    
	[super dealloc];
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %8@ | Name = %i | Dimensions = %ix%i | Coordinates = (%.2f, %.2f)>", [self class], self, _name, _width, _height, _maxS, _maxT];
}

@end

@implementation Texture2D (Image)

- (id) initWithImage:(UIImage *)uiImage
{
	NSUInteger				width,
    height,
    i;
	CGContextRef			context = nil;
	void*					data = nil;;
	CGColorSpaceRef			colorSpace;
	void*					tempData;
	unsigned int*			inPixel32;
	unsigned short*			outPixel16;
	BOOL					hasAlpha;
	CGImageAlphaInfo		info;
	CGAffineTransform		transform;
	CGSize					imageSize;
	Texture2DPixelFormat    pixelFormat;
	CGImageRef				image;
	UIImageOrientation		orientation;
	BOOL					sizeToFit = NO;
	
	
	image = [uiImage CGImage];
	orientation = [uiImage imageOrientation];
	
	if(image == NULL) {
		[self release];
		NSLog(@"Image is Null");
		return nil;
	}
	
    
	info = CGImageGetAlphaInfo(image);
	hasAlpha = ((info == kCGImageAlphaPremultipliedLast) || (info == kCGImageAlphaPremultipliedFirst) || (info == kCGImageAlphaLast) || (info == kCGImageAlphaFirst) ? YES : NO);
	if(CGImageGetColorSpace(image)) {
		if(hasAlpha)
			pixelFormat = kTexture2DPixelFormat_RGBA8888;
		else
			pixelFormat = kTexture2DPixelFormat_RGB565;
	} else  //NOTE: No colorspace means a mask image
		pixelFormat = kTexture2DPixelFormat_A8;
	
	
	imageSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
	transform = CGAffineTransformIdentity;
    
	width = imageSize.width;
	
	if((width != 1) && (width & (width - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < width)
			i *= 2;
		width = i;
	}
	height = imageSize.height;
	if((height != 1) && (height & (height - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < height)
			i *= 2;
		height = i;
	}
	while((width > kMaxTextureSize) || (height > kMaxTextureSize)) {
		width /= 2;
		height /= 2;
		transform = CGAffineTransformScale(transform, 0.5, 0.5);
		imageSize.width *= 0.5;
		imageSize.height *= 0.5;
	}
	
	switch(pixelFormat) {
		case kTexture2DPixelFormat_RGBA8888:
			colorSpace = CGColorSpaceCreateDeviceRGB();
			data = malloc(height * width * 4);
			context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
			CGColorSpaceRelease(colorSpace);
			break;
		case kTexture2DPixelFormat_RGB565:
			colorSpace = CGColorSpaceCreateDeviceRGB();
			data = malloc(height * width * 4);
			context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
			CGColorSpaceRelease(colorSpace);
			break;
			
		case kTexture2DPixelFormat_A8:
			data = malloc(height * width);
			context = CGBitmapContextCreate(data, width, height, 8, width, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid pixel format"];
	}
    
    
	CGContextClearRect(context, CGRectMake(0, 0, width, height));
	CGContextTranslateCTM(context, 0, height - imageSize.height);
	
	if(!CGAffineTransformIsIdentity(transform))
		CGContextConcatCTM(context, transform);
	CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
	//Convert "RRRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA" to "RRRRRGGGGGGBBBBB"
	if(pixelFormat == kTexture2DPixelFormat_RGB565) {
		tempData = malloc(height * width * 2);
		inPixel32 = (unsigned int*)data;
		outPixel16 = (unsigned short*)tempData;
		for(i = 0; i < width * height; ++i, ++inPixel32)
			*outPixel16++ = ((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) | ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) | ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0);
		free(data);
		data = tempData;
		
	}
	self = [self initWithData:data pixelFormat:pixelFormat pixelsWide:width pixelsHigh:height contentSize:imageSize];
	
	CGContextRelease(context);
	free(data);
	
	return self;
}

@end

@implementation Texture2D (Text)

- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions horizontalAlignment:(UITextAlignment)alignment verticalAlignment:(UITextVerticalAlignment)vertAlignment fontName:(NSString*)name fontSize:(CGFloat)size
{
	NSUInteger				width,
    height,
    i;
	CGContextRef			context;
	void*					data;
	CGColorSpaceRef			colorSpace;
	UIFont *				font;
	
    if ([[UIScreen mainScreen]scale] > 1.0)
    {
        size *=2;
        dimensions = CGSizeMake(dimensions.width*2, dimensions.height*2);
    }
    
    
	font = [UIFont fontWithName:name size:size];
	
	width = dimensions.width;
	if((width != 1) && (width & (width - 1))) {
		i = 1;
		while(i < width)
            i *= 2;
		width = i;
	}
	height = dimensions.height;
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
    //    CGContextSetShouldSmoothFonts(context, YES);
    CGContextTranslateCTM(context, 0.0, height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    UIGraphicsPushContext(context);
    
    CGSize fsize = [string sizeWithFont:font constrainedToSize:dimensions lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat offsetY = 0;
    if (vertAlignment == UITextAlignmentCenter)
        offsetY = (dimensions.height-fsize.height)/2;
    else if (vertAlignment == UITextAlignmentBottom)
        offsetY = (dimensions.height-fsize.height);
    
    //    [string drawInRect:CGRectMake(0, offsetY, dimensions.width, fsize.height) withFont:font];
    
    [string drawInRect:CGRectMake(0, offsetY, dimensions.width, fsize.height) withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:(NSTextAlignment)alignment];
	UIGraphicsPopContext();
    
	
	self = [self initWithData:data pixelFormat:kTexture2DPixelFormat_A8 pixelsWide:width pixelsHigh:height contentSize:dimensions];
	
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage* image = [[UIImage alloc] initWithCGImage:imageRef];
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",self.hash]]; //Add the file name
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]; //Write the file
    */
    
	CGContextRelease(context);
	free(data);
	
	return self;
}
@end


@implementation Texture2D (Drawing)

-(Vector3D *)getTextureVertices
{
    if (textureVertices == nil)
    {
        textureVertices = malloc(sizeof(Vector3D)*6);
        
        GLfloat	width = (GLfloat)_width * _maxS,
        height = (GLfloat)_height * _maxT;
        
        CGFloat scale = [[UIScreen mainScreen]scale];
        
        textureVertices[0] = (Vector3D) {.x = -width / (2*scale) , .y = -height / (2*scale), .z = 0.0};
        textureVertices[1] = (Vector3D) {.x = width / (2*scale) , .y = -height / (2*scale),  .z = 0.0};
        textureVertices[2] = (Vector3D) {.x = width / (2*scale) , .y = height / (2*scale),	.z = 0.0};
        
        textureVertices[3] = (Vector3D) {.x = -width / (2*scale) , .y = -height / (2*scale), .z = 0.0};
        textureVertices[4] = (Vector3D) {.x = -width / (2*scale) , .y = height / (2*scale),	.z = 0.0};
        textureVertices[5] = (Vector3D) {.x = width / (2*scale) , .y = height / (2*scale),	.z = 0.0};
    }
    return textureVertices;
}

-(TextureCoord *)getTextureCoordinates
{
    if (textureCoordinates == nil)
    {
        textureCoordinates = malloc(sizeof(TextureCoord)*6);
        textureCoordinates[0] = (TextureCoord) { .s = 0, .t = _maxT};
        textureCoordinates[1] = (TextureCoord) { .s = _maxS, .t =_maxT};
        textureCoordinates[2] = (TextureCoord) { .s = _maxS, .t = 0};
        
        textureCoordinates[3] = (TextureCoord) { .s = 0, .t = _maxT};
        textureCoordinates[4] = (TextureCoord) { .s = 0, .t = 0};
        textureCoordinates[5] = (TextureCoord) { .s = _maxS, .t = 0};
    }
    return textureCoordinates;
}

-(CGRect)getTextureCGRect
{
    
    GLfloat	width = (GLfloat)_width * _maxS,
    height = (GLfloat)_height * _maxT;
    
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    return CGRectMake(-width / (2*scale), -height/(2*scale), width/scale, height/scale);
}

-(CGRect)getTextureCoordinatesCGRect
{
    return CGRectMake(0, 0, _maxS, _maxT);
}

-(void)bindTexture
{
	glBindTexture(GL_TEXTURE_2D, _name);
}

@end
