//
//  CheckMark.h
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLImageView.h"

@interface CheckMark : GLElement
{
    GLImageView *uncheckedImageView;
    GLImageView *checkedImageView;
    BOOL isON;
}

-(void)setState:(BOOL)ON animated:(BOOL)animated;
@end
