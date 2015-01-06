//
//  TimerControl.m
//  Dabble
//
//  Created by Rakesh on 03/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "ScoreControl.h"

#define marginX 0
#define marginY 0

#define ANIMATION_ALIGN 1
#define ANIMATION_HIGHLIGHT 2
#define ANIMATION_NORMAL 3

@implementation ScoreControl

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        vertexData = NULL;
        visibleCount = 0;
        offsetVisibleX = 0;
        textureRenderer = [rendererManager getRendererWithVertexShaderName:@"InstancedTextureShader" andFragmentShaderName:@"StringTextureShader"];
        
        counterControls = [[NSMutableArray alloc]init];
        
        NSString *fontStr =  @"0,1,2,3,4,5,6,7,8,9";;
        numberArray = [[fontStr componentsSeparatedByString:@","]retain];
        
        textAlignment = UITextAlignmentCenter;
        _textColor = (Color4B){0,0,0,255};
    }
    return self;
}

-(void)setTimeLeft:(CGFloat)time
{
    timeLeft = time;
}

-(int)numberOfLayers
{
    return counterControls.count;
}

-(void)setTextColor:(Color4B)textcolor
{
    _textColor = textcolor;
    for (ElasticCounter *counter in counterControls)
    {
        counter.textColor = textcolor;
        if (!counter.visible)
            counter.alpha = 0;
    }
}

-(void)stop
{
    int prevvalue = 0;
    for (int i = counterControls.count - 1;i>=0 ;i--)
    {
        int ind = counterControls.count - i - 1;
        ElasticCounter * counter = counterControls[ind];
        prevvalue += counter.currentValue * powl(10, i);
        [counter stop];
    }

}

-(void)setValue:(long long)value inDuration:(CGFloat)time
{
    int prevvalue = 0;
    CGFloat offsetTime = 0.01;
    if (time == 0)
        offsetTime = 0;
    for (int i = counterControls.count - 1;i>=0 ;i--)
    {
        int ind = counterControls.count - i - 1;
        ElasticCounter * counter = counterControls[ind];
        [counter stop];
        prevvalue += counter.currentValue * powl(10, i);
    }
    
    if (value > prevvalue)
    {
        BOOL start = NO;
        for (int i = counterControls.count - 1;i>=0 ;i--)
        {
            int ind = counterControls.count - i - 1;
            ElasticCounter * counter = counterControls[ind];
            
            long long v = floorf((value/powl(10, i)));
            long long pv = floorf((prevvalue/powl(10, i)));
            
            if (v-pv > 0)
            {
                if (!start)
                {
                    start = YES;
                    [counter setValueCountUp:v-pv withDuration:time];
                }
                else
                {
                    [counter setValueCountUp:v-pv withDuration:time + offsetTime * ind];
                }
                
            }
            
            if (start)
            {
                counter.visible = YES;
                [counter showInDuration:0.05];
                [self updateOffsets];
            }
        }
    }
    else if (value < prevvalue)
    {
        BOOL start = NO;
        BOOL previousHidden = YES;
        for (int i = counterControls.count - 1;i>=0 ;i--)
        {
            int ind = counterControls.count - i - 1;
            ElasticCounter * counter = counterControls[ind];
    
            long long v = floorf((value/powl(10, i)));
            long long pv = floorf((prevvalue/powl(10, i)));
            
            if (pv - v > 0)
            {
                if (!start)
                {
                    start = YES;
                    [counter setValueCountDown:pv - v withDuration:time];
                    if (i != 0)
                    {
                        if (v == 0 && previousHidden)
                        {
                            counter.visible = NO;
                            [counter hideInDuration:time];
                            [self updateOffsets];
                        }
                        else
                            previousHidden = NO;
                    }
                }
                else
                {
                    [counter setValueCountDown:pv - v withDuration:time + offsetTime * ind];
                    if (i != 0)
                    {
                        if (v == 0 && previousHidden)
                        {
                            counter.visible = NO;
                            [self updateOffsets];
                            [counter hideInDuration:0.3];
                        }
                        else
                            previousHidden = NO;
                    }
                }
                
            }
            

        }

    }
}


-(void)setTextAlignment:(UITextAlignment)_textAlignment
{
    textAlignment = _textAlignment;
    if (textAlignment == UITextAlignmentCenter)
    {
        offsetVisibleX = (counterControls.count - visibleCount) * widthPerCounter/2.0;
    }
    else if (textAlignment == UITextAlignmentLeft)
    {
        offsetVisibleX = (counterControls.count - visibleCount) * widthPerCounter;
    }
    else if (textAlignment == UITextAlignmentRight)
    {
        offsetVisibleX = 0;
    }
}

