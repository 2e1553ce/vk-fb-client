//
//  AVGContactList.m
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGContactList.h"
#import "AVGContact.h"
#import "AVGContactService.h"
#import "AVGVKViewController.h"
@import FBSDKCoreKit;

@implementation AVGContactList

- (void)contactListFromVKWithCompletionHandler:(void(^)(void))completionHandler {
    NSString *userID = [AVGVKViewController currentUser];
    NSString *token = [AVGVKViewController currentAccessToken];
    NSString *url = [NSString stringWithFormat:@"https://api.vk.com/method/friends.get?user_id=%@&v=5.52&nickname&fields=name&access_token=%@", userID, token];
    
    __weak typeof(self) weakSelf = self;
    [AVGContactService loadFromURL:[NSURL URLWithString:url] withCompletionHandler:^(NSDictionary *result) {
        __strong typeof(self)strongSelf = weakSelf;
        if (strongSelf) {
            NSMutableArray *items = [NSMutableArray new];
            for (NSDictionary *item in result[@"response"][@"items"]) {
                [items addObject:( [AVGContact contactWithName: item[@"first_name"] andSurname: item[@"last_name"]])];
            }
            strongSelf.contacts = items;
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler();
            });
        }
    }];
}

- (void)contactListFromFacebookWithCompletionHandler:(void(^)(void))completionHandler {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/taggable_friends"
                                                                   parameters:@{@"fields": @"id, name"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"error is %@",error.userInfo);
        } else {
            NSArray *friends = result[@"data"];
            NSMutableArray *facebookFriends = [NSMutableArray new];
            for (NSDictionary *contact in friends) {
                NSString *nameSurname = contact[@"name"];
                NSRange space = [nameSurname rangeOfString:@" "];
                NSString *name = [nameSurname substringToIndex:space.location];
                NSString *surname = [nameSurname substringFromIndex:space.location+1];
                AVGContact *friend = [AVGContact contactWithName: name andSurname:surname];
                [facebookFriends addObject:friend];
            }
            self.contacts = facebookFriends;
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler();
            });
        }
    }];

}

@end
