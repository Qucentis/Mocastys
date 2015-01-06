//
//  APIWrapper.m
//  KBC
//
//  Created by Rakesh on 02/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "Server.h"
#import "DataManager.h"

@implementation ServerError

-(NSString *)description
{
    return [NSString stringWithFormat:@"Error Code : %d Error String : %@",self.errorCode,self.errorString];
}
@end

@implementation Server

@synthesize accessToken,authorizationToken,userName;

-(id)init
{
    if (self = [super init])
    {
        serverURL = @"http://54.200.80.56:10000/api/";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.authorizationToken = [defaults objectForKey:@"authorizationToken"];
        self.userName = [defaults objectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return self;
}

+(id)sharedServer
{
    static Server *server;
    @synchronized(self)
    {
        if (server == nil)
            server = [[Server alloc]init];
    }
    return server;
}

-(void)resetAuthorizationToken
{
    self.authorizationToken = nil;
    self.userName = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"authorizationToken"];
    [defaults setObject:@"" forKey:@"userName"];
    [defaults removeObjectForKey:@"authorizationToken"];
    [defaults removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)getDataFromURL:(NSString *)url withCompletionBlock:(void (^) (NSDictionary *))block
{
    NSString *completeURL = [NSString stringWithFormat:@"%@%@",serverURL,url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURL]];
    [NSURLConnection sendAsynchronousRequest:request
                                        queue:[NSOperationQueue mainQueue]
                                              completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:nil];
            block(jsonDictionary);
                                              
    }];
    

}

-(void)postToURL:(NSString *)url withData:(NSDictionary *)data withCompletionBlock:(void (^) (NSDictionary *))block
{
    NSString *completeURL = [NSString stringWithFormat:@"%@%@",serverURL,url];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURL]];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:0
                                                             error:nil];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error != nil)
         {
             block([NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"error_code",error.localizedDescription,@"error_string", nil]], @"errors", nil]);
             return;
         }
         NSError *jSONError;
         NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&jSONError];
         if (jSONError != nil && jsonDictionary == nil)
         {
             
             block([NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"error_code",jSONError.localizedDescription,@"error_string", nil]], @"errors", nil]);
             return;
         }
         block(jsonDictionary);
         
     }];
}

-(void)getAccessTokenWithCompletionBlock:(void (^) (NSDictionary *,NSArray *))block
{
    
    [self getDataFromURL:@"get-access-token" withCompletionBlock:^(NSDictionary * challenge)
     {
         int challengeInt = [challenge[@"challenge"] intValue];
         int responseInt = challengeInt * challengeInt;
        
         
         NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:responseInt], @"response",[NSNumber numberWithInt:challengeInt],@"challenge", nil],@"obj",nil];
         
         [self postToURL:@"get-access-token" withData:response withCompletionBlock:^(NSDictionary * accessTokenData)
          {
              self.accessToken = accessTokenData[@"token"];
              NSArray *errors = [self getErrors:accessTokenData];
              block(accessTokenData,errors);
              [errors release];
          }
          ];
         
     }];
}

-(NSDictionary *)wrapWithAccessToken:(NSDictionary *)dict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:dict,@"obj",self.accessToken,@"token",nil];
}


-(NSDictionary *)wrapWithAuthorizationToken:(NSDictionary *)dict
{
    if (dict == nil)
            return [NSDictionary dictionaryWithObjectsAndKeys:@"",@"obj",self.authorizationToken,@"token",nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:dict,@"obj",self.authorizationToken,@"token",nil];
}

-(NSDictionary *)wrapWithObj:(NSDictionary *)dict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:dict,@"obj",nil];
}

-(NSArray *)getErrors:(NSDictionary *)errorData
{
    if ([errorData isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    NSArray *errorArray = errorData[@"errors"];
    NSMutableArray *serverErrorArray =  nil;
    if (errorArray == nil)
    {
        if (errorData[@"error_code"]!=nil)
        {
            serverErrorArray = [[NSMutableArray alloc]init];
            ServerError *error = [[ServerError alloc]init];
            error.errorCode = [errorData[@"error_code"] intValue];
            error.errorString = errorData[@"error_message"];
            [serverErrorArray addObject:error];
            [error release];
        }
    }
    else
    {
        serverErrorArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in errorArray)
    {
        ServerError *error = [[ServerError alloc]init];
        error.errorCode = [dict[@"error_code"] intValue];
        error.errorString = dict[@"error_message"];
        [serverErrorArray addObject:error];
        [error release];
    }
    }
    return serverErrorArray;
}

-(void)loginWithUserName:(NSString *)username andPassword:(NSString *)password
                    withCompletionBlock:(void (^) (NSDictionary *,NSArray *))loginBlock
{
     NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:username, @"username",password,@"password", nil],@"obj",nil];
    //NSLog(@"%@",data);
    [self postToURL:@"login" withData:data withCompletionBlock:^(NSDictionary * responseData)
    {
        if (responseData[@"token"] == nil)
         {
             NSArray *errors= [self getErrors:responseData];
             loginBlock(nil,errors);
             [errors release];
         }
         else
         {
             self.authorizationToken = responseData[@"token"];
             self.userName = username;
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:self.authorizationToken forKey:@"authorizationToken"];
             [defaults setObject:self.userName forKey:@"userName"];
             loginBlock(responseData,nil);
         }
     }];
}

