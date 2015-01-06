//
//  GLTextFieldSet.h
//  KBC
//
//  Created by Rakesh on 02/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLImageView.h"
#import "GLTextField.h"

typedef enum
{
    GLTextFieldSetBeginEditing = 0,
    GLTextFieldSetEndEditing,
    GLTextFieldSetChangeFieldSet
}GLTextFieldSetEvents;

@interface GLTextFieldSet : GLElement
{
    NSMutableArray *textFields;
    int numberOfTextFields;
    GLLabel *titleLabel;
    
    NSObject *target[5];
    SEL selector[5];
}

@property (nonatomic,readonly) GLLabel *titleLabel;

-(void)setNumberOfTextFields:(int)numberOfFields;
-(void)setTitle:(NSString *)title;
-(void)setPlaceholder:(NSString *)string atIndex:(int)index;
-(NSString *)getStringAtIndex:(int)index;
-(void)setImageName:(NSString *)imageName OfType:(NSString *)type AtIndex:(int)index;
-(UITextField *)getUITextFieldAtIndex:(int)index;
-(void)reset;

-(void)addTarget:(NSObject *)_target andSelector:(SEL)_selector forEvent:(GLTextFieldSetEvents)event;
-(void)beginEditingTextFieldAtIndex:(int)index;

@end
