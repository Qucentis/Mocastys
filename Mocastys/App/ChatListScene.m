//
//  ChatListScene.m
//  KBC
//
//  Created by Rakesh on 06/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "ChatListScene.h"
#import "Server.h"
#import "DataManager.h"
#import "ChatTableViewCell.h"
#import "AppTheme.h"
#import "TTTTimeIntervalFormatter.h"


@implementation ChatListScene

@synthesize chatListTable;

-(id)init
{
    if (self = [super init])
    {
        self.lastUpdateTime = [NSDate date];
        chatListTable = [[GLTableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:chatListTable];
        [chatListTable release];
        [chatListTable setDataSource:self];
        [chatListTable setDelegate:self];
        
        NavigationButton *settingsImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [settingsImageButton setImage:@"g_navBar_glyph-settings" ofType:@"png"];
        settingsImageButton.buttonType = NavigationButtonTypeSettings;
        
        self.leftNavigationBarButton = settingsImageButton;
        
        [settingsImageButton release];
        
        NavigationButton *rightImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 30, 30)];
        [rightImageButton setImage:@"g_navBar_glyph-list" ofType:@"png"];
        rightImageButton.buttonType = NavigationButtonTypeList;
        
        self.rightNavigationBarButton = rightImageButton;
        [rightImageButton release];
        
        self.rightNavigationBarButtonColor = Color4BFromHex(0x0);
        
        NavigationButton *actionImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 93, 93)];
        [actionImageButton setImage:@"g_actionButton_glyph-logo" ofType:@"png"];
        actionImageButton.buttonType = NavigationButtonTypeNewMessage;
        
        self.actionBarButton = actionImageButton;
        [actionImageButton release];
        
        self.actionBarButtonColor = Color4BFromHex(0x0);
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [chatListTable addElement:logoImageView];
        [logoImageView release];
        
        timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableRefresh:) name:@"DisableUpdateNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRefresh:) name:@"EnableUpdateNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"userLoggedIn" object:nil];
        
    }
    
    return self;
}

-(void)reloadData:(NSNotification *)notification
{
    [chatListTable reloadData:NO];
}

-(void)enableRefresh:(NSNotification *)notification
{
    [self performSelector:@selector(readMessages) withObject:nil afterDelay:0.2];
}

-(void)disableRefresh:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(readMessages)
                                               object:nil];
}

-(void)leftBarButtonClicked
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(readMessages)
                                               object:nil];
    [self.appDelegate moveMainPage:4];
}

-(void)rightBarButtonClicked
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(readMessages)
                                               object:nil];
    [self.appDelegate moveMainPage:7];
}

-(void)actionBarButtonClicked
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(readMessages)
                                               object:nil];
    [self.appDelegate moveMainPage:2 andComposePage:0];
}

int markAsReadCount = 0;

-(void)readMessages
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(readMessages)
                                               object:nil];
    
    self.acceptsTouches = NO;
    Server *server = [Server sharedServer];
    [server receiveMessagesWithCompletionBlock:^(NSArray *data,NSArray *error)
     {
         [self refreshListOfMessages];
         markAsReadCount = 0;
         if (data.count == 0)
         {
             [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                      selector:@selector(readMessages)
                                                        object:nil];
             [self performSelector:@selector(readMessages) withObject:nil afterDelay:10];
         }
         NSMutableArray *messages = [[NSMutableArray alloc]init];
         for (Message *m in data)
         {
             [messages addObject:m.messageID];
         }
         [server markMessagesListAsRead:messages withCompletionBlock:
          ^(NSDictionary *responseData,NSArray *errors)
          {
              if (errors == nil)
              {
                  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                           selector:@selector(readMessages)
                                                             object:nil];
                  [self performSelector:@selector(readMessages) withObject:nil afterDelay:10];
              }
              else
              {
                  
              }
          }];
         /*
          markAsReadCount++;
          [server markMessageAsRead:m.messageID withCompletionBlock:
          ^(NSDictionary *responseData,NSArray *errors)
          {
          markAsReadCount --;
          if (markAsReadCount <= 0)
          {
          [NSObject cancelPreviousPerformRequestsWithTarget:self
          selector:@selector(readMessages)
          object:nil];
          [self performSelector:@selector(readMessages) withObject:nil afterDelay:10];
          }
          }
          ];*/
         self.acceptsTouches = YES;
     }];
}



