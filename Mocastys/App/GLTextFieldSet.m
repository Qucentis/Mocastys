//
//  GLTextFieldSet.m
//  KBC
//
//  Created by Rakesh on 02/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLTextFieldSet.h"

@implementation GLTextFieldSet

@synthesize titleLabel;

-(void)setNumberOfTextFields:(int)numberOfFields
{
    numberOfTextFields = numberOfFields;
    [self removeAllElements];
    [textFields release];
 
    textFields = [[NSMutableArray alloc]init];
    
    GLImageView *borderImageView;
    
     if (numberOfFields == 1)
    {
        borderImageView = [[GLImageView alloc]initWithFrame:CGRectMake(0
                                                                           , 0,  302,46)];
        [self addElement:borderImageView];
        [borderImageView setImage:@"g_sc_border-1" ofType:@"png"];
        [borderImageView release];
        
        GLImageView *backgroundImageView = [[GLImageView alloc]initWithFrame:CGRectMake(3, 3, 296, 40)];
        [backgroundImageView setImage:@"g_sc_bkg-allRound" ofType:@"png"];
        [self addElement:backgroundImageView];
        [backgroundImageView release];
        
        GLTextField *textField = [[GLTextField alloc]initWithFrame:CGRectMake(46, 3, 253, 40)];
        [self addElement:textField];
        [textField release];
        [textFields addObject:textField];
        [textField release];
        textField.tag = 0;
        [textField addTarget:self andSelector:@selector(textFieldReturnPressed:)
                    forEvent:GLTextFieldReturn];
        
        titleLabel = [[GLLabel alloc]initWithFrame:CGRectMake(5, 50, 320, 24)];
        [self addElement:titleLabel];
        [titleLabel setFont:@"Lato-Bold" withSize:20];
        [titleLabel setTextColor:Color4BFromHex(0x000000ff)];
        [titleLabel setFrameBackgroundColor:Color4BFromHex(0xffffff00)];
        [titleLabel release];
        
    }
    else if (numberOfFields == 2)
    {
        borderImageView = [[GLImageView alloc]initWithFrame:CGRectMake(0, 0, 302, 86)];
        [self addElement:borderImageView];
        [borderImageView setImage:@"g_sc_border-2" ofType:@"png"];
        [borderImageView release];
        
        GLImageView *backgroundImageView1 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 3, 296, 40)];
                [backgroundImageView1 setImage:@"g_sc_bkg-downRound" ofType:@"png"];
        [self addElement:backgroundImageView1];
        
        GLImageView *backgroundImageView2 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 43, 296, 40)];
        [backgroundImageView2 setImage:@"g_sc_bkg-topRound" ofType:@"png"];
        [self addElement:backgroundImageView2];
        
        GLImageView *backgroundImageView3 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 43, 296, 2)];
        [backgroundImageView3 setImage:@"g_sc_hSeparator" ofType:@"png"];
        [self addElement:backgroundImageView3];
        
        
        [backgroundImageView1 release];
        [backgroundImageView2 release];
        
        GLTextField *textField1 = [[GLTextField alloc]initWithFrame:CGRectMake(46, 3, 253, 40)];
        [self addElement:textField1];
        [textFields insertObject:textField1 atIndex:0];
        [textField1 release];
        textField1.tag = 1;
        [textField1 addTarget:self andSelector:@selector(textFieldReturnPressed:)
                    forEvent:GLTextFieldReturn];
        
        GLTextField *textField2 = [[GLTextField alloc]initWithFrame:CGRectMake(46, 43, 253, 40)];
        [self addElement:textField2];
        [textFields insertObject:textField2 atIndex:0];
        [textField2 release];
        textField2.tag = 0;
        [textField2 addTarget:self andSelector:@selector(textFieldReturnPressed:)
                    forEvent:GLTextFieldReturn];
        
        titleLabel = [[GLLabel alloc]initWithFrame:CGRectMake(5, 90, 320, 24)];
        [self addElement:titleLabel];
        [titleLabel setFont:@"Lato-Bold" withSize:20];
        [titleLabel setTextColor:Color4BFromHex(0x000000ff)];
        [titleLabel setFrameBackgroundColor:Color4BFromHex(0xffffff00)];
        [titleLabel release];
        
        
    }
    else if (numberOfFields == 3)
    {
        borderImageView = [[GLImageView alloc]initWithFrame:CGRectMake(0
                                                                           , 0, 302, 126)];
        [self addElement:borderImageView];
        [borderImageView setImage:@"g_sc_border-3" ofType:@"png"];
        [borderImageView release];
        
        GLImageView *backgroundImageView1 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 3, 296, 40)];
                [backgroundImageView1 setImage:@"g_sc_bkg-downRound" ofType:@"png"];
        [self addElement:backgroundImageView1];
        
        GLImageView *backgroundImageView2 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 43, 296, 40)];
                [backgroundImageView2 setImage:@"g_sc_bkg-noneRound" ofType:@"png"];
        [self addElement:backgroundImageView2];
        
        GLImageView *backgroundImageView3 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 83, 296, 40)];
                [backgroundImageView3 setImage:@"g_sc_bkg-topRound" ofType:@"png"];
        [self addElement:backgroundImageView3];
        
        GLImageView *backgroundImageView4 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 43, 296, 2)];
        [backgroundImageView4 setImage:@"g_sc_hSeparator" ofType:@"png"];
        [self addElement:backgroundImageView4];
        
        GLImageView *backgroundImageView5 = [[GLImageView alloc]initWithFrame:CGRectMake(3, 83, 296, 2)];
        [backgroundImageView5 setImage:@"g_sc_hSeparator" ofType:@"png"];
        [self addElement:backgroundImageView5];
        
        [backgroundImageView1 release];
        [backgroundImageView2 release];
        [backgroundImageView3 release];
        
        GLTextField *textField1 = [[GLTextField alloc]initWithFrame:CGRectMake(46, 3, 253, 40)];
        [self addElement:textField1];
        [textField1 release];
        [textFields insertObject:textField1 atIndex:0];
        [textField1 release];
        textField1.tag = 2;
        [textField1 addTarget:self andSelector:@selector(textFieldReturnPressed:)
                    forEvent:GLTextFieldReturn];
        
        GLTextField *textField2 = [[GLTextField alloc]initWithFrame:CGRectMake(46, 43, 253, 40)];
        [self addElement:textField2];
        [textField2 release];
        [textFields insertObject:textField2 atIndex:0];;
        [textField2 release];
        textField2.tag = 1;
        [textField2 addTarget:self andSelector:@selector(textFieldReturnPressed:)
                    forEvent:GLTextFieldReturn];
        
        GLTextField *textField3 = [[GLTextField alloc]initWithFrame:CGRectMake(46, 83, 253, 40)];
        [self addElement:textField3];
        [textField3 release];
        [textFields insertObject:textField3 atIndex:0];;
        [textField3 release];
        textField3.tag = 0;
        [textField3 addTarget:self andSelector:@selector(textFieldReturnPressed:)
                    forEvent:GLTextFieldReturn];
        
        titleLabel = [[GLLabel alloc]initWithFrame:CGRectMake(5, 130, 320, 24)];
        [self addElement:titleLabel];
        [titleLabel setFont:@"Lato-Bold" withSize:20];
        [titleLabel setTextColor:Color4BFromHex(0x000000ff)];
        [titleLabel setFrameBackgroundColor:Color4BFromHex(0xffffff00)];
        [titleLabel release];
        
    }
}

