//
//  VerifyFriendScreen.h
//  KBC
//
//  Created by Rakesh on 03/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLScene.h"
#import "GLTableView.h"
#import "GLImageButton.h"
#import "GLButton.h"
#import "Friend.h"

@interface VerifyFriendScene : GLScene <GLTableViewDataSource,GLTableViewDelegate,UIAlertViewDelegate>
{
    GLTableView *friendsListTable;
    GLImageButton *navBarButton;
    NSMutableArray *friendsList;
}

@property (nonatomic,retain) NSMutableArray *friendsList;

@end
