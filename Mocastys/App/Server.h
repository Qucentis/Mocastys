//
//  APIWrapper.h
//  KBC
//
//  Created by Rakesh on 02/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface ServerError : NSObject
@property (nonatomic) int errorCode;
@property (nonatomic,retain) NSString* errorString;
@end

@interface Server : NSObject
{
    NSString *serverURL;
    NSString *accessToken;
    NSString *authorizationToken;
    NSString *userName;
}
@property (nonatomic,retain) NSString *accessToken;
@property (nonatomic,retain) NSString *authorizationToken;
@property (nonatomic,retain) NSString *userName;

+(id)sharedServer;

-(void)resetAuthorizationToken;

-(void)getAccessTokenWithCompletionBlock:(void (^) (NSDictionary *,NSArray *))loginBlock;

-(void)loginWithUserName:(NSString *)username andPassword:(NSString *)password
     withCompletionBlock:(void (^) (NSDictionary *,NSArray *))loginBlock;

-(void)sendMessage:(NSString *)message ToUser:(NSArray *)username WithDuration:(int)duration withCompletionBlock:(void (^) (NSDictionary *,NSArray *))messageSentBlock;

-(void)checkAvailability:(NSDictionary *)parameters withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block;
-(void)registerUser:(NSDictionary *)parameters withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block;

-(void)findUsers:(NSDictionary *)parameters withCompletionBlock:(void (^) (NSArray *,NSArray *))block;

-(void)receiveMessagesWithCompletionBlock:(void (^) (NSArray *,NSArray *))block;

-(void)markMessageAsRead:(NSString *)messageID withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block;

-(void)resetPassword:(NSString *)username withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block;

-(void)markMessagesListAsRead:(NSArray *)messages withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block;

@end
