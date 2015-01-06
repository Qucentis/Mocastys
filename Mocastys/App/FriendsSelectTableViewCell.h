//
//  FriendsSelectTableViewCell.h
//  KBC
//
//  Created by Rakesh on 11/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLTableViewCell.h"
#import "GLImageButton.h"
#import "GLButton.h"
#import "CheckMark.h"
#import "GLLabel.h"

@interface FriendsSelectTableViewCell : GLTableViewCell
{
    GLLabel *nameLabel;
    GLImageView *photoView;
    CheckMark *checkMark;
    GLElement *borderElement;

}
@property (nonatomic,readonly) CheckMark *checkMark;
@property (nonatomic,readonly) GLLabel *nameLabel;
@property (nonatomic,readonly) GLImageView *photoView;

@end