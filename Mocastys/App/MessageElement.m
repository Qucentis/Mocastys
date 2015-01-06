//
//  MessageElement.m
//  KBC
//
//  Created by Rakesh on 12/12/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "MessageElement.h"
#import "GLElement.h"
#import "TTTTimeIntervalFormatter.h"

@implementation MessageElement

@synthesize message;

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        self.clipToBounds = YES;
        self.acceptsTouches = YES;
        self.frameBackgroundColor = Color4BFromHex(0xffffff44);
        
        photoView = [[GLImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [photoView setImage:@"fsl_cell_facePlaceholder" ofType:@"png"];
        [self addElement:photoView];
        photoView.acceptsTouches = NO;
        [photoView release];
        
        messageView = [[GLImageView alloc]initWithFrame:CGRectMake(15, 60, self.frame.size.width-30, self.frame.size.height-80)];
        [self addElement:messageView];
        messageView.originInsideElement = CGPointMake(0, -200);
        messageView.clipToBounds = YES;
        [messageView release];
        
        fromLabel = [[GLLabel alloc]initWithFrame:CGRectMake(45, 8, self.frame.size.width - 70, 26)];
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [fromLabel setFont:@"Lato-Light" withSize:15];
        }
        else
        {
            [fromLabel setFont:@"Lato-Light" withSize:11];
        }
        [fromLabel setTextColor:(Color4B){0,0,0,255}];
        fromLabel.originInsideElement = CGPointMake(5, 0);
        [self addElement:fromLabel];
        [fromLabel release];
        
        GLElement *borderElement = [[GLElement alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 2)];
        [self addElement:borderElement];
        [borderElement setFrameBackgroundColor:Color4BFromHex(0x00000055)];
        [borderElement release];
        
        timeLabel = [[GLButton alloc]initWithFrame:CGRectMake(0, 42, self.frame.size.width, self.frame.size.height-42)];
        [self addElement:timeLabel];
        [timeLabel setBackgroundColor:Color4BFromHex(0xffffff44)];
        [timeLabel setBackgroundHightlightColor:Color4BFromHex(0xffffff66)];
        [timeLabel release];
        [timeLabel addTarget:self andSelector:@selector(clicked)];
        
        [timeLabel setTextColor:Color4BFromHex(0xb14f1399)];
        [timeLabel setTextHighlightColor:Color4BFromHex(0xb14f1399)];
        
        timerElement = [[GLElement alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 5, 0, 5)];
        [self addElement:timerElement];
        [timerElement setFrameBackgroundColor:Color4BFromHex(0x000000ff)];
        [timerElement release];
        
        timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc]init];
        
    }
    return self;
}

-(void)clicked
{
    EasingAnimation *animation1 = (EasingAnimation *)[timeLabel moveOriginFrom:timeLabel.originOfElement To:CGPointMake(0, self.frame.size.height-46) withDuration:0.3 afterDelay:0 usingCurve:EasingOrdered];
    animation1.easingType = EaseOut;
    
    EasingAnimation *animation2 = (EasingAnimation *)[messageView moveOriginInsideFrom:messageView.originInsideElement To:CGPointMake(0, 0) withDuration:0.3 afterDelay:0 usingCurve:EasingOrdered];
    animation2.easingType = EaseOut;
    if (self.message.timeOpened == nil)
    {
        message.timeOpened = [NSDate date];
        [[DataManager sharedDataManager]openMessage:self.message];
        [[DataManager sharedDataManager]saveDataToArchive];
    }
}

