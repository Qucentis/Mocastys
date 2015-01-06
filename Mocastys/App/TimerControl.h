//
//  TimerControl.h
//  KBC
//
//  Created by Rakesh on 30/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLImageView.h"
#import "GLButton.h"
#import "GLImageButton.h"

@protocol TimerControlDelegate
@optional
-(void)changeValueOfTimerControl:(int)value;
-(void)setActiveTimerControl;
-(void)setInactiveTimerControl;
@end

@interface TimerControl : GLElement
{
    GLImageView *imageView;
    GLButton *textView;
    BOOL shown;
    CGFloat CIRCLE_SIZE;
    int fontSize;
    int ignoreTouchRadius;
}
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGPoint center;
@property (nonatomic) int value;
@property (nonatomic,retain) NSObject<TimerControlDelegate>* delegate;

-(void)showInDuration:(CGFloat)duration afterDelay:(CGFloat)delay;
-(void)hideInDuration:(CGFloat)duration afterDelay:(CGFloat)delay;

@end
