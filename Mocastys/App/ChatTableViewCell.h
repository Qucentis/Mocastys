//
//  ChatTableViewCell.h
//  KBC
//
//  Created by Rakesh on 10/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLTableViewCell.h"
#import "GLImageButton.h"
#import "GLButton.h"
#import "CheckMark.h"
#import "GLLabel.h"


@interface ChatTableViewCell : GLTableViewCell
{
    GLLabel *lastNameLabel;
    GLLabel *dateLabel;
    GLImageView *photoView;
    GLElement *borderElement;
}

@property (nonatomic,readonly) GLLabel *lastNameLabel;
@property (nonatomic,readonly) GLLabel *dateLabel;
@property (nonatomic,readonly) GLImageView *photoView;
@end
