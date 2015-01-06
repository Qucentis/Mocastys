//
//  KBC
//
//  Created by Rakesh on 30/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLTextField.h"
#import "AppTheme.h"

@implementation UITextField (Swipeable)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.superview touchesBegan:touches withEvent:event];
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self.superview touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.superview touchesEnded:touches withEvent:event];
} 


@end

@implementation GLTextField

@synthesize textField;
@synthesize text;


-(id)init
{
    if (self = [super init])
    {
        [self setupControl];
    }
    return self;
}

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        [self setupControl];
    }
    return self;
}


-(void)setupControl
{
    CGRect absFrame1 = [self absoluteFrame];
    
    CGPoint parentOrigin = [self.parent absoluteFrame].origin;
    
    textField = [[UITextField alloc]initWithFrame:
                 CGRectMake(absFrame1.origin.x, self.openGLView.frame.size.height - absFrame1.origin.y - absFrame1.size.height, absFrame1.size.width, absFrame1.size.height)];
    
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.tag = 1;
    textField.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    textField.frame = CGRectOffset(textField.frame, parentOrigin.x, parentOrigin.y);
}

- (Texture2D *) imageFromView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [[Texture2D alloc]initWithImage:img];
}

-(void)removeTextFields
{
    [textField removeFromSuperview];
    [textField release];
    textField = nil;
}


-(void)update
{
    
    CGRect absFrame1 = [self absoluteFrame];
    
    CGRect intersect = CGRectIntersection(absFrame1,CGRectMake(0, 0, self.openGLView.frame.size.width,
                                                               self.openGLView.frame.size.height));
    if (intersect.size.width != 0 && intersect.size.height != 0)
    {
        if (textField.superview == nil)
            [self.openGLView addSubview:textField];
    }
    else
    {
        if (willDisappear)
        {
            [textField removeFromSuperview];
        }
    }
    
    textField.frame = CGRectMake(absFrame1.origin.x, self.openGLView.frame.size.height - absFrame1.origin.y - absFrame1.size.height, absFrame1.size.width, absFrame1.size.height);
    
}

-(void)elementWillDisappear
{
    [super elementWillDisappear];
    willDisappear = YES;
    [textField resignFirstResponder];
}


-(void)elementDidDisappear
{
    [textField removeFromSuperview];
}

-(void)elementWillAppear
{
    [super elementWillAppear];
    willDisappear = NO;
}

-(void)resignKeyboard
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    if (target[GLTextFieldReturn] != nil)
        [target[GLTextFieldReturn] performSelector:selector[GLTextFieldReturn] withObject:self];
    
    return YES;
}

-(void)textFieldDidChange:(id)sender
{
    if (target[GLTextFieldChangedText] != nil)
        [target[GLTextFieldChangedText] performSelector:selector[GLTextFieldChangedText] withObject:self];
    self.text = textField.text;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (target[GLTextFieldBeginEditing] != nil)
        [target[GLTextFieldBeginEditing] performSelector:selector[GLTextFieldBeginEditing] withObject:self];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (target[GLTextFieldEndEditing] != nil)
        [target[GLTextFieldEndEditing] performSelector:selector[GLTextFieldEndEditing] withObject:self];
}





-(void)reset
{
    textField.text = @"";
    self.text = @"";
}

-(void)addTarget:(NSObject *)_object andSelector:(SEL)_selector
        forEvent:(GLTextFieldEvents)event;
{
    target[event] = _object;
    selector[event] = _selector;
}

-(void)dealloc
{
    [textField removeFromSuperview];
    [textField release];
    [super dealloc];
}

@end
