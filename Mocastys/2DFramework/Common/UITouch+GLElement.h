//
//  UITouch+UITouch_GLElement.h
//  Dabble
//
//  Created by Rakesh on 31/05/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLElement;

@interface UITouch (UITouch_GLElement)
-(CGPoint)locationInGLElement:(GLElement *)element;
@end
