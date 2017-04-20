//
//  AVAccessToken.h
//  VKClient
//
//  Created by aiuar on 20.04.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAccessToken : NSObject

@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *userID;
@property (strong, nonatomic) NSDate *expirationDate;

@end
