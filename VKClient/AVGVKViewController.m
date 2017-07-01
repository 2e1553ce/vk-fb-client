//
//  AVGVKViewController.m
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGVKViewController.h"
#import <WebKit/WebKit.h>

@interface AVGVKViewController () <WKNavigationDelegate>

@end

@implementation AVGVKViewController

+ (NSString *)currentAccessToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:@"vkToken"];
    return accessToken;
}

+ (NSString *)currentUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"userID"];
    return userID;
}

+ (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"vkToken"];
    [defaults removeObjectForKey:@"userID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    NSString *url = @"https://oauth.vk.com/authorize?client_id=5472315&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.63&state=123456";
    NSURLRequest *nsurlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:nsurlRequest];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView didFinishNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *responseURL = webView.URL.absoluteString;
    if ([responseURL rangeOfString:@"access_token"].location != NSNotFound)
    {
        NSRange tokenBegin=[responseURL rangeOfString:@"access_token="];
        NSString *accessToken0=[responseURL substringFromIndex:tokenBegin.location+tokenBegin.length];
        NSRange tokenEnd=[accessToken0 rangeOfString:@"&"];
        NSString *accessToken1=[accessToken0 substringToIndex:tokenEnd.location];
        
        NSRange userIdRange=[responseURL rangeOfString:@"user_id="];
        NSString *userId0=[responseURL substringFromIndex:userIdRange.location+userIdRange.length];
        NSRange userIdEnd=[userId0 rangeOfString:@"&" ];
        NSString *userId1=[userId0 substringToIndex:userIdEnd.location];
        
        [self saveAccessToken:accessToken1 andLogin:userId1];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([responseURL rangeOfString:@"error"].location != NSNotFound) {
        NSLog(@"Error: %@", webView.URL.absoluteString);
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"something went wrong" message:@"Check your internet connection and try again!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)saveAccessToken:(NSString *)accessToken andLogin:(NSString *)login {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"vkToken"];
    [defaults setObject:login forKey:@"userID"];
}

@end
