//
//  KBC
//
//  Created by Rakesh on 30/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLLabel.h"
#import "GLImageButton.h"
#import "GLImageView.h"

typedef enum
{
    GLTextFieldBeginEditing = 0,
    GLTextFieldEndEditing,
    GLTextFieldReturn,
    GLTextFieldChangedText
    
}GLTextFieldEvents;

@interface UITextField (Swipeable)

@end

@interface GLTextField : GLElement <UITextFieldDelegate>
{
    UITextField *textField;
    NSObject *target[5];
    SEL selector[5];
    BOOL willDisappear;
}

@property (nonatomic,retain) NSString *text;
@property (nonatomic,readonly) UITextField *textField;

-(void)resignKeyboard;
-(void)reset;

-(void)addTarget:(NSObject *)_object andSelector:(SEL)_selector
        forEvent:(GLTextFieldEvents)event;

@end
