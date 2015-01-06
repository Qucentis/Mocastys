//
//  FriendsListScene.h
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLScene.h"
#import "GLTableView.h"
#import "GLImageButton.h"
#import "GLButton.h"
#import "FriendsTableViewCell.h"
#import "AppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>
#import "Friend.h"

@interface FriendsListScene : GLScene <GLTableViewDataSource,GLTableViewDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    NSMutableArray *friendsList;
    GLTableView *friendsListTable;
    GLImageButton *navBarButton;
    GLImageButton *sendButton;
    
    BOOL animate;
}

@property (nonatomic,retain) NSMutableArray *friendsList;
@property (nonatomic,retain) NSString *addressBookFriendFirstName;
@property (nonatomic,retain) NSString *addressBookFriendLastName;
@property (nonatomic) int addressBookRecordID;

-(void)reloadData;
@end
