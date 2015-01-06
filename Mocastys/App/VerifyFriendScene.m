//
//  VerifyFriendScreen.m
//  KBC
//
//  Created by Rakesh on 03/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "VerifyFriendScene.h"
#import "AppDelegate.h"
#import "GLLabel.h"
#import "UIImage+UIImage_RoundedMask.h"
#import <AddressBook/AddressBook.h>
#import "AppTheme.h"
#import "DataManager.h"

@implementation VerifyFriendScene

@synthesize friendsList;
-(id)init
{
    if (self = [super init])
    {
        friendsListTable = [[GLTableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addElement:friendsListTable];
        [friendsListTable release];
        
        NavigationButton *backButton = [[NavigationButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.leftNavigationBarButton = backButton;
        [backButton setImage:@"g_navBar_glyph-back" ofType:@"png"];
        [backButton release];
        self.leftNavigationBarButtonColor = Color4BFromHex(0x0);
        
        GLImageView *logoImageView = [[GLImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 20, self.frame.size.height - 47, 40, 40)];
        [logoImageView setImage:@"g_logo-simple" ofType:@"png"];
        [friendsListTable addElement:logoImageView];
        [logoImageView release];
        
    }
    return self;
}


-(void)leftBarButtonClicked
{
    self.acceptsTouches = YES;
    [self.appDelegate moveMainPage:7];
}

-(void)sceneWillAppear
{
   friendsListTable.dataSource = self;
   friendsListTable.delegate = self;
    [friendsListTable reloadData:NO];
}


-(void)sceneWillDisappear
{
    
}

-(int)numberOfRows
{
    return friendsList.count;
}

-(CGFloat)heightOfRow
{
    return 50;
}

Friend *selectedFriend;

-(void)cellSelected:(GLTableViewCell *)cell
{
    Friend *friend = (Friend *)[self.friendsList objectAtIndex:cell.rowIndex];
    selectedFriend = friend;
    DataManager *dataManager = [DataManager sharedDataManager];
    if ([dataManager findFriendWithUsername:friend.username] == nil)
    {
        self.acceptsTouches = NO;
        DataManager *dataManager = [DataManager sharedDataManager];
        [dataManager addFriend:friend];
        [dataManager saveDataToArchive];
        [self.appDelegate.friendsScene reloadData];
        [self performSelector:@selector(leftBarButtonClicked) withObject:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Information" message:@"User already added! Do you want to replace the current user information! All messages will be retained." delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        alertView.delegate = self;
        [alertView show];
        [alertView release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DataManager *dataManager = [DataManager sharedDataManager];
    if (buttonIndex == 0)
    {
        
    }
    else
    {
        Friend *exisitingFriend = [dataManager findFriendWithUsername:selectedFriend.username];
       // ABRecordRef person = ABAddressBookGetPersonWithRecordID(ABAddressBookCreate(),
         //                                                       selectedFriend.recordID);
        exisitingFriend.firstName = selectedFriend.firstName;
        exisitingFriend.lastName = selectedFriend.lastName;
        DataManager *dataManager = [DataManager sharedDataManager];
        [dataManager saveDataToArchive];

        [self performSelector:@selector(leftBarButtonClicked) withObject:nil];
    }
    
    [self.appDelegate.friendsScene reloadData];
    [self performSelector:@selector(leftBarButtonClicked) withObject:nil];
}
/*
-(void)createRoundedImages:(Friend *)friend
{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(ABAddressBookCreate(), friend.recordID);
    if (ABPersonHasImageData(person))
    {
        NSData *imageData = (NSData *) ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail);
        UIImage *contactImage = [UIImage imageWithData:imageData];
        UIImage *roundedImage = [contactImage getRoundedImageWithRect:CGRectMake(0, 0, contactImage.size.width, contactImage.size.height)];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
  
        NSString *hash = [NSString stringWithFormat:@"%d%ld",[roundedImage hash],random()];
        
        friend.imagePath = [documentsPath stringByAppendingPathComponent:
                            [NSString stringWithFormat:@"%@",hash]];
        
        NSString *filePathThumbnail1 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@50x50.png",hash]]; //Add the file name
        [UIImagePNGRepresentation([roundedImage createThumbnailOfSize:CGSizeMake(50, 50)]) writeToFile:filePathThumbnail1 atomically:YES];
        
        NSString *filePathThumbnail2 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@50x50@2x.png",hash]]; //Add the file name
        [UIImagePNGRepresentation([roundedImage createThumbnailOfSize:CGSizeMake(100, 100)]) writeToFile:filePathThumbnail2 atomically:YES];
        
        
        NSString *filePathThumbnail3 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",hash]]; //Add the file name
        [UIImagePNGRepresentation([roundedImage createThumbnailOfSize:CGSizeMake(128, 128)]) writeToFile:filePathThumbnail3 atomically:YES];
        
        NSString *filePathThumbnail4 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png",hash]]; //Add the file name
        [UIImagePNGRepresentation([roundedImage createThumbnailOfSize:CGSizeMake(256, 256)]) writeToFile:filePathThumbnail4 atomically:YES];
    }
 
}
*/

-(GLTableViewCell *)cellForRowAtIndex:(int)index
{
    GLTableViewCell *cell = [friendsListTable dequeueCell];
    GLLabel *nameLabel;
    GLLabel *userDataLabel;
    if (cell == nil)
    {
        
        cell = [[GLTableViewCell alloc]init];
        nameLabel = [[GLLabel alloc]initWithFrame:CGRectMake(20, 25, 200, 22)];
        nameLabel.tag = 1;
        [cell addElement:nameLabel];
        [nameLabel setFont:@"Lato-Bold" withSize:15];
        [nameLabel setTextColor:(Color4B){0,0,0,255}];
        nameLabel.originInsideElement = CGPointMake(5, 0);
        [nameLabel release];
        
        userDataLabel = [[GLLabel alloc]initWithFrame:CGRectMake(20, 5, 200, 22)];
        userDataLabel.tag = 2;
        [cell addElement:userDataLabel];
        [userDataLabel setFont:@"Lato-Bold" withSize:15];
        [userDataLabel setTextColor:(Color4B){0,0,0,255}];
        userDataLabel.originInsideElement = CGPointMake(5, 0);
        [userDataLabel release];
        
        GLElement *borderElement = [[GLElement alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
        [cell addElement:borderElement];
        [borderElement setFrameBackgroundColor:Color4BFromHex(0x00000055)];
        [borderElement release];
        cell.frameBackgroundColor = Color4BFromHex(0xffffff25);
        
        
    }
    else
    {
        nameLabel = (GLLabel *)[self getElementByTag:1];
        userDataLabel = (GLLabel *)[self getElementByTag:2];
    }
    Friend *friend = friendsList[index];
    
    NSString *concat = [[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (friend.firstName == nil)
        concat = friend.lastName;
    else if (friend.lastName == nil)
        concat = friend.firstName;
    
    [nameLabel setText:[NSString stringWithFormat:@"Name: %@",concat] withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    
    [userDataLabel setText:[NSString stringWithFormat:@"Username: %@",friend.username] withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    
    return cell;
}

@end
