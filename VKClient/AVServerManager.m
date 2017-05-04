//
//  AVServerManager.m
//  VKClient
//
//  Created by aiuar on 19.04.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVServerManager.h"

#import "AVLoginVC.h"
#import "AVAccessToken.h"
#import "AVUser.h"

@interface AVServerManager ()

@property (strong, nonatomic) NSURLSession  *session;
@property (strong, nonatomic) AVAccessToken *accessToken;
@property (strong, nonatomic) NSURL         *baseURL;

@end

@implementation AVServerManager

#pragma mark - init

- (id)init {
    self = [super init];
    
    if(self) {
        self.baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration: config];
    }
    
    return self;
}

#pragma mark - Get User

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(AVUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params = @{userID:        @"user_ids",
                             @"photo_50":   @"fields",
                             @"nom":        @"name_case"};
    
    NSURL *url = [self URLStringWithParameters: params method:@"users.get"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL: url];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[self.session dataTaskWithRequest:request
                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                       
                        NSLog(@"JSON: %@", response);
                        
                        /*NSArray* dictsArray = [response objectForKey:@"response"];
                        
                        if ([dictsArray count] > 0) {
                            AVUser* user = [[AVUser alloc] initWithServerResponse:[dictsArray firstObject]];
                            if (success) {
                                success(user);
                            }
                        } else {
                            if (failure) {
                                NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                                
                                failure(nil, resp.statusCode);
                            }
                        }
                         */
    }] resume];
    /*
    [self.session  GET:@"users.get"
                   parameters:params
                     progress:^(NSProgress * _Nonnull downloadProgress) {
                         
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"JSON: %@", responseObject);
                          
                          NSArray* dictsArray = [responseObject objectForKey:@"response"];
                          
                          if ([dictsArray count] > 0) {
                              AVUser* user = [[AVUser alloc] initWithServerResponse:[dictsArray firstObject]];
                              if (success) {
                                  success(user);
                              }
                          } else {
                              if (failure) {
                                  NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                                  
                                  failure(nil, resp.statusCode);
                              }
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                          
                          NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                          
                          failure(error, resp.statusCode);
                      }];
     */
}

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray *friends))success
                    onFailure:(void(^)(NSError *error, NSInteger  statusCode))failure{
    
    NSString *countStr = [NSString stringWithFormat: @"%ld", (long)count];
    NSString *offsetStr = [NSString stringWithFormat: @"%ld", (long)offset];
    
    NSDictionary *params = @{@"user_id": @"1995919",
                            @"order": @"name",
                             @"count": countStr,
                             @"offset": offsetStr,
                            @"fields": @"photo_100,online",
                            @"name_case": @"nom"};
    
    NSURL *url = [self URLStringWithParameters:params method:@"friends.get"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL: url];
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[self.session dataTaskWithRequest:request
                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                         
                         NSLog(@"JSON: %@", response);
                         
                         /*NSArray* dictsArray = [response objectForKey:@"response"];
                          
                          if ([dictsArray count] > 0) {
                          AVUser* user = [[AVUser alloc] initWithServerResponse:[dictsArray firstObject]];
                          if (success) {
                          success(user);
                          }
                          } else {
                          if (failure) {
                          NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                          
                          failure(nil, resp.statusCode);
                          }
                          }
                          */
                     }] resume];

    /*
    [self.sessionManager  GET:@"friends.get"
                   parameters:params
                     progress:^(NSProgress * _Nonnull downloadProgress) {
                         
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          //NSLog(@"JSON: %@", responseObject);
                          
                          NSArray *dictArray = [responseObject objectForKey:@"response"];
                          
                          NSMutableArray *arrayOfUsers = [NSMutableArray array];
                          
                          for(NSDictionary *dict in dictArray){
                              
                              AVUser *user = [[AVUser alloc] initWithServerResponse:dict];
                              [arrayOfUsers addObject:user];
                          }
                          
                          if(success){
                              success(arrayOfUsers);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          if(failure){
                              
                              NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                              
                              failure(error, resp.statusCode);
                          }
                      }];
    */
}


#pragma mark - URL with params from dictionary

- (NSURL *)URLStringWithParameters:(NSDictionary *)parameters
                            method:(NSString *)method {
    
    NSString *urlWithMetod = [self.baseURL.absoluteString stringByAppendingString:method];
    //NSURL *url = [NSURL URLWithString:urlWithMetod];
    
    NSURLComponents *components = [NSURLComponents componentsWithString: urlWithMetod];
    NSMutableArray *queryItems = [NSMutableArray arrayWithCapacity:[parameters count]];
    
    for(NSString *key in parameters) {
        [queryItems addObject: [NSURLQueryItem queryItemWithName:key value:parameters[key]]];
    }
    components.queryItems = queryItems;
    
    return components.URL;
}

@end
