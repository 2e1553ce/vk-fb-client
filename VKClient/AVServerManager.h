//
//  AVServerManager.h
//  VKClient
//
//  Created by aiuar on 19.04.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVUser;

@interface AVServerManager : NSObject

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(AVUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray *friends))success
                    onFailure:(void(^)(NSError *error, NSInteger  statusCode))failure;

@end
