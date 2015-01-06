//
//  ComposeScene.h
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLScene.h"
#import "GLImageButton.h"
#import "GLShaderManager.h"
#import "GLImageView.h"
#import "TimerControl.h"
#import "ScoreControl.h"
#import "DataManager.h"

@interface ComposeScene : GLScene <UITextViewDelegate,TimerControlDelegate>
{
    UITextView *composeTextField;
    GLImageButton *doneButton;
    Texture2D *composeFieldTexture;
    TimerControl *timerControl;
    UILabel *timeLabel;
    int currentState;
    CGFloat doneDelay;
    CGFloat sendScale;
    CGFloat startScale;
    BOOL endEditing;
    SoundManager *soundManager;
}
@end
