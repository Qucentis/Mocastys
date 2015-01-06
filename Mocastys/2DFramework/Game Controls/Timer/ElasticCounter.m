//
//  ElasticCounter.m
//  Dabble
//
//  Created by Rakesh on 04/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "ElasticCounter.h"
#import "NSArray+Additions.h"

#define ANIMATION_COUNTUP 1
#define ANIMATION_WIGGLE 2
#define ANIMATION_COUNTDOWN 3
#define ANIMATION_SHOW 4
#define ANIMATION_HIDE 5

@implementation ElasticCounter

@synthesize sequence,vertexData,vertexDataCount,fontSpriteSheet,currentValue,alpha,visible;

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
                self.acceptsTouches = NO;
        previousVerticalOffset = 0;
        currentValue = 0;
        maskedVertices = malloc(sizeof(Vertex3D) * 6);
        maskedTextureCoords = malloc(sizeof(TextureCoord) * 6);
        alpha = 255;
        verticalOffset = 0;
        uiScale = [[UIScreen mainScreen]scale];
    }
    return self;
}

-(BOOL)drawable
{
    return NO;
}

-(BOOL)acceptsTouches
{
    return NO;
}

-(int)numberOfLayers
{
    return 1;
}
-(void)setTextColor:(Color4B)textColor
{
    _textColor = textColor;
    alpha = textColor.alpha;
}


-(void)setStringValueToCount:(NSString *)str inDuration:(CGFloat)duration
{
    int index = [sequence indexOfString:str];
    if (index > currentValue)
    {
        [self setValueCountUp:(index - currentValue)  withDuration:duration];
    }
    else
    {
        [self setValueCountUp:(index+sequence.count)-currentValue withDuration:duration];
    }
}

-(void)setValueCountUp:(CGFloat)value withDuration:(CGFloat)duration
{
    if (duration == 0)
    {
        verticalOffset = previousVerticalOffset + loopCount * (double)frame.size.height;
        previousVerticalOffset = verticalOffset;
        [self calculateCurrentValue];
        return;
    }
    
    wiggleDistance = 0;
    [animator removeRunningAnimationsForObject:self];
    verticalOffset = currentValue * self.frame.size.height;
    loopCount = value;
    maxAngle = (1 + 0.01 * loopCount);
    if (maxAngle > 5)
        maxAngle = 5;
    previousVerticalOffset = verticalOffset;
    
    [animator removeQueuedAnimationsForObject:self];
    [animator removeRunningAnimationsForObject:self];
    
    Animation *animation = [[Animation alloc]init];
    animation.duration = duration;
    animation.identifier = ANIMATION_COUNTDOWN;
    animation.delegate = self;
    animation.animationUpdateBlock = ^(Animation *animation)
    {
        CGFloat animationRatio = [animation getAnimatedRatio];
        CGFloat c = loopCount * animationRatio;
        loopRatio = animationRatio;
        verticalOffset = previousVerticalOffset + c * (double)frame.size.height;
        [self calculateCurrentValue];
        return NO;
    };
    animation.animationEndedBlock = ^(Animation *animation)
    {
        verticalOffset = previousVerticalOffset + loopCount * (double)frame.size.height;
        previousVerticalOffset = verticalOffset;
        [self calculateCurrentValue];
        
        EasingSineAnimation *wiggleAnim = [[EasingSineAnimation alloc]initWithMaximumAmplitude:maxAngle andFrequency:3 andDamping:5];
        
        wiggleAnim.duration = 1.0;
        wiggleAnim.animationUpdateBlock = ^(Animation *animation)
        {
            wiggleDistance = [animation getValue:0];
            return NO;
        };
        wiggleAnim.animationEndedBlock = ^(Animation *anim)
        {
            wiggleDistance = 0;
        };
        [animator addAnimation:wiggleAnim];
    };
    
    [animator addAnimation:animation];
    

}

-(void)setValueCountDown:(CGFloat)value withDuration:(CGFloat)duration
{
    if (duration == 0)
    {
        verticalOffset = previousVerticalOffset + loopCount * (double)frame.size.height;
        previousVerticalOffset = verticalOffset;
        [self calculateCurrentValue];
        return;
    }
    wiggleDistance = 0;
    [animator removeRunningAnimationsForObject:self];
    
    verticalOffset = currentValue * self.frame.size.height;
    loopCount = value;
    maxAngle = -(1 + 0.01 * loopCount);
    if (maxAngle < -5)
        maxAngle = -5;
    previousVerticalOffset = verticalOffset;
    [animator removeQueuedAnimationsForObject:self];
    [animator removeRunningAnimationsForObject:self];

    Animation *animation = [[Animation alloc]init];
    animation.duration = duration;
    animation.identifier = ANIMATION_COUNTDOWN;
    animation.delegate = self;
    animation.animationUpdateBlock = ^(Animation *animation)
    {
        CGFloat animationRatio = [animation getAnimatedRatio];
        CGFloat c = loopCount * animationRatio;
        loopRatio = animationRatio;
        verticalOffset = previousVerticalOffset - c * (double)frame.size.height;
        [self calculateCurrentValue];
        return NO;
    };
    animation.animationEndedBlock = ^(Animation *animation)
    {
        verticalOffset = previousVerticalOffset - loopCount * (double)frame.size.height;
        previousVerticalOffset = verticalOffset;
        [self calculateCurrentValue];
        
        EasingSineAnimation *wiggleAnim = [[EasingSineAnimation alloc]initWithMaximumAmplitude:maxAngle andFrequency:3 andDamping:5];
        
        wiggleAnim.duration = 1.0;
        wiggleAnim.animationUpdateBlock = ^(Animation *animation)
        {
            wiggleDistance = [animation getValue:0];
            return NO;
        };
        wiggleAnim.animationEndedBlock = ^(Animation *anim)
        {
            wiggleDistance = 0;
        };
        [animator addAnimation:wiggleAnim];
    };
    
    [animator addAnimation:animation];
    
}

