//
//  Animator.m
//  Tiles
//
//  Created by Rakesh on 07/02/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "Animator.h"
#import "GLImageView.h"
@implementation Animator

@synthesize currentAnimations,queuedAnimations;

+(Animator *)sharedAnimator
{
    static Animator *animator;
    
    @synchronized(self)
    {
        if (animator == nil)
        {
            animator = [[Animator alloc]init];
        }
    }
    return animator;
}

-(id)init
{
    if (self = [super init])
    {
            currentAnimations = [[NSMutableArray alloc]init];
            queuedAnimations = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)update
{
    for (int i =0;i<queuedAnimations.count;i++)
    {
        Animation *animation = queuedAnimations[i];
        if ([animation canAnimationBeStarted])
        {
            for (int j = 0;j<currentAnimations.count;j++)
            {
                Animation *anim = currentAnimations[j];
                if (anim.delegate == animation.delegate
                    && anim.identifier == animation.identifier && anim.animationData == animation.animationData)
                {
                    [currentAnimations removeObject:anim];
                    j--;
                }
            }
            [currentAnimations addObject:animation];
            [queuedAnimations removeObject:animation];
            
            animation.animationstartTime = CFAbsoluteTimeGetCurrent();
            if (animation.animationStartedBlock != nil)
                animation.animationStartedBlock(animation);
            i--;
        }
    }
    
    for (int i =0;i<currentAnimations.count;i++)
    {
        Animation *animation = currentAnimations[i];
        BOOL stop = NO;
        
        if (animation.animationUpdateBlock != nil)
            stop = animation.animationUpdateBlock(animation);

        if ( stop || [animation getAnimatedRatio] >= 1.0)
        {
            
            [animation retain];
            [currentAnimations removeObject:animation];
            
            if (animation.animationEndedBlock != nil)
                animation.animationEndedBlock(animation);

            [animation release];
            
            i--;
        }
    }
    
}

-(int)removeRunningAnimationsForObject:(NSObject *)obj
{
    int count = 0;
    for (int i =0;i<currentAnimations.count;i++)
    {
        Animation *animation = currentAnimations[i];
        if (animation.delegate == obj)
        {
            count++;
            [currentAnimations removeObject:animation];
            i--;
        }
        
    }
    
    return count;
}

-(int)removeQueuedAnimationsForObject:(NSObject *)obj
{
    int count = 0;
    for (int i =0;i<queuedAnimations.count;i++)
    {
        Animation *animation = queuedAnimations[i];
        if (animation.delegate == obj)
        {
            count++;
            [queuedAnimations removeObject:animation];
            i--;
        }
    }
    return count;
}

-(int)removeRunningAnimationsForObject:(NSObject *)obj ofType:(int)type
{
    int count = 0;
    for (int i =0;i<currentAnimations.count;i++)
    {
        Animation *animation = currentAnimations[i];
        if (animation.delegate == obj && animation.identifier == type)
        {
            count++;
            [currentAnimations removeObject:animation];
            i--;
        }
        
    }
    
    return count;
}
-(int)removeQueuedAnimationsForObject:(NSObject *)obj  ofType:(int)type
{
    int count = 0;
    for (int i =0;i<queuedAnimations.count;i++)
    {
        Animation *animation = queuedAnimations[i];
        if (animation.delegate == obj && animation.identifier == type)
        {
            count++;
            [queuedAnimations removeObject:animation];
            i--;
        }
    }
    return count;
}

-(int)getCountOfRunningAnimationsForObject:(NSObject *) obj ofType:(int)type
{
    int count = 0;
    for (int i =0;i<currentAnimations.count;i++)
    {
        Animation *animation = currentAnimations[i];
        if (animation.delegate == obj && animation.identifier == type)
        {
            count++;
        }
    }
    return count;
}

-(int)getCountOfQueuedAnimationsForObject:(NSObject *) obj ofType:(int)type
{
    int count = 0;
    for (int i =0;i<queuedAnimations.count;i++)
    {
        Animation *animation = queuedAnimations[i];
        if (animation.delegate == obj && animation.identifier == type)
        {
            count++;
        }
    }
    return count;
}

-(NSMutableArray *)getRunningAnimationsForObject:(NSObject *) obj ofType:(int)type
{
    NSMutableArray *arr = [[[NSMutableArray alloc]init]autorelease];
    for (int i =0;i<currentAnimations.count;i++)
    {
        Animation *animation = currentAnimations[i];
        if (animation.delegate == obj && animation.identifier == type)
        {
            [arr addObject:animation];
        }
    }
    return arr;
}

-(Animation *)addCustomAnimationFor:(NSObject *)obj withIdentifier:(int)identifier withDuration:(CGFloat)duration afterDelayInSeconds:(CGFloat)delay
{
    Animation *animation = [[Animation alloc]initWithType:AnimationDataTypeCustom];
    animation.delegate = obj;
    animation.identifier = identifier;
    animation.duration = duration;
    animation.animationQueuedTime = CFAbsoluteTimeGetCurrent();
    animation.delay = delay;
    [queuedAnimations addObject:animation];
    [animation release];
    
    return animation;
}

-(Animation *)getAnimationOfType:(EasingCurveType)curveType
{
    Animation *returnAnimation = nil;
    switch (curveType) {
        case EasingOrdered:
            returnAnimation = [[EasingAnimation alloc]init];
            break;
        case EasingBack:
            returnAnimation = [[EasingBackAnimation alloc]init];
            break;
        case EasingElastic:
            returnAnimation = [[EasingElasticAnimation alloc]init];
            break;
        case EasingSine:
            returnAnimation = [[EasingSineAnimation alloc]init];
            break;
        default:
            returnAnimation = [[Animation alloc]init];
            break;
    }
    
    return returnAnimation;
}

-(Animation *)addAnimationOfType:(EasingCurveType)curveType
{
    Animation *returnAnimation = nil;
    switch (curveType) {
        case EasingOrdered:
            returnAnimation = [[EasingAnimation alloc]init];
            break;
        case EasingBack:
            returnAnimation = [[EasingBackAnimation alloc]init];
            break;
        case EasingElastic:
            returnAnimation = [[EasingElasticAnimation alloc]init];
            break;
        case EasingSine:
            returnAnimation = [[EasingSineAnimation alloc]init];
            break;
        default:
            returnAnimation = [[Animation alloc]init];
            break;
    }
    
    [self addAnimation:returnAnimation];
    return returnAnimation;
}


-(void)addAnimation:(Animation *)animation
{
    animation.animationQueuedTime = CFAbsoluteTimeGetCurrent();
    [queuedAnimations addObject:animation];
    [animation release];
}


@end
