//
//  MessageScene.h
//  KBC
//
//  Created by Rakesh on 07/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLScene.h"
#import "GLImageButton.h"
#import "GLImageView.h"
#import "ScoreControl.h"
#import "Friend.h"
#import "GLLabel.h"
#import "MessageElement.h"
#import "SwipeGestureRecognizer.h"

@interface MessageScene : GLScene
{
    SwipeGestureRecognizer *horizontalSwipeGestureRecognizer;
    
    MessageElement *currentMessageElement;
    MessageElement *nextMessageElement;
    
    GLImageButton *previousImageButton;
    GLImageButton *nextImageButton;
    
    CGPoint touchStartPoint;
    CGPoint currentTouchPoint;
    CGFloat startOffset;
    BOOL timerStarted;
    
    
    int secondsElapsed;
}

@property (nonatomic,retain) Message *currentMessage;
@property (nonatomic,retain) NSDate *timeOpened;
@property (nonatomic,retain) Friend *friend;
@property (nonatomic,retain) NSDate *lastUpdateTime;

@end
