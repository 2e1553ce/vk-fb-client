//
//  AVGContactService.m
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGContactService.h"

@implementation AVGContactService

+ (void)loadFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *result))completionHandler {
    __block BOOL success = NO;
    __block NSDictionary *result;
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR %@",error.localizedDescription);
        }
        else {
            NSHTTPURLResponse *resp =(NSHTTPURLResponse *)response;
            if (resp.statusCode == 200) {
                NSError *error = nil;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
                result=[[NSDictionary alloc]initWithDictionary:json];
                success=YES;
                completionHandler(result);
            }
        }
    }];
    [task resume];
}

@end