- (NSInteger)binarySearchForFontSizeForText:(NSString *)text withMinFontSize:(NSInteger)minFontSize withMaxFontSize:(NSInteger)maxFontSize withSize:(CGSize)size
{
    // If the sizes are incorrect, return 0, or error, or an assertion.
    if (maxFontSize < minFontSize)
        return 0;
    
    // Find the middle
    NSInteger fontSize = maxFontSize;
    // Create the font
    
    // Create a constraint size with max height
    CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
    
    do {
        // Set current font size
        UIFont *font = [UIFont fontWithName:@"Lato-Italic" size:fontSize];
        
        // Find label size for current font size
        CGSize labelSize = [text sizeWithFont:font
                            constrainedToSize:constraintSize
                                lineBreakMode:NSLineBreakByWordWrapping];
        
        // Done, if created label is within target size
        if( labelSize.height < size.height )
            break;
        
        // Decrease the font size and try again
        fontSize -= 1;
        
    } while (fontSize >= minFontSize);
    
    return fontSize;
}

TTTTimeIntervalFormatter *timeIntervalFormatter;

-(void)setMessage:(Message *)_message
{
    if (message != nil)
        [message release];
    message = [_message retain];
    
    if (self.message.timeOpened != nil)
    {
        [[DataManager sharedDataManager]openMessage:self.message];
    }
    
    [animator removeRunningAnimationsForObject:timerElement ofType:ANIMATION_ELEMENT_CHANGE_RECT];
    [animator removeQueuedAnimationsForObject:timerElement ofType:ANIMATION_ELEMENT_CHANGE_RECT];
    
   ;
    Friend *friend = _message.owner;
    
    NSString *concat = [[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]
                        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ((friend.firstName == nil && friend.lastName == nil) || [concat isEqualToString:@""])
        concat = friend.username;
    else if (friend.firstName == nil)
        concat = friend.lastName;
    else if (friend.lastName == nil)
        concat = friend.firstName;
    
    NSString *labelText = [NSString stringWithFormat:@"%@ by %@",[timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:_message.timeSent],concat];
    
    [fromLabel setText:labelText withHorizontalAlignment:UITextAlignmentLeft andVerticalAlignment:UITextAlignmentMiddle];
    
    
    
    int fontSize = [self binarySearchForFontSizeForText:_message.message withMinFontSize:5 withMaxFontSize:25 withSize:messageView.frame.size];
    
    Texture2D *messageTexture = [[Texture2D alloc]initWithString:_message.message dimensions:messageView.frame.size horizontalAlignment:UITextAlignmentCenter verticalAlignment:UITextAlignmentMiddle fontName:@"Lato-Bold" fontSize:fontSize-1];
    
    [messageView setTexture:messageTexture];
    [messageTexture release];
    
    if (message.timeOpened == nil)
    {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            [timeLabel setText:[NSString stringWithFormat:@"%d",message.duration] withFont:@"Lato" andSize:200 andHorizontalTextAligntment:UITextAlignmentCenter andVerticalTextAlignment:UITextAlignmentMiddle];
            
        }
        else
            [timeLabel setText:[NSString stringWithFormat:@"%d",message.duration] withFont:@"Lato" andSize:100 andHorizontalTextAligntment:UITextAlignmentCenter andVerticalTextAlignment:UITextAlignmentMiddle];
        
        timeLabel.originOfElement = CGPointMake(0, 0);
        messageView.originInsideElement = CGPointMake(0, -200);
        timerElement.frame = CGRectMake(timerElement.frame.origin.x,timerElement.frame.origin.y,
                                        0,timerElement.frame.size.height);
        
    }
    else
    {
        timeLabel.originOfElement =  CGPointMake(0, self.frame.size.height-46);
        messageView.originInsideElement = CGPointMake(0, 0);
        CGFloat width = self.frame.size.width * ([[self.message timeOpened]timeIntervalSinceNow]/self.message.duration * 1.0);
        timerElement.frame = CGRectMake(timerElement.frame.origin.x,timerElement.frame.origin.y,
                                        -width,timerElement.frame.size.height);
       
    }
    
}

-(void)update
{
    CGFloat width = self.frame.size.width * ([[self.message timeOpened]timeIntervalSinceNow]/self.message.duration * 1.0);
    
    CGRect newFrame = CGRectMake(self.frame.size.width + width,timerElement.frame.origin.y,
                                 -width,timerElement.frame.size.height);
    timerElement.frame = newFrame;

}

-(void)updateTimeElapsed
{
  }

@end

