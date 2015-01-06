//
//  FriendsSelectScene.h
//  KBC
//
//  Created by Rakesh on 11/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLScene.h"
#import "GLTableView.h"
#import "GLImageButton.h"
#import "GLButton.h"
#import "FriendsSelectTableViewCell.h"
#import "AppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>
#import "Friend.h"

@interface FriendsSelectScene : GLScene<GLTableViewDataSource,GLTableViewDelegate>
{
    NSMutableArray *friendsList;
    GLTableView *friendsListTable;
    GLImageButton *navBarButton;
    GLImageButton *sendButton;
    
    BOOL *rowIsChecked;
    BOOL animate;
}

@property (nonatomic,retain) NSMutableArray *friendsList;
@property (nonatomic,retain) NSString *addressBookFriendFirstName;
@property (nonatomic,retain) NSString *addressBookFriendLastName;
@property (nonatomic) int addressBookRecordID;

-(void)reloadData;
@end
