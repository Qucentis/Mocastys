//
//  FriendsListScene.m
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "FriendsListScene.h"
#import "DataManager.h"
#import "AppTheme.h"


@implementation FriendsListScene

@synthesize friendsList;

-(id)init
{
    if (self = [super init])
    {
        friendsListTable = [[GLTableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:friendsListTable];
        [friendsListTable release];
        
        NavigationButton *backImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(15, self.frame.size.height - 45, 30, 30)];
        [backImageButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        backImageButton.buttonType = NavigationButtonTypeBack;
        
        self.leftNavigationBarButton = backImageButton;
        
        [backImageButton release];
        
        NavigationButton *rightImageButton = [[NavigationButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 45, self.frame.size.height - 45, 30, 30)];
        [rightImageButton setImage:@"g_navBar_glyph-add" ofType:@"png"];
        rightImageButton.buttonType = NavigationButtonTypeAdd;
        
        self.rightNavigationBarButton = rightImageButton;
        [rightImageButton release];
        
        self.rightNavigationBarButtonColor = Color4BFromHex(0x0);
        
        
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
    if (friendsListTable.numberOfRows != self.friendsList.count)
        [friendsListTable reloadData:NO];
    friendsListTable.originInsideElement = CGPointMake(0, 0);
    [friendsListTable update];
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

-(NSString *)strippedPhoneNumber:(NSString *)number
{
    NSString *originalString = number;
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:originalString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
}


-(GLTableViewCell *)cellForRowAtIndex:(int)index
{
    FriendsTableViewCell *cell = (FriendsTableViewCell *)[friendsListTable dequeueCell];
    if (cell == nil)
    {
        cell = [[FriendsTableViewCell alloc]init];
        cell.checkMark.hidden = NO;
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
    
    
    return cell;
}

-(void)rightBarButtonClicked
{
    [self showContacts:self];
}

- (IBAction)showContacts:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [director.openGLViewController presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [director.openGLViewController dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [director.openGLViewController dismissModalViewControllerAnimated:YES];
    ABRecordID recordID = ABRecordGetRecordID(person);
    
    id emailRecords = ABRecordCopyValue(person, kABPersonEmailProperty);
    int emailCount = ABMultiValueGetCount(emailRecords);
    
    NSMutableArray *searchArray = [[NSMutableArray alloc]init];
  
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc]init];
    NSMutableArray *emails = [[NSMutableArray alloc]init];
    
    self.addressBookFriendFirstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    self.addressBookFriendLastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    self.addressBookRecordID = recordID;
    
    for (int i = 0;i<emailCount;i++)
    {
        [emails addObject:ABMultiValueCopyValueAtIndex(emailRecords, i)];
    }
    
    id phoneRecords = ABRecordCopyValue(person, kABPersonPhoneProperty);
    int phoneCount = ABMultiValueGetCount(phoneRecords);
    
    for (int i = 0;i<phoneCount;i++)
    {
        [phoneNumbers addObject:[self strippedPhoneNumber:ABMultiValueCopyValueAtIndex(phoneRecords, i)]];
    }
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:emails,@"emails",phoneNumbers,@"phones", nil];
    
  //  [self.openGLView.activityIndicator startAnimating];
    Server *server = [Server sharedServer];
    [server findUsers:dictionary withCompletionBlock:^(NSArray *responseArray, NSArray *errors) {
 //       [self.openGLView.activityIndicator stopAnimating];
        if (errors == nil)
        {
            if (responseArray.count > 0)
            {
                for (NSDictionary *dictionary in responseArray)
                {
                    Friend *friend = [[Friend alloc]init];
                    friend.recordID = self.addressBookRecordID;
                    friend.firstName = self.addressBookFriendFirstName;
                    friend.lastName = self.addressBookFriendLastName;
                    friend.username = dictionary[@"username"];
                    friend.email = dictionary[@"email"];
                    friend.phoneNo = dictionary[@"phone"];
                    
                    [searchArray addObject:friend];
                    [friend release];
                }
                self.appDelegate.verifyScene.friendsList = searchArray;
                [self.appDelegate moveMainPage:10];
                [searchArray release];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"User not found!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
    
    }];
    
    return NO;
}

-(void)reloadData
{
    [friendsListTable reloadData:NO];
}

-(void)cellSelected:(GLTableViewCell *)cell
{
    
}


@end
