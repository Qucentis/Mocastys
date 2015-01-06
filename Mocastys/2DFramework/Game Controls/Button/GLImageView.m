//
//  GLImageView.m
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLImageView.h"

#define ANIMATION_HIGHLIGHT 1
#define ANIMATION_NORMAL 2
#define ANIMATION_COLOR_CHANGE 3

@implementation GLImageView

-(id)init
{
    if (self = [super init])
    {
        imageColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        backgroundColor = (Color4B){.red = 0,.green = 0,.blue = 0,.alpha = 0};
        backgroundHightlightColor = imageColor;
        imageHighlightColor = backgroundColor;
        self.acceptsTouches = NO;
        
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"TextureShader"];
        
        textureVertexColorData = malloc(sizeof(TextureVertexColorData) * 6);
        _usesTextureManager = NO;
        self.blendModeSrc = GL_ONE;
        self.blendModeDest = GL_ONE_MINUS_SRC_ALPHA;
    }
    return self;
}

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        imageColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        backgroundColor = (Color4B){.red = 0,.green = 0,.blue = 0,.alpha = 0};
        backgroundHightlightColor = imageColor;
        imageHighlightColor = backgroundColor;
        
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"TextureShader"];
        
        textureVertexColorData = malloc(sizeof(TextureVertexColorData) * 6);
        
        _usesTextureManager = NO;
        self.blendModeSrc = GL_ONE;
        self.blendModeDest = GL_ONE_MINUS_SRC_ALPHA;
    }
    return self;
}

-(void)setTexture:(Texture2D *)texture
{
    if (buttonTexture != nil && !buttonTexture.wasCachedInTextureManager)
    {
        [buttonTexture release];
        buttonTexture = nil;
    }
    
    if (!buttonTexture.wasCachedInTextureManager)
        buttonTexture = [texture retain];
    else
        buttonTexture = texture;
    
    [self setUpUIImageView];
}

-(void)setImage:(NSString *)imageName ofType:(NSString *)type
{
    if (buttonTexture != nil && !buttonTexture.wasCachedInTextureManager)
    {
        [buttonTexture release];
        buttonTexture = nil;
    }
    
    if (_usesTextureManager)
        buttonTexture = [textureManager getTextureWithName:imageName OfType:type];
    else
    {
        buttonTexture = [Texture2D getTextureWithName:imageName OfType:type];
    }

    [buttonTexture generateMipMap];
    
    [self setUpUIImageView];
}

-(void)setImageWithPathAsync:(NSString *)imageName ofType:(NSString *)type
{
    if (buttonTexture != nil && !buttonTexture.wasCachedInTextureManager)
    {
        [buttonTexture release];
        buttonTexture = nil;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(startLoadingImageFromPath:) withObject:[NSArray arrayWithObjects:imageName,type,nil] afterDelay:0.1];
}


-(void)startLoadingImageFromPath:(NSArray *)data
{
    dispatch_async( dispatch_get_main_queue(), ^{
        UIImage *image;
        NSString *path;
        if ([UIScreen mainScreen].scale == 1.0)
            path = [NSString stringWithFormat:@"%@.%@",data[0],data[1]];
        else
            path = [NSString stringWithFormat:@"%@@2x.%@",data[0],data[1]];
        image = [UIImage imageWithContentsOfFile:path];
        [self loadTextureAsyncFromUIImage:[EAGLContext currentContext]:image];
        
    });
}

-(void)loadTextureAsyncFromUIImage:(EAGLContext *)context :(UIImage *)image
{
    [EAGLContext setCurrentContext: context];
    
    Texture2D *tex;
    
    tex = [[Texture2D alloc]initWithImage:image];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTexture:tex];
        if (!tex.wasCachedInTextureManager)
            [tex release];
    });
}

