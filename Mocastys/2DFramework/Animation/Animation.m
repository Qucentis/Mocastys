//
//  Animation.m
//  Tiles
//
//  Created by Rakesh on 07/02/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "Animation.h"
#import "EasingFunctions.h"

@implementation Animation

-(id)init
{
    if (self = [super init])
    {
        startValue = NULL;
        endValue = NULL;
    }
    return self;
}

-(id)initWithType:(AnimationValueType)type
{
    if (self = [super init])
    {
        startValue = NULL;
        endValue = NULL;
        self.dataType = type;
        [self setSize];
    }
    return self;
}

-(void)setAnimationValueType:(AnimationValueType)animationValueType
{
    _dataType = animationValueType;
    [self setSize];
}


-(void)setDataType:(AnimationValueType)dataType
{
    _dataType= dataType;
    [self setSize];
}

-(void)setSize
{
    switch (self.dataType) {
        case AnimationDataTypeFloat:
            valueTypeSize = sizeof(CGFloat);
            break;
        case AnimationDataTypeCGPoint:
            valueTypeSize = sizeof(CGPoint);
            break;
        case AnimationDataTypeCGRect:
            valueTypeSize = sizeof(CGRect);
            break;
        case AnimationDataTypeCGSize:
            valueTypeSize = sizeof(CGSize);
            break;
        case AnimationDataTypeColor4B:
            valueTypeSize = sizeof(Color4B);
            break;
        case AnimationDataTypeCustom:
            break;
    }
}


-(BOOL)canAnimationBeStarted
{
    NSTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
    if (currentTime - _animationQueuedTime > _delay)
    {
        return YES;
    }
    return NO;
}

-(CGFloat)getAnimatedRatio
{

    return (CFAbsoluteTimeGetCurrent() - _animationstartTime)*1.0f/(_duration);
}

-(void *)getStartValue
{
    return startValue;
}
-(void *)getEndValue
{
    return endValue;
}

-(void)setStartValue:(void *)_startValue
{
    if (startValue == NULL)
        startValue = malloc(valueTypeSize);
    memcpy(startValue, _startValue, valueTypeSize);
}
-(void)setEndValue:(void *)_endValue
{
    if (endValue == NULL)
        endValue = malloc(valueTypeSize);
    memcpy(endValue, _endValue, valueTypeSize);
}

-(void)setStartValue:(void *)_startValue OfSize:(size_t)size;
{
    if (startValue == NULL)
        startValue = malloc(size);
    memcpy(startValue, _startValue, size);
}

-(void)setEndValue:(void *)_endValue OfSize:(size_t)size;
{
    if (endValue == NULL)
        endValue = malloc(size);
    memcpy(endValue, _endValue, size);
}

-(CGFloat)getValue:(CGFloat)startValue
{
    return 0;
}
-(CGFloat)getValue:(CGFloat)_startValue :(CGFloat)_endValue
{
    return getLinear(_startValue, _endValue, (CFAbsoluteTimeGetCurrent() - _animationstartTime)*1.0f/(_duration));
}

-(CGRect)getCurrentValueForCGRect
{
    CGRect *start = startValue;
    CGRect *end = endValue;
    
    CGRect rect =  CGRectIntegral(CGRectMake([self getValue:start->origin.x:end->origin.x],
                                [self getValue:start->origin.y:end->origin.y],
                                [self getValue:start->size.width:end->size.width],
                                [self getValue:start->size.height:end->size.height]));
    
//    NSLog(@"%@",NSStringFromCGRect(rect));
    return rect;
}

-(float)getCurrentValueForCGFloat
{
    CGFloat *start = startValue;
    CGFloat *end = endValue;
    
    return [self getValue:*start :*end];
}

-(CGPoint)getCurrentValueForCGPoint
{
    CGPoint *start = startValue;
    CGPoint *end = endValue;
    
    CGPoint current = CGPointMake([self getValue:start->x :end->x],
                                  [self getValue:start->y :end->y]);
    
    return current;
}

-(CGSize)getCurrentValueForCGSize
{
    CGSize *start = startValue;
    CGSize *end = endValue;
    
    CGSize current = CGSizeMake([self getValue:start->width :end->width],
                                [self getValue:start->height :end->height]);
    
    return current;
}

-(Color4B)getCurrentValueForColor4B
{
    Color4B *start = startValue;
    Color4B *end = endValue;
    
    Color4B current = (Color4B){.red = [self getValue:start->red :end->red],
        .green = [self getValue:start->green :end->green],
        .blue = [self getValue:start->blue :end->blue],
        .alpha = [self getValue:start->alpha :end->alpha]};
    
    return current;
}


-(void)dealloc
{
    if (startValue != NULL)
        free(startValue);
    if (endValue != NULL)
        free(endValue);
    
    self.delegate = nil;
    self.animationUpdateBlock = nil;
    self.animationStartedBlock = nil;
    self.animationEndedBlock = nil;
 
    [super dealloc];
}

@end

@implementation EasingSineAnimation

-(id)init
{
    if (self = [super init])
    {
        easingFunction = &getSineEaseOut;
        _frequency = 3;
        _maximumAmplitude = 10;
        _damping = 5;
    }
    return self;
}

