//
//  AVServerManager.m
//  VKClient
//
//  Created by aiuar on 19.04.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVServerManager.h"

@interface AVServerManager ()

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURL *baseURL;

@end

@implementation AVServerManager

#pragma mark - Singleton

- (AVServerManager *)sharedManager {
    static AVServerManager *manager = nil;
    
    if(!manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [AVServerManager new];
        });
    }
    
    return manager;
}

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

#pragma mark - User authorization

- (void)authorizeUser:(void (^)(AVUser *))completion {
    
}

@end