-(void)setImageAsync:(NSString *)imageName ofType:(NSString *)type
{
    if (buttonTexture != nil && !buttonTexture.wasCachedInTextureManager)
    {
        [buttonTexture release];
        buttonTexture = nil;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(startLoadingImage:) withObject:[NSArray arrayWithObjects:imageName,type,nil] afterDelay:0.1];
}

-(void)startLoadingImage:(NSArray *)data
{
    dispatch_async( dispatch_get_main_queue(), ^{
        [self loadTextureAsync:[EAGLContext currentContext]:data[0]:data[1]];
        
    });
}

-(void)loadTextureAsync:(EAGLContext *)context :(NSString *)imageName :(NSString *)type
{
    [EAGLContext setCurrentContext: context];
    
    Texture2D *tex;
    
    if (_usesTextureManager)
        tex = [textureManager getTextureWithName:imageName OfType:type];
    else
    {
        tex = [Texture2D getTextureWithName:imageName OfType:type];
    }
    

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTexture:tex];
        if (!tex.wasCachedInTextureManager)
            [tex release];
    });
}


-(void)setUIImage:(UIImage *)image
{
    if (buttonTexture != nil && !buttonTexture.wasCachedInTextureManager)
        [buttonTexture release];
    
    _usesTextureManager = NO;
    buttonTexture = [[Texture2D alloc]initWithImage:image];
    [buttonTexture generateMipMap];
   
    [self setUpUIImageView];
}

-(void)setUpUIImageView
{
    if (buttonTexture == nil)
        return;
    
    TextureCoord *texCoord = [buttonTexture getTextureCoordinates];
    Vertex3D *vertices = [buttonTexture getTextureVertices];
    
    for (int i = 0;i < 6;i++)
    {
        textureVertexColorData[i].vertex = vertices[i];
        textureVertexColorData[i].texCoord = texCoord[i];
        textureVertexColorData[i].color = imageColor;
    }
}

-(void)setHighlight:(BOOL)highlight InDuration:(CGFloat)duration afterDelay:(CGFloat)delay
{
     [animator removeRunningAnimationsForObject:self ofType:ANIMATION_NORMAL];
     [animator removeRunningAnimationsForObject:self ofType:ANIMATION_HIGHLIGHT];
     [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_NORMAL];
     [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_HIGHLIGHT];
     
     if (highlight)
     {
         Animation *animation  = [animator addCustomAnimationFor:self withIdentifier:ANIMATION_HIGHLIGHT withDuration:duration afterDelayInSeconds:delay];
         animation.animationUpdateBlock = ^(Animation *anim)
         {
             CGFloat animationRatio = [anim getAnimatedRatio];
             
             CGFloat red = getEaseOutQuad(backgroundColor.red, backgroundHightlightColor.red, animationRatio);
             CGFloat green = getEaseOutQuad(backgroundColor.green, backgroundHightlightColor.green, animationRatio);
             CGFloat blue = getEaseOutQuad(backgroundColor.blue, backgroundHightlightColor.blue, animationRatio);
             CGFloat alpha = getEaseOutQuad(backgroundColor.alpha, backgroundHightlightColor.alpha, animationRatio);
             
             
             
             CGFloat tred = getEaseOutQuad(imageColor.red, imageHighlightColor.red, animationRatio);
             CGFloat tgreen = getEaseOutQuad(imageColor.green, imageHighlightColor.green, animationRatio);
             CGFloat tblue = getEaseOutQuad(imageColor.blue, imageHighlightColor.blue, animationRatio);
             CGFloat talpha = getEaseOutQuad(imageColor.alpha, imageHighlightColor.alpha, animationRatio);
             
             
             Color4B intermediate = (Color4B){.red = red, .green = green, .blue = blue,.alpha =  alpha};
             Color4B tintermediate = (Color4B){.red = tred, .green = tgreen, .blue = tblue,.alpha = talpha};
             
             for (int i = 0;i < 6;i++)
             {
                 textureVertexColorData[i].color = tintermediate;
                 
             }
             [self setFrameBackgroundColor:intermediate];
             return NO;
         };
         
     }
     else
     {
         Animation *animation  = [animator addCustomAnimationFor:self withIdentifier:ANIMATION_NORMAL withDuration:duration afterDelayInSeconds:delay];
         
         animation.animationUpdateBlock = ^(Animation *anim)
         {
             CGFloat animationRatio = [anim getAnimatedRatio];
             
             
             CGFloat red = getEaseOutQuad(backgroundHightlightColor.red, backgroundColor.red, animationRatio);
             CGFloat green = getEaseOutQuad(backgroundHightlightColor.green, backgroundColor.green, animationRatio);
             CGFloat blue = getEaseOutQuad(backgroundHightlightColor.blue, backgroundColor.blue, animationRatio);
             CGFloat alpha = getEaseOutQuad(backgroundHightlightColor.alpha, backgroundColor.alpha, animationRatio);
             
             CGFloat tred = getEaseOutQuad(imageHighlightColor.red, imageColor.red, animationRatio);
             CGFloat tgreen = getEaseOutQuad(imageHighlightColor.green, imageColor.green, animationRatio);
             CGFloat tblue = getEaseOutQuad(imageHighlightColor.blue, imageColor.blue, animationRatio);
             CGFloat talpha = getEaseOutQuad(imageHighlightColor.alpha, imageColor.alpha, animationRatio);
             
             
             Color4B intermediate = (Color4B){.red = red, .green = green, .blue = blue,.alpha =  alpha};
             Color4B tintermediate = (Color4B){.red = tred, .green = tgreen, .blue = tblue,.alpha = talpha};
             
             for (int i = 0;i < 6;i++)
             {
                 textureVertexColorData[i].color = tintermediate;
                 
             }
             [self setFrameBackgroundColor:intermediate];
             
             return NO;
         };
         
     }
}


