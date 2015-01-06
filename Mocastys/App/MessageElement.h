//
//  MessageElement.h
//  KBC
//
//  Created by Rakesh on 12/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLLabel.h"
#import "GLButton.h"
#import "GLImageView.h"
#import "Message.h"
#import "DataManager.h"

@interface MessageElement : GLElement
{
    GLButton *timeLabel;
    GLImageView *messageView;
    GLImageView *photoView;
    GLLabel *fromLabel;
    GLElement *topBorderElement;
    GLElement *timerElement;
}

@property (nonatomic,retain) Message *message;

-(void)updateTimeElapsed;

@end