-(void)refreshListOfMessages
{
    if (!friendsWithMessages)
        friendsWithMessages = [[NSMutableArray alloc]init];
    else
        [friendsWithMessages removeAllObjects];
    
    DataManager *dataManager = [DataManager sharedDataManager];
    for (Friend *friend in dataManager.friends)
    {
        if (friend.messages.count > 0)
        {
            [friendsWithMessages addObject:friend];
        }
    }
    
    [friendsWithMessages sortUsingComparator:^NSComparisonResult(Friend *f1,Friend *f2)
     {
         NSComparisonResult result = [f1.lastMessageTime compare:f2.lastMessageTime];
         if (result == NSOrderedDescending)
             return NSOrderedAscending;
         else if (result == NSOrderedAscending)
             return NSOrderedDescending;
         else
             return NSOrderedSame;
     }];
    
    [NSNotificationCenter defaultCenter];
    NSNotification* notification = [NSNotification notificationWithName:@"MessagesUpdatedNotification" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if (!self.hidden)
        [chatListTable reloadData:NO];
}


-(void)sceneWillAppear
{
//    [chatListTable animate];
}



-(void)sceneDidAppear
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(readMessages)
                                               object:nil];
    [self performSelector:@selector(readMessages) withObject:nil afterDelay:0.2];
    
}

-(void)showFriends
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate moveMainPage:2 andComposePage:1];
}

-(void)showCompose
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate moveMainPage:2 andComposePage:0];
}

TTTTimeIntervalFormatter *timeIntervalFormatter;

-(GLTableViewCell *)cellForRowAtIndex:(int)index
{
    ChatTableViewCell *tableViewCell = (ChatTableViewCell *)[chatListTable dequeueCell];
    
    if (tableViewCell == nil)
    {
        tableViewCell = [[ChatTableViewCell alloc]init];
    }
    Friend *friend = friendsWithMessages[index];
    
    tableViewCell.photoView.usesTextureManager = YES;
    [tableViewCell.photoView setImage:@"ml_cell_facePlaceholder"ofType:@"png"];
    NSString *info = [NSString stringWithFormat:@"%@ | %d message",[timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:friend.lastMessageTime],friend.messages.count];
    if (friend.messages.count > 1)
        info = [info stringByAppendingString:@"s"];
    [tableViewCell.dateLabel setText:info            withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    
    
    NSString *concat = [[NSString stringWithFormat:@"%@ %@",friend.firstName,friend.lastName]
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ((friend.firstName == nil && friend.lastName == nil) || [concat isEqualToString:@""])
        [tableViewCell.lastNameLabel setText:[NSString stringWithFormat:@"%@",friend.username]
                     withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    else if (friend.firstName == nil)
        [tableViewCell.lastNameLabel setText:friend.lastName
                     withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    else if (friend.lastName == nil)
        [tableViewCell.lastNameLabel setText:friend.firstName
                     withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    else
        [tableViewCell.lastNameLabel setText:concat
                     withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    
    return tableViewCell;
}



-(int)numberOfRows
{
    return friendsWithMessages.count;
}
-(CGFloat)heightOfRow
{
    return 82;
}

-(void)deleteRowsFromDataSource:(NSMutableIndexSet *)indexSet
{
    //    [imagesArray removeObjectsAtIndexes:indexSet];
}

-(void)cellSelected:(GLTableViewCell *)cell
{
    Friend *friend = (Friend *)friendsWithMessages[cell.rowIndex];
    [self.appDelegate.messageScene setFriend:friend];
    //    [self.appDelegate.messageScene setType:1];
    [self.appDelegate moveMainPage:3];
}

-(void)update
{
    [super update];
    int seconds = fabs([self.lastUpdateTime timeIntervalSinceNow]);
    if (seconds > 1)
    {
        BOOL changed = NO;
        self.lastUpdateTime = [NSDate date];
        NSArray *messages = [DataManager sharedDataManager].openedMessages;
        for (int i = 0;i < messages.count;i++)
        {
            Message *m = messages[i];
            int s = fabs([m.timeOpened timeIntervalSinceNow]);
            if (s >= m.duration)
            {
                [[DataManager sharedDataManager]deleteMessage:m];
                changed = YES;
                i--;
            }
        }
        if (changed)
        {
            [[DataManager sharedDataManager]saveDataToArchive];
            [self refreshListOfMessages];
        }
    }
}

@end
