//
//  Animator.h
//  Tiles
//
//  Created by Rakesh on 07/02/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animation.h"



@interface Animator : NSObject
{
    NSMutableArray *currentAnimations;
    NSMutableArray *queuedAnimations;
}
@property (nonatomic,retain) NSMutableArray *currentAnimations;
@property (nonatomic,retain) NSMutableArray *queuedAnimations;

+(Animator *)sharedAnimator;
-(void)update;
-(Animation *)addCustomAnimationFor:(NSObject *)obj withIdentifier:(int)identifier withDuration:(CGFloat)duration afterDelayInSeconds:(CGFloat)delay;

-(void)addAnimation:(Animation *)animation;
-(Animation *)getAnimationOfType:(EasingCurveType)curveType;

-(int)removeRunningAnimationsForObject:(NSObject *)obj;
-(int)removeQueuedAnimationsForObject:(NSObject *)obj;
-(int)removeRunningAnimationsForObject:(NSObject *)obj ofType:(int)type;
-(int)removeQueuedAnimationsForObject:(NSObject *)obj  ofType:(int)type;
-(int)getCountOfQueuedAnimationsForObject:(NSObject *) obj ofType:(int)type;
-(int)getCountOfRunningAnimationsForObject:(NSObject *) obj ofType:(int)type;
-(NSMutableArray *)getRunningAnimationsForObject:(NSObject *) obj ofType:(int)type;
-(Animation *)addAnimationOfType:(EasingCurveType)curveType;
@end