-(void)showInDuration:(CGFloat)t
{
    EasingAnimation *animation = [[EasingAnimation alloc]initWithOrder:2 andEasingType:EaseOut];
    animation.duration = t;
    animation.delegate = self;
    animation.identifier = ANIMATION_SHOW;
    [animator addAnimation:animation];
    
    animation.animationUpdateBlock = ^(Animation *animation)
    {
        alpha = [animation getValue:0 :self.textColor.alpha];
        return NO;
    };
}

-(void)hideInDuration:(CGFloat)t
{
    
    EasingAnimation *animation = [[EasingAnimation alloc]initWithOrder:2 andEasingType:EaseOut];
    animation.duration = t;
    animation.delegate = self;
    animation.identifier = ANIMATION_HIDE;
    [animator addAnimation:animation];
    
    animation.animationUpdateBlock = ^(Animation *animation)
    {
        alpha = [animation getValue:self.textColor.alpha:0];
        return NO;
    };
}

-(void)setSequence:(NSMutableArray *)_sequence
{
    if (sequence)
    {
        [sequence release];
    }
    sequence = [_sequence retain];
    
}

-(void)stop
{
    [self calculateCurrentValue];
    verticalOffset = currentValue * self.frame.size.height;
    [animator removeRunningAnimationsForObject:self];
}
-(void)calculateCurrentValue
{
    CGFloat totalLength = (sequence.count * self.frame.size.height);

    if (verticalOffset < 0)
    {
        verticalOffset -= floorf(verticalOffset/totalLength) * totalLength;
    }
    else
    {
        verticalOffset -= floorf(verticalOffset/totalLength) * totalLength;
    }
    currentValue = floorf(verticalOffset/self.frame.size.height);
    
}

// Drawing Code
-(void)draw
{
    vertexDataCount = 0;
    
    [self addSpriteAtIndex:-1];
    [self addSpriteAtIndex:0];
    [self addSpriteAtIndex:1];

    
}

-(void)addSpriteAtIndex:(int)sindex
{
    int currentIndex = floorf((verticalOffset+wiggleDistance)/frame.size.height);
    int index = (currentIndex - sindex + sequence.count)%sequence.count;
    CGFloat offsetY = (verticalOffset + wiggleDistance) - currentIndex * frame.size.height;
    
    Sprite *fontSprite = [fontSpriteSheet getSpriteFromKey:sequence[index]];
    
    CGFloat maxY = self.frame.size.height/2;
    CGFloat minY = -self.frame.size.height/2;
    
    CGFloat bottomYFont = offsetY - fontSprite.textureCGRect.size.height/2;
    CGFloat topYFont = offsetY + fontSprite.textureCGRect.size.height/2;
    
    bottomYFont += sindex * frame.size.height;
    topYFont += sindex * frame.size.height;
    
    CGFloat bottomCoordinateFont = bottomYFont;
    CGFloat topCoordinateFont = topYFont;
    
    
    if (!(bottomYFont > maxY || topYFont < minY))
    {
        if (bottomYFont < minY)
            bottomCoordinateFont = minY;
        
        if (topYFont > maxY)
            topCoordinateFont = maxY;
    }
    else
        return;
     
    
    CGRect maskedFontRect = CGRectMake(fontSprite.textureCGRect.origin.x, bottomCoordinateFont, fontSprite.textureCGRect.size.width, topCoordinateFont - bottomCoordinateFont);
    CGRectToVertex3D(maskedFontRect, maskedVertices);
    
    
    
    CGFloat bottomRatio = (bottomCoordinateFont - bottomYFont)/fontSprite.height;
    CGFloat topRatio = (topYFont - topCoordinateFont)/fontSprite.height;
    
    CGRect maskedTextureCoordCGRect = [self getMaskedTexCoordsForFontSprite:fontSprite andBottomRatio:bottomRatio andTopRatio:topRatio];
    
    CGRectToTextureCoord(maskedTextureCoordCGRect, maskedTextureCoords);
    
    Matrix3D result;
    [mvpMatrixManager getMVPMatrix:result];
    
    for (int j = 0;j<6;j++)
    {
        memcpy(&((vertexData + vertexDataCount)->mvpMatrix), result, sizeof(Matrix3D));
        (vertexData + vertexDataCount)->vertex = maskedVertices[j];
        (vertexData + vertexDataCount)->color = _textColor;
        (vertexData + vertexDataCount)->color.alpha = alpha;
        (vertexData + vertexDataCount)->texCoord = maskedTextureCoords[j];
        vertexDataCount++;
    }
    
}

-(CGRect)getMaskedTexCoordsForFontSprite:(Sprite *)fontSprite
                          andBottomRatio:(CGFloat)bottomRatio andTopRatio:(CGFloat)topRatio
{
    CGRect texCoordRect = fontSprite.textureCoordinatesCGRect;
    
    CGFloat textureTop = texCoordRect.origin.y + uiScale * topRatio * texCoordRect.size.height;
    CGFloat textureBottom = texCoordRect.origin.y + (1.0 - uiScale * bottomRatio) * texCoordRect.size.height;
    
    return CGRectMake(texCoordRect.origin.x, textureTop,
                      texCoordRect.size.width, textureBottom - textureTop);
    
}


-(void)dealloc
{
 
    free(vertexData);
    free(maskedVertices);
       [super dealloc];
}


@end
