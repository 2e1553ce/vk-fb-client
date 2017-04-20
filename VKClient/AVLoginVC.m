//
//  AVLoginVC.m
//  VKClient
//
//  Created by aiuar on 19.04.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVLoginVC.h"
#import "AVLoginWebView.h"
#import "AVAccessToken.h"

@interface AVLoginVC () <UIWebViewDelegate>

@property (copy, nonatomic) AVLoginCompletionBlock completionBlock;
@property (strong, nonatomic) AVLoginWebView *loginWebView;

@end

@implementation AVLoginVC

#pragma mark - init

- (id)initWithCompletionBlock:(AVLoginCompletionBlock)completionBlock {
    self = [super init];
    
    if(self) {
        _completionBlock = completionBlock;
    }
    
    return  self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUserInterface];
    [self loadAuthorizationWindow];
}

- (void)dealloc {
    self.loginWebView.delegate = nil;
}

#pragma mark - UI settings

- (void)setUpUserInterface {
    self.navigationItem.title = @"Вход";
    
    // Web view
    CGRect bounds = self.view.bounds;
    bounds.origin = CGPointZero;
    self.loginWebView = [[AVLoginWebView alloc] initWithFrame:bounds];
    self.loginWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.loginWebView.delegate = self;
    [self.view addSubview:self.loginWebView];
    
    // Cancel button
    UIBarButtonItem *cancelLoginButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(actionCancelLogin:)];
    self.navigationItem.rightBarButtonItem = cancelLoginButton;
}

#pragma mark - Load vk authorization window

- (void)loadAuthorizationWindow {
    NSString *urlString = @"https://oauth.vk.com/authorize"
                           "?client_id=5472315"
                           "&display=mobile"
                           "&redirect_uri=https://oauth.vk.com/blank.html"
                           "&scope=139286"
                           "&response_type=token"
                           "&v=5.52";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.loginWebView loadRequest:request];
}

#pragma mark - Button actions

- (void)actionCancelLogin:(UIBarButtonItem *)sender {
    if(self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([  [[request URL] description] rangeOfString:@"access_token="].location != NSNotFound) {
        
        AVAccessToken *accsessToken = [[AVAccessToken alloc] init];
        
        NSString *query = [[request URL] description];
        NSArray *array = [query componentsSeparatedByString:@"#"];
        
        if([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for(NSString *pair in pairs){
            NSArray *comp = [pair componentsSeparatedByString:@"="];
            
            if([[comp firstObject] isEqualToString:@"access_token"]) {
                accsessToken.token = [comp lastObject];
            } else if([[comp firstObject] isEqualToString:@"user_id"]) {
                accsessToken.userID = [comp lastObject];
            } else if([[comp firstObject] isEqualToString:@"expires_in"]) {
                NSTimeInterval interval = [[comp lastObject] doubleValue];
                accsessToken.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
            }
        }
        
        self.loginWebView.delegate = nil;
        
        if(self.completionBlock) {
            self.completionBlock(accsessToken);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end

// Сервер менеджер норм?
// viewdidload настройка ui там? setUpUserInterface
// mvc mvp mvvm viper?
// vc tvc сокращения
// советуют webview.delegate в деаллоке ставить в нил
// Как показывать вью контроллеры с логином + авторизацией
// пустые классы вьюшек норм? -> webView
// выбирать из кор даты экспайред дату и по ней ставить tvc or login
