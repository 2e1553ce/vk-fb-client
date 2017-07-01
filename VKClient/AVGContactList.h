//
//  AVGContactList.h
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@interface AVGContactList : NSObject

@property (nonatomic, copy) NSArray *contacts;

- (void)contactListFromVKWithCompletionHandler:(void(^)(void))completionHandler;
- (void)contactListFromFacebookWithCompletionHandler:(void(^)(void))completionHandler;

@end