-(void)setBackgroundColor:(Color4B)_color
{
    backgroundColor = _color;
    self.frameBackgroundColor = _color;
}

-(void)setImageColor:(Color4B)_color
{
    imageColor = _color;
    for (int i = 0;i < 6;i++)
    {
        textureVertexColorData[i].color = imageColor;
    }
}

-(void)setBackgroundHightlightColor:(Color4B)_color
{
    backgroundHightlightColor = _color;
}
-(void)setImageHighlightColor:(Color4B)_color
{
    imageHighlightColor = _color;
}


-(Animation *)changeImageColorFrom:(Color4B)startColor To:(Color4B)endColor withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setDataType:AnimationDataTypeColor4B];
    [anim setStartValue:&startColor];
    [anim setEndValue:&endColor];
    anim.delegate = self;
    anim.identifier = ANIMATION_COLOR_CHANGE;
    anim.animationUpdateBlock = ^(Animation *anim)
    {
        [self setImageColor:[anim getCurrentValueForColor4B]];
        return NO;
    };
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}


-(void)draw
{
    glBlendFunc(self.blendModeSrc, self.blendModeDest);
    [mvpMatrixManager pushModelViewMatrix];
    [mvpMatrixManager translateInX:(self.frame.size.width/2) Y:(self.frame.size.height/2) Z:1];
    [mvpMatrixManager scaleByXScale:self.scaleInsideElement.x YScale:self.scaleInsideElement.y ZScale:1];
    [mvpMatrixManager translateInX:self.originInsideElement.x Y:self.originInsideElement.y Z:0];
    if (buttonTexture != nil)
    {
        textureRenderer.texture = buttonTexture;
        [textureRenderer drawWithArray:textureVertexColorData andCount:6];
    }
    [mvpMatrixManager popModelViewMatrix];
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)dealloc
{
    if (buttonTexture!= nil && !buttonTexture.wasCachedInTextureManager)
        [buttonTexture release];
    
    self.target = nil;
    free(textureVertexColorData);
    [super dealloc];
}

@end