-(void)updateOffsets
{
    visibleCount = 0;
    for (ElasticCounter *c in counterControls)
        if (c.visible)
            visibleCount++;
    
    CGFloat offset = 0;
    
    if (textAlignment == UITextAlignmentCenter)
    {
        offset = (counterControls.count - visibleCount) * widthPerCounter/2.0;
    }
    else if (textAlignment == UITextAlignmentLeft)
    {
        offset = (counterControls.count - visibleCount) * widthPerCounter;
    }
    else if (textAlignment == UITextAlignmentRight)
    {
        offset = 0;
    }

    
   EasingAnimation *animation = [[EasingAnimation alloc]initWithOrder:2 andEasingType:EaseOut];
    animation.duration = 0.1;
    animation.delegate = self;
    animation.identifier = ANIMATION_ALIGN;
    animation.dataType = AnimationDataTypeFloat;
    [animation setStartValue:&offsetVisibleX];
    [animation setEndValue:&offset];
    animation.animationUpdateBlock = ^(Animation *animation)
    {
        offsetVisibleX = [animation getCurrentValueForCGFloat];
        return NO;
    };
   [animator addAnimation:animation];
}


-(void)setFont:(NSString *)font withSize:(CGFloat)size
{
    fontSpriteSheet = [textureManager getFontSpriteSheetOfFontName:font andSize:size andType:FontSpriteTypeNumbers];
    
    [fontSpriteSheet generateMipMap];
    
    if (vertexData != NULL)
        free(vertexData);
    
    [subElements removeAllObjects];
    [counterControls removeAllObjects];
    
    CGFloat maxWidth = 0;
    
    for (Sprite *f in fontSpriteSheet.spriteDictionary.objectEnumerator)
        maxWidth = (maxWidth < f.width)?f.width:maxWidth;
    
    maxWidth /=[[UIScreen mainScreen]scale];
    widthPerCounter = maxWidth;
    
    int num = floorf(((self.frame.size.width - marginX*2)/maxWidth));
    vertexData = malloc(sizeof(InstancedTextureVertexColorData) * num * 6 * 4);
    ElasticCounter *counter;
    for (int i = 0;i<num;i++)
    {
         counter = [[ElasticCounter alloc]
                                   initWithFrame:CGRectMake(frame.size.width - (marginX + ((num - i) * maxWidth)), marginY, maxWidth,
                                                            self.frame.size.height - 2 * marginY)];
        counter.fontSpriteSheet = fontSpriteSheet;
        [counter setSequence:numberArray];
        counter.textColor = _textColor;
        [self addElement:counter];
        counter.alpha = 0;
        counter.visible = NO;
        [counterControls addObject:counter];
        
    }
    counter.visible = YES;
    counter.alpha = _textColor.alpha;
    visibleCount = 1;
    [self setTextAlignment:textAlignment];
}

-(void)draw
{
    
     int count = 0;
     
    for (ElasticCounter *counter in counterControls)
    {
        [mvpMatrixManager pushModelViewMatrix];
        [mvpMatrixManager translateInX:counter.frame.origin.x +
         counter.frame.size.width/2 - offsetVisibleX
                                     Y:counter.frame.origin.y + counter.frame.size.height/2 Z:1];
        counter.vertexData = (vertexData + count);
        [counter draw];
        count += counter.vertexDataCount;
        [mvpMatrixManager popModelViewMatrix];
    }
    [textureRenderer setTexture:fontSpriteSheet];
    [textureRenderer drawWithArray:vertexData andCount:count];
    
}

-(CGFloat)getVisibleWidth
{
    return visibleCount * widthPerCounter;
}

-(void)setBackgroundColor:(Color4B)backgroundColor
{
    backgroundNormalColor = backgroundColor;
    [self setFrameBackgroundColor:backgroundColor];
}

-(void)setBackgroundHighlightColor:(Color4B)highlightColor
{
    backgroundHighlightColor = highlightColor;
}

-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_NORMAL];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_HIGHLIGHT];
    
    
    Animation *animation = [self getAnimationForColorChangeFrom:frameBackgroundColor To:backgroundHighlightColor withDuration:0.2 afterDelay:0 usingCurve:EasingOrdered];
    animation.animationUpdateBlock =  ^(Animation *animation)
    {
        self.frameBackgroundColor = [animation getCurrentValueForColor4B];
        return NO;
    };
    
    [self.delegate scoreControl:self withEvent:SCORECONTROLEVENT_TOUCHDOWN];
    
}

-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_NORMAL];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_HIGHLIGHT];
    
    
    Animation *animation = [self getAnimationForColorChangeFrom:frameBackgroundColor To:backgroundNormalColor withDuration:0.2 afterDelay:0 usingCurve:EasingOrdered];
    animation.animationUpdateBlock =  ^(Animation *animation)
    {
        self.frameBackgroundColor = [animation getCurrentValueForColor4B];
        return NO;
    };
    
    [self.delegate scoreControl:self withEvent:SCORECONTROLEVENT_TOUCHUP];
    
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_NORMAL];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_HIGHLIGHT];
    
    Animation *animation = [self getAnimationForColorChangeFrom:frameBackgroundColor To:backgroundNormalColor withDuration:0.2 afterDelay:0 usingCurve:EasingOrdered];
    animation.animationUpdateBlock =  ^(Animation *animation)
    {
        self.frameBackgroundColor = [animation getCurrentValueForColor4B];
        return NO;
    };
    
    [self.delegate scoreControl:self withEvent:SCORECONTROLEVENT_TOUCHCANCELLED];
}


-(void)dealloc
{
    [numberArray release];
    [counterControls release];
    [super dealloc];
}

@end
