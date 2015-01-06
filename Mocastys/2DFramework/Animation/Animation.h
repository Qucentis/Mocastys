//
//  Animation.h
//  Tiles
//
//  Created by Rakesh on 07/02/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLCommon.h"



@class Animation;

typedef enum
{
    AnimationDataTypeFloat = 0,
    AnimationDataTypeCGPoint,
    AnimationDataTypeCGSize,
    AnimationDataTypeCGRect,
    AnimationDataTypeColor4B,
    AnimationDataTypeCustom
} AnimationValueType;

typedef enum
{
    EaseIn= 0,
    EaseOut,
    EaseInOut
}EasingAnimationType;

typedef enum
{
    EasingOrdered= 0,
    EasingBack,
    EasingSine,
    EasingElastic,
    Linear
}EasingCurveType;

@interface Animation : NSObject
{
    void *startValue;
    void *endValue;
    size_t valueTypeSize;
}
@property (nonatomic,retain) NSObject *delegate;

@property (nonatomic) int identifier;
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) AnimationValueType dataType;
@property (nonatomic,retain) NSObject *animationData;
@property (nonatomic)  NSTimeInterval animationQueuedTime;
@property (nonatomic)  NSTimeInterval  animationstartTime;


@property (nonatomic,copy) BOOL (^animationUpdateBlock)(Animation * animation);
@property (nonatomic,copy) void (^animationStartedBlock)(Animation * animation);
@property (nonatomic,copy) void (^animationEndedBlock)(Animation * animation);

-(CGFloat)getAnimatedRatio;
-(BOOL)canAnimationBeStarted;

-(void)setEndValue:(void *)_endValue OfSize:(size_t)size;
-(void)setStartValue:(void *)_startValue OfSize:(size_t)size;

-(void)setStartValue:(void *)_startValue;
-(void)setEndValue:(void *)_endValue;

-(void *)getStartValue;
-(void *)getEndValue;

-(id)initWithType:(AnimationValueType)type;

-(CGFloat)getValue:(CGFloat)startValue;
-(CGFloat)getValue:(CGFloat)startValue :(CGFloat)endValue;


-(CGRect)getCurrentValueForCGRect;
-(float)getCurrentValueForCGFloat;
-(CGPoint)getCurrentValueForCGPoint;
-(CGSize)getCurrentValueForCGSize;
-(Color4B)getCurrentValueForColor4B;


@end

@interface EasingSineAnimation : Animation
{
    CGFloat (*easingFunction)(CGFloat,CGFloat,CGFloat,CGFloat,CGFloat);
}

-(id)initWithMaximumAmplitude:(CGFloat)maxAmp
                 andFrequency:(CGFloat)frequency andDamping:(CGFloat)damping;

@property (nonatomic) CGFloat frequency;
@property (nonatomic) CGFloat maximumAmplitude;
@property (nonatomic) CGFloat damping;

-(CGFloat)getValue:(CGFloat)startValue;
@end

@interface EasingElasticAnimation : Animation
{
    CGFloat (*easingFunction)(CGFloat,CGFloat,CGFloat,CGFloat);
}

-(CGFloat)getValue:(CGFloat)startValue :(CGFloat)endValue;
@end


@interface EasingBackAnimation : Animation
{
    CGFloat (*easingFunction)(CGFloat,CGFloat,CGFloat);
}

-(id)initWithEasingType:(EasingAnimationType)type;

@property (nonatomic) EasingAnimationType easingType;

-(CGFloat)getValue:(CGFloat)startValue :(CGFloat)endValue;
@end


@interface EasingAnimation : Animation
{
    CGFloat (*easingFunction)(CGFloat,CGFloat,CGFloat);
}

-(id)initWithOrder:(int)order andEasingType:(EasingAnimationType)type;

@property (nonatomic) EasingAnimationType easingType;
@property (nonatomic) int order;
-(CGFloat)getValue:(CGFloat)startValue :(CGFloat)endValue;


@end


