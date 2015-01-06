//
//  FriendsSelectScene.m
//  KBC
//
//  Created by Rakesh on 11/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "FriendsSelectScene.h"
#import "DataManager.h"
#import "AppTheme.h"
#import "AppDelegate.h"

@implementation FriendsSelectScene

@synthesize friendsList;

-(id)init
{
    if (self = [super init])
    {
        friendsListTable = [[GLTableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:friendsListTable];
        [friendsListTable release];
        
        
        if (rowIsChecked != NULL)
            free(rowIsChecked);
        rowIsChecked = calloc(20000,sizeof(BOOL));
        
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        backImageButton.buttonType = NavigationButtonTypeBack;
        
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];
        
        NavigationButton *rightImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 30, 30)];
        [rightImageButton setImage:@"g_navBar_glyph-done" ofType:@"png"];
        rightImageButton.buttonType = NavigationButtonTypeDone;
        
        self.rightNavigationBarButton = rightImageButton;
        [rightImageButton release];
        
        self.rightNavigationBarButtonColor = greenNavigationBarButtonColor;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (loggedIn:)
                                                     name:@"userLoggedIn" object:nil];
        
        
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [friendsListTable addElement:logoImageView];
        [logoImageView release];
    }
    return self;
}



-(void)leftBarButtonClicked
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate moveMainPage:1];
}

-(void)loggedIn:(NSNotification *)notification
{
    self.friendsList = [DataManager sharedDataManager].friends;
    friendsListTable.dataSource = self;
    friendsListTable.delegate = self;
    [friendsListTable reloadData:NO];
}

-(void)sceneWillAppear
{
    memset(rowIsChecked, 0, sizeof(10000*sizeof(BOOL)));
    if (friendsListTable.numberOfRows != self.friendsList.count)
        [friendsListTable reloadData:NO];
    else
    {
        friendsListTable.originInsideElement = CGPointMake(0, 0);
        [friendsListTable update];
        [friendsListTable refreshData];
    }
}

-(CGFloat)heightOfRow
{
    return 42;
}

-(int)numberOfRows
{
    return friendsList.count;
}

-(void)sceneWillDisappear
{
}

-(void)sceneDidDisappear
{
    
}

-(GLTableViewCell *)cellForRowAtIndex:(int)index
{
    FriendsSelectTableViewCell *cell = (FriendsSelectTableViewCell *)[friendsListTable dequeueCell];
    if (cell == nil)
    {
        cell = [[FriendsSelectTableViewCell alloc]init];
        cell.checkMark.acceptsTouches = NO;
    }
    
    Friend *friend = friendsList[index];
    NSString *concat = [[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ((friend.firstName == nil && friend.lastName == nil) || [concat isEqualToString:@""])
        concat = friend.username;
    else if (friend.firstName == nil)
        concat = friend.lastName;
    else if (friend.lastName == nil)
        concat = friend.firstName;
    
    cell.photoView.usesTextureManager = YES;
    [cell.photoView setImage:@"fsl_cell_facePlaceholder"ofType:@"png"];
    
    
    [cell.nameLabel setText:concat withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    
    [cell.checkMark setState:rowIsChecked[index] animated:NO];
    
    return cell;
}

-(void)showCompose
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate moveComposePage:0];
}

-(BOOL)getSelectedFriends
{
    NSMutableArray *friends = nil;
    if (friendsList != nil)
        friends = [[NSMutableArray alloc]init];
    [DataManager sharedDataManager].selectedUsers = friends;
    
    if (friends == nil)
        return NO;
    
    for (int i = 0;i<friendsList.count;i++)
    {
        if (rowIsChecked[i])
        {
            [friends addObject:[(Friend *)friendsList[i] username]];
        }
    }

    if (friends.count == 0)
        return NO;
    
    [friends release];
    return YES;
}

-(void)showChats
{
    
}

-(void)cellSelected:(GLTableViewCell *)cell
{
    FriendsSelectTableViewCell *fCell = (FriendsSelectTableViewCell *)cell;
    rowIsChecked[cell.rowIndex] = !rowIsChecked[cell.rowIndex];
    [fCell.checkMark setState:rowIsChecked[cell.rowIndex] animated:YES];
}

-(void)rightBarButtonClicked
{
    if ([self getSelectedFriends])
        [self.appDelegate moveComposePage:1];
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"No users were selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}



-(void)reloadData
{
    [friendsListTable reloadData:NO];
}

@end
