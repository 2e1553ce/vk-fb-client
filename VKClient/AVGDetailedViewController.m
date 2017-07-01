//
//  AVGDetailedViewController.m
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGDetailedViewController.h"

@interface AVGDetailedViewController ()

@end

@implementation AVGDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 120, self.view.frame.size.width - 160, 40)];
    nameLabel.text = self.firstName;
    [self.view addSubview:nameLabel];
    
    UILabel *lastNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 170, self.view.frame.size.width - 160, 40)];
    lastNameLabel.text = self.lastName;
    [self.view addSubview:lastNameLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 20, 80, 40, 40)];
    imageView.image = self.titleImage;
    [self.view addSubview:imageView];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@, %@",self.firstName, self.lastName];
}

@end
