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
#import "AVFriendsTVC.h"

@interface AVLoginVC () <UIWebViewDelegate>

@property (strong, nonatomic) AVLoginWebView *loginWebView;

@end

@implementation AVLoginVC

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
    [self.view addSubview: self.loginWebView];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([  [[request URL] description] rangeOfString:@"access_token="].location != NSNotFound) {
        AVAccessToken *accsessToken = [[AVAccessToken alloc] init];
        
        NSString *searchedString = request.URL.description;
        NSRange   searchedRange = NSMakeRange(0, searchedString.length);
        
        NSString *patternForAccessToken = @"access_token=[\\w]*";        NSString *patternForExpiresIn = @"expires_in=[\\d]*";
        NSString *patternForUserID = @"user_id=[\\d]*";
        NSError  *error = nil;
        
        // ACCESS_TOKEN
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: patternForAccessToken options:0 error:&error];
        NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
        NSTextCheckingResult* match = matches[0];
        
        NSString* matchText = [searchedString substringWithRange: match.range];
        NSArray *pairs = [matchText componentsSeparatedByString:@"="];
        accsessToken.token = pairs.lastObject;
        
        // EXPIRES_IN
        regex = [NSRegularExpression regularExpressionWithPattern: patternForExpiresIn options:0 error:&error];
        matches = [regex matchesInString:searchedString options:0 range: searchedRange];
        match = matches[0];
        
        matchText = [searchedString substringWithRange: match.range];
        pairs = [matchText componentsSeparatedByString:@"="];
        NSTimeInterval interval = [pairs.lastObject doubleValue];
        accsessToken.expirationDate = [NSDate dateWithTimeIntervalSinceNow: interval];
        
        // USER_ID
        regex = [NSRegularExpression regularExpressionWithPattern: patternForUserID options:0 error:&error];
        matches = [regex matchesInString:searchedString options:0 range: searchedRange];
        match = matches[0];
        
        matchText = [searchedString substringWithRange:[match range]];
        pairs = [matchText componentsSeparatedByString:@"="];
        accsessToken.userID = pairs.lastObject;
        
        // Saving token to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:accsessToken.token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:accsessToken.expirationDate forKey:@"expirationDate"];
        [[NSUserDefaults standardUserDefaults] setObject:accsessToken.userID forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.loginWebView.delegate = nil;
        AVFriendsTVC *friendsTVC = [AVFriendsTVC new];
        [self.navigationController pushViewController:friendsTVC animated:YES];
        
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
