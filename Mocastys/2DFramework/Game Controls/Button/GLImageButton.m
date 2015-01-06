//
//  GLButton.m
//  Dabble
//
//  Created by Rakesh on 19/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLImageButton.h"

#define ANIMATION_HIGHLIGHT 1
#define ANIMATION_NORMAL 2
#define ANIMATION_COLOR_CHANGE 3

@implementation GLImageButton

@synthesize backgroundColor,imageColor,backgroundHightlightColor,imageHighlightColor;

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        imageColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        backgroundColor = (Color4B){.red = 0,.green = 0,.blue = 0,.alpha = 128};
        backgroundHightlightColor = imageColor;
        imageHighlightColor = backgroundColor;
        
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"TextureShader"];
        
        textureVertexColorData = malloc(sizeof(TextureVertexColorData) * 6);
        _usesTextureManager = YES;
        
        _textLabel = [[GLLabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:_textLabel];
        [_textLabel release];
        self.blendModeSrc = GL_ONE;
        self.blendModeDest = GL_ONE_MINUS_SRC_ALPHA;
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        imageColor = (Color4B){.red = 255,.green = 255,.blue = 255,.alpha = 255};
        backgroundColor = (Color4B){.red = 0,.green = 0,.blue = 0,.alpha = 128};
        backgroundHightlightColor = imageColor;
        imageHighlightColor = backgroundColor;
        
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"TextureShader"];
        
        textureVertexColorData = malloc(sizeof(TextureVertexColorData) * 6);
        _usesTextureManager = YES;
        
        _textLabel = [[GLLabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:_textLabel];
        [_textLabel release];
        self.blendModeSrc = GL_ONE;
        self.blendModeDest = GL_ONE_MINUS_SRC_ALPHA;
    }
    return self;
}

-(void)setFrame:(CGRect)_frame
{
    [super setFrame:_frame];
    _textLabel.frame =CGRectMake(0, 0, _frame.size.width, _frame.size.height);
}

-(void)setStringTextureRenderer:(BOOL)use
{
    if (use)
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"StringTextureShader"];
    else
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"TextureShader" andFragmentShaderName:@"TextureShader"];
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
    
    TextureCoord *texCoord = [buttonTexture getTextureCoordinates];
    Vertex3D *vertices = [buttonTexture getTextureVertices];
    
    for (int i = 0;i < 6;i++)
    {
        textureVertexColorData[i].vertex = vertices[i];
        textureVertexColorData[i].texCoord = texCoord[i];
        textureVertexColorData[i].color = imageColor;
    }
}


-(void)setImage:(NSString *)imageName ofType:(NSString *)type
{
    if (buttonTexture != nil && !buttonTexture.wasCachedInTextureManager)
        [buttonTexture release];
    
    if (_usesTextureManager)
        buttonTexture =  [textureManager getTextureWithName:imageName OfType:type];
    else
        buttonTexture = [Texture2D getTextureWithName:imageName OfType:type];
    
    if (self.requiresMipMap)
        [buttonTexture generateMipMap];
    
    TextureCoord *texCoord = [buttonTexture getTextureCoordinates];
    Vertex3D *vertices = [buttonTexture getTextureVertices];
    
    for (int i = 0;i < 6;i++)
    {
        textureVertexColorData[i].vertex = vertices[i];
        textureVertexColorData[i].texCoord = texCoord[i];
        textureVertexColorData[i].color = imageColor;
    }
}

-(void)setImage:(UIImage *)image
{
    if (buttonTexture != nil && !buttonTexture.wasCachedInTextureManager)
        [buttonTexture release];
    
    _usesTextureManager = YES;
    buttonTexture =  [[Texture2D alloc]initWithImage:image];
    
    if (self.requiresMipMap)
        [buttonTexture generateMipMap];
    
    TextureCoord *texCoord = [buttonTexture getTextureCoordinates];
    Vertex3D *vertices = [buttonTexture getTextureVertices];
    
    for (int i = 0;i < 6;i++)
    {
        textureVertexColorData[i].vertex = vertices[i];
        textureVertexColorData[i].texCoord = texCoord[i];
        textureVertexColorData[i].color = imageColor;
    }
    
}

-(void)setRequiresMipMap:(BOOL)_requiresMipMap
{
    requiresMipMap = _requiresMipMap;
    [buttonTexture generateMipMap];
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

-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self setHighlight:YES InDuration:0.2 afterDelay:0];
}

-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self setHighlight:NO InDuration:0.2 afterDelay:0];
    [_target performSelector:_selector withObject:nil];
    
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [self setHighlight:NO InDuration:0.2 afterDelay:0];
}

-(void)addTarget:(NSObject *)target andSelector:(SEL)selector
{
    self.target = target;
    self.selector = selector;
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
    glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
}

-(void)dealloc
{
    self.target = nil;
    if (buttonTexture!= nil && !buttonTexture.wasCachedInTextureManager)
        [buttonTexture release];
    free(textureVertexColorData);
    [super dealloc];
}

@end
