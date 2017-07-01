//
//  AVGVKViewController.h
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@interface AVGVKViewController : UIViewController

+ (NSString *)currentAccessToken;
+ (NSString *)currentUser;
+ (void)logout;

@end
