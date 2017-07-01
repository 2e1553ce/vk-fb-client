//
//  AVGTableViewController.m
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGTableViewController.h"

#import "AVGContact.h"
#import "AVGContactList.h"
#import "AVGDetailedViewController.h"
#import "AVGTableViewCell.h"
#import "AVGVKViewController.h"
@import FBSDKLoginKit;
@import FBSDKCoreKit;

typedef NS_ENUM(NSInteger, SelectedSocialNetwork){
    SelectedSocialNetworkVkontakte,
    SelectedSocialNetworkFacebook
};

@interface AVGTableViewController ()

@property(nonatomic, strong) AVGContactList *contactList;
@property(nonatomic, strong) UIToolbar *bottomBar;
@property(nonatomic, assign) SelectedSocialNetwork selectedSocialNetwork;
@property(nonatomic, strong) UIButton *loginButton;

@end

@implementation AVGTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 80;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AVGTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"ВКонтакте", @"Фейсбук"]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    self.loginButton = [UIButton new];
    self.loginButton.frame = CGRectMake(0,0,60,20);
    self.loginButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.loginButton setTitle: @"Вход" forState: UIControlStateNormal];
    [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.loginButton];
    
    self.contactList = [AVGContactList new];
    self.selectedSocialNetwork = SelectedSocialNetworkVkontakte;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.selectedSocialNetwork == SelectedSocialNetworkVkontakte) {
        if ([AVGVKViewController currentAccessToken]){
            [self.loginButton setTitle:@"Выход" forState:UIControlStateNormal];
            [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
            __weak typeof(self) weakSelf = self;
            [self.contactList contactListFromVKWithCompletionHandler: ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf.tableView reloadData];
                }
            }];
        }
    } else if (self.selectedSocialNetwork == SelectedSocialNetworkFacebook){
        if ([FBSDKAccessToken currentAccessToken]) {
            [self.loginButton setTitle:@"Выход" forState:UIControlStateNormal];
            [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
            __weak typeof(self) weakSelf=self;
            [self.contactList contactListFromFacebookWithCompletionHandler: ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf.tableView reloadData];
                }
            }];
        }
    }
}

- (IBAction)segmentedControlDidChangeValue:(UISegmentedControl *)segmentedControl {
    self.contactList.contacts = nil;
    self.bottomBar.items = nil;
    [self.tableView reloadData];
    switch (segmentedControl.selectedSegmentIndex) {
        case 0: {
            self.selectedSocialNetwork = SelectedSocialNetworkVkontakte;
            if (![AVGVKViewController currentAccessToken]){
                [self.loginButton setTitle:@"Вход" forState:UIControlStateNormal];
                [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
            } else {
                [self.loginButton setTitle:@"Выход" forState:UIControlStateNormal];
                [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
                __weak typeof(self) weakSelf = self;
                [self.contactList contactListFromVKWithCompletionHandler: ^{
                    __strong typeof(self) strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf.tableView reloadData];
                    }
                }];
            }
            break;
        }
        case 1: {
            self.selectedSocialNetwork = SelectedSocialNetworkFacebook;
            if (![FBSDKAccessToken currentAccessToken]) {
                [self.loginButton setTitle:@"Вход" forState:UIControlStateNormal];
                [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
            } else {
                [self.loginButton setTitle:@"Выход" forState:UIControlStateNormal];
                [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
                __weak typeof(self) weakSelf = self;
                    [self.contactList contactListFromFacebookWithCompletionHandler: ^{
                         __strong typeof(self) strongSelf = weakSelf;
                        if (strongSelf) {
                            [weakSelf.tableView reloadData];
                        }
                    }];
                }
            }
        }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    AVGContact *contact = self.contactList.contacts[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@, %@",contact.firstName, contact.lastName];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",[contact.firstName substringToIndex:1], [contact.lastName substringToIndex:1]];
    
    NSUInteger hash=[cell.titleLabel.text substringToIndex:1].hash;
    
    cell.titleLabel.layer.backgroundColor=[UIColor colorWithRed:(hash%7)/7.0 green:(hash%49)/49.0 blue:(hash%343)/343.0 alpha:1].CGColor;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactList.contacts count];
}


# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - login

- (void)loginButtonClicked {
    if ([self.loginButton.titleLabel.text isEqualToString:@"Выход"]) {
        [self logout];
        return;
    }
    if (self.selectedSocialNetwork == SelectedSocialNetworkVkontakte) {
        [self.navigationController pushViewController:[AVGVKViewController new] animated:YES];
    } else if (self.selectedSocialNetwork == SelectedSocialNetworkFacebook) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                NSLog(@"Process error");
            } else if (result.isCancelled) {
                NSLog(@"Cancelled");
            } else {
                NSLog(@"Logged");
                __weak typeof(self) weakSelf=self;
                [self.contactList contactListFromFacebookWithCompletionHandler: ^{
                    [weakSelf.tableView reloadData];
                }];
            }
        }];
    }
}

- (void)logout {
    if (self.selectedSocialNetwork == SelectedSocialNetworkVkontakte) {
        [AVGVKViewController logout];
    } else if (self.selectedSocialNetwork == SelectedSocialNetworkFacebook) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    [self.loginButton setTitle:@"Вход" forState:UIControlStateNormal];
    [self.loginButton setTitleColor: UIColor.grayColor forState:UIControlStateNormal];
    self.contactList.contacts = nil;
    
}

@end