-(void)beginEditingTextFieldAtIndex:(int)index
{
    GLTextField *glTextField = textFields[index];
    [glTextField.textField becomeFirstResponder];

}

-(void)textFieldReturnPressed:(GLTextField *)textField
{
    if (textField.tag < textFields.count - 1)
    {
        GLTextField *glTextField = textFields[textField.tag+1];
        [glTextField.textField becomeFirstResponder];
    }
    else
    {
        if (target[GLTextFieldSetChangeFieldSet])
        {
            [target[GLTextFieldSetChangeFieldSet] performSelector:selector[GLTextFieldSetChangeFieldSet] withObject:self];
        }
    }
}

-(void)setTitle:(NSString *)title
{
    [titleLabel setText:title withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
}

-(void)setPlaceholder:(NSString *)string atIndex:(int)index
{
    if (index >= textFields.count || index < 0)
        return;
    
    GLTextField *tField = textFields[index];
    [tField.textField setPlaceholder:string];
}

-(NSString *)getStringAtIndex:(int)index
{
    if (index >= textFields.count || index < 0)
        return @"";
    
    GLTextField *tField = textFields[index];
    return tField.text;
}
-(void)setImageName:(NSString *)imageName OfType:(NSString *)type AtIndex:(int)index
{
    if (index >= textFields.count || index < 0)
        return;
    
    int tagc = 100 + index;
    
    Texture2D *texture = [Texture2D getTextureWithName:imageName OfType:type];
    
    GLImageView *imageView = (GLImageView *)[self getElementByTag:tagc];
    if (imageView == nil)
    {
        imageView = [[GLImageView alloc]initWithFrame:CGRectMake(3 + 23 - 12, 3 + 40 * (textFields.count - index - 1) + 20 - 12, 24, 24)];
        imageView.tag = tagc;
        [self addElement:imageView];
        [imageView release];
        [imageView setTexture:texture];
    }
    [texture release];
}

-(void)addTarget:(NSObject *)_target andSelector:(SEL)selector
{
    
}

-(void)reset
{
    for (GLTextField *tField in textFields)
        [tField reset];
}

-(void)addTarget:(NSObject *)_target andSelector:(SEL)_selector forEvent:(GLTextFieldSetEvents)event
{
    if (event == GLTextFieldSetBeginEditing)
    {
        for (GLTextField *t in textFields)
            [t addTarget:_target andSelector:_selector forEvent:GLTextFieldBeginEditing];
    }
    else if (event == GLTextFieldSetEndEditing)
    {
        for (GLTextField *t in textFields)
            [t addTarget:_target andSelector:_selector forEvent:GLTextFieldEndEditing];
    }
    else
    {
        target[GLTextFieldSetChangeFieldSet] = _target;
        selector[GLTextFieldSetChangeFieldSet] = _selector;
    }
}

-(UITextField *)getUITextFieldAtIndex:(int)index
{
    if (index >= textFields.count || index < 0)
        return nil;
    GLTextField *tField = textFields[index];
    return tField.textField;
}

-(void)dealloc
{
    [textFields release];
    [super dealloc];
}

@end
