//
//  AVLoginVC.h
//  VKClient
//
//  Created by aiuar on 19.04.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAccessToken;

typedef void(^AVLoginCompletionBlock)(AVAccessToken *token);

@interface AVLoginVC : UIViewController

- (id)initWithCompletionBlock:(AVLoginCompletionBlock)completionBlock;

@end
