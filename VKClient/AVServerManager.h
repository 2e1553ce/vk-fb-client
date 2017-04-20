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

- (AVServerManager *)sharedManager;

- (void)authorizeUser:(void(^)(AVUser *user))completion;

@end
