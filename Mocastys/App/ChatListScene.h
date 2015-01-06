//
//  ChatListScene.h
//  KBC
//
//  Created by Rakesh on 06/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLScene.h"
#import "GLTableView.h"
#import "GLImageButton.h"
#import "AppDelegate.h"

@interface ChatListScene : GLScene <GLTableViewDataSource,GLTableViewDelegate>
{
    GLTableView *chatListTable;
    GLImageButton *navBarButton;
    GLImageButton *composeButton;
    GLImageButton *settingsButton;
    GLImageButton *friendsButton;
    NSMutableArray *imagesArray;
    NSMutableArray *friendsWithMessages;
    BOOL threadStarted;
    
}

@property (nonatomic,retain) GLTableView *chatListTable;
@property (nonatomic,retain)     NSDate *lastUpdateTime;
@end
