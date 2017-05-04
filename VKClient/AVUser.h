//
//  AVUser.h
//  VKClient
//
//  Created by aiuar on 20.04.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVUser : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSURL *photo100URL;
@property (nonatomic, strong) NSURL *photo400URL;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *birthday;

@end