-(void)sendMessage:(NSString *)message ToUser:(NSArray *)users WithDuration:(int)duration withCompletionBlock:(void (^) (NSDictionary *,NSArray *))messageSentBlock;
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:message,@"message",users,@"to",
                          [NSNumber numberWithInteger:duration],@"duration",nil];
    [self postToURL:@"send" withData:[self wrapWithAuthorizationToken:data] withCompletionBlock:^(NSDictionary * responseData)
     {
         NSArray *errors = [self getErrors:responseData];
            messageSentBlock(responseData,errors);
                  [errors release];
     }
    ];
}

-(void)checkAvailability:(NSDictionary *)parameters withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block
{
    if (self.accessToken == nil)
    {
        [self getAccessTokenWithCompletionBlock:^(NSDictionary * responseData,NSArray *errors)
        {
            [self postToURL:@"check-availability" withData:[self wrapWithAccessToken:parameters]
                    withCompletionBlock:^(NSDictionary * responseData)
             {
                 NSArray *errors = [self getErrors:responseData];
                block(responseData,errors);
                          [errors release];
             }];
         }];
    }
    else
    {
        [self postToURL:@"check-availability" withData:[self wrapWithAccessToken:parameters]
                    withCompletionBlock:^(NSDictionary * responseData)
         {
             NSArray *errors = [self getErrors:responseData];
             block(responseData,errors);
             [errors release];
         }];
    }

}

-(void)registerUser:(NSDictionary *)parameters withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block
{
    [self postToURL:@"register" withData:[self wrapWithAccessToken:parameters]
            withCompletionBlock:^(NSDictionary * responseData)
     {
         NSArray *errors = [self getErrors:responseData];
        block(responseData,errors);
                  [errors release];
     }];
}

-(void)findUsers:(NSDictionary *)parameters withCompletionBlock:(void (^) (NSArray *,NSArray *))block
{
    [self postToURL:@"find-users" withData:[self wrapWithAuthorizationToken:parameters]
            withCompletionBlock:^(NSObject * responseData)
     {
         NSArray *errors = [self getErrors:(NSDictionary *)responseData];
         block((NSArray *)responseData,errors);
                  [errors release];
     }];
}

-(void)receiveMessagesWithCompletionBlock:(void (^) (NSArray *,NSArray *))block
{
    NSLog(@"recieving");
    [self postToURL:@"messages" withData:[self wrapWithAuthorizationToken:nil]
        withCompletionBlock:^(NSDictionary * responseData)
     {
        
         NSArray *errors = [self getErrors:responseData];
         if (errors != nil)
         {
            block(nil,errors);
         }
        else
        {
            DataManager *dataManager = [DataManager sharedDataManager];
            NSMutableArray *messageData = [[NSMutableArray alloc]init];
            for (NSDictionary *messageDict in responseData[@"messages"])
            {
                Message *m = [[Message alloc]init];
                m.messageID = messageDict[@"id"];
                m.message = messageDict[@"message"];
                m.duration = [messageDict[@"duration"] intValue];
                BOOL hasTo = NO;
                for (NSString *to in (NSArray *)messageDict[@"to"])
                {
                    if ([to isEqualToString:self.userName])
                    {
                        hasTo = YES;
                    }
                }
                if (!hasTo)
                    continue;
                
                Friend *friend = [dataManager findFriendWithUsername:messageDict[@"from"]];
                if (friend == nil)
                {
                    friend = [[Friend alloc]init];
                    friend.username = messageDict[@"from"];
                    [dataManager addFriend:friend];
                }
                
                m.owner = friend;
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
//                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSZZZ"];

                m.timeSent = [df dateFromString: messageDict[@"time"]];
                int seconds = [m.timeSent timeIntervalSinceNow];
                if (seconds > 0)
                    m.timeSent = [NSDate date];
                m.timeOpened = nil;
                if ([friend.messagesByID objectForKey:m.messageID]  == nil)
                {
                    [friend addMessage:m];
                }
                [messageData addObject:m];
                [m release];
               
            }
            block(messageData,nil);
            [dataManager saveDataToArchive];
            
            [messageData release];
        }
     }];
}

-(void)markMessageAsRead:(NSString *)messageID withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:messageID,@"message", nil];
    [self postToURL:@"read" withData:[self wrapWithAuthorizationToken:data]
            withCompletionBlock:^(NSDictionary * responseData)
     {
         NSArray *errors = [self getErrors:responseData];
         block(responseData,errors);
         [errors release];
     }];
    
}

-(void)markMessagesListAsRead:(NSArray *)messages withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:messages,@"messages", nil];
    [self postToURL:@"read2" withData:[self wrapWithAuthorizationToken:data]
withCompletionBlock:^(NSDictionary * responseData)
     {
         NSArray *errors = [self getErrors:responseData];
         block(responseData,errors);
         [errors release];
     }];
    
}

-(void)resetPassword:(NSString *)username withCompletionBlock:(void (^) (NSDictionary *,NSArray *))block
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:username,
                                @"email", nil];
    [self postToURL:@"reset-password" withData:[self wrapWithAccessToken:dictionary] withCompletionBlock:^(NSDictionary *responseDict)
    {
        NSArray *errors = [self getErrors:responseDict];
        block(responseDict,errors);
    }];
}
@end
