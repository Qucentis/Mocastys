//
//  NavigationButton.h
//  KBC
//
//  Created by Rakesh on 09/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLImageButton.h"

typedef enum
{
    NavigationButtonTypeBack = 0,
    NavigationButtonTypeDone,
    NavigationButtonTypeForward,
    NavigationButtonTypeSettings,
    NavigationButtonTypeList,
    NavigationButtonTypeAdd,
    NavigationButtonTypeNewMessage,
    NavigationButtonTypeReply
}NavigationButtonType;

@interface NavigationButton : GLImageButton

@property (nonatomic) int buttonType;

@end