-(id)initWithMaximumAmplitude:(CGFloat)maxAmp
                 andFrequency:(CGFloat)frequency andDamping:(CGFloat)damping
{
    if (self = [super init])
    {
        easingFunction = &getSineEaseOut;
        _frequency = frequency;
        _maximumAmplitude = maxAmp;
        _damping = damping;
    }
    return self;
}

-(CGRect)getCurrentValueForCGRect
{
    CGRect *start = startValue;

    CGRect rect =  CGRectIntegral(CGRectMake([self getValue:start->origin.x],
                              [self getValue:start->origin.y],
                              [self getValue:start->size.width],
                              [self getValue:start->size.height]));
    return rect;
}

-(float)getCurrentValueForCGFloat
{
    CGFloat *start = startValue;
    
    return [self getValue:*start];
}

-(CGPoint)getCurrentValueForCGPoint
{
    CGPoint *start = startValue;
    
    CGPoint current = CGPointMake([self getValue:start->x],
                                  [self getValue:start->y]);
    
    return current;
}

-(CGSize)getCurrentValueForCGSize
{
    CGSize *start = startValue;
    
    CGSize current = CGSizeMake([self getValue:start->width],
                                [self getValue:start->height]);
    
    return current;
}

-(Color4B)getCurrentValueForColor4B
{
    Color4B *start = startValue;
    
    Color4B current = (Color4B){.red = [self getValue:start->red],
        .green = [self getValue:start->green],
        .blue = [self getValue:start->blue],
        .alpha = [self getValue:start->alpha]};
    
    return current;
}




-(CGFloat)getValue:(CGFloat)_startValue
{
    return easingFunction(_startValue,[self getAnimatedRatio],_maximumAmplitude,_damping,_frequency);
}

@end

@implementation EasingBackAnimation

-(id)init
{
    if (self = [super init])
    {
        self.easingType = EaseOut;
    }
    return self;
}

-(id)initWithEasingType:(EasingAnimationType)type;
{
    if (self = [super init])
    {
        self.easingType = type;
    }
    return self;
}

-(CGFloat)getValue:(CGFloat)_startValue :(CGFloat)_endValue
{
    return easingFunction(_startValue,_endValue,[self getAnimatedRatio]);
}

-(void)setEasingType:(EasingAnimationType)easingType
{
    _easingType = easingType;
    switch (easingType) {
        case EaseIn:
            easingFunction = &getEaseInBack;
            break;
        case EaseOut:
            easingFunction = &getEaseOutBack;
            break;
        case EaseInOut:
            easingFunction = &getEaseInOutBack;
            break;
        default:
            easingFunction = &getEaseInBack;
            break;
    }
}

@end


@implementation EasingAnimation

-(id)init
{
    if (self = [super init])
    {
        _order = 2;
        self.easingType = EaseIn;
    }
    return self;
}

-(id)initWithOrder:(int)order andEasingType:(EasingAnimationType)type
{
    if (self = [super init])
    {
        _order = order;
        self.easingType = type;
    }
    return self;
}



-(CGFloat)getValue:(CGFloat)_startValue :(CGFloat)_endValue
{
    return easingFunction(_startValue,_endValue,[self getAnimatedRatio]);
}

-(void)setEasingType:(EasingAnimationType)easingType
{
    _easingType = easingType;
    [self setOrder:_order];
}

-(void)setOrder:(int)order
{
    _order = order;
    if(self.easingType == EaseIn)
    {
        switch (order) {
            case 2:
                easingFunction = &getEaseInQuad;
                break;
            case 3:
                easingFunction = &getEaseInCubic;
                break;
            case 4:
                easingFunction = &getEaseInQuartic;
                break;
            case 5:
                easingFunction = &getEaseInQuintic;
                break;
            default:
                easingFunction = &getEaseInQuad;
                break;
        }
    }
    else if(self.easingType == EaseOut)
    {
        switch (order) {
            case 2:
                easingFunction = &getEaseOutQuad;
                break;
            case 3:
                easingFunction = &getEaseOutCubic;
                break;
            case 4:
                easingFunction = &getEaseOutQuartic;
                break;
            case 5:
                easingFunction = &getEaseOutQuintic;
                break;
            default:
                easingFunction = &getEaseOutQuad;
                break;
        }
    }
    else if(self.easingType == EaseInOut)
    {
        switch (order) {
            case 2:
                easingFunction = &getEaseInOutQuad;
                break;
            case 3:
                easingFunction = &getEaseInOutCubic;
                break;
            case 4:
                easingFunction = &getEaseInOutQuartic;
                break;
            case 5:
                easingFunction = &getEaseInOutQuintic;
                break;
            default:
                easingFunction = &getEaseInOutQuad;
                break;
        }
    }
    
}

@end

@implementation EasingElasticAnimation

-(id)init
{
    if (self = [super init])
    {
        easingFunction = &getEaseOutElastic;
    }
    return self;
}


-(CGFloat)getValue:(CGFloat)_startValue :(CGFloat)_endValue
{
    return easingFunction(_startValue,_endValue,[self getAnimatedRatio],self.duration);
}

@end
