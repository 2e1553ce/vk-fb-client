//
//  AVGContactService.h
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

@interface AVGContactService : NSObject

+ (void)loadFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary* result))completionHandler;

@end
