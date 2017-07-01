//
//  AVGTableViewCell.m
//  VKClient
//
//  Created by aiuar on 01.07.17.
//  Copyright © 2017 A.V. All rights reserved.
//

#import "AVGTableViewCell.h"

@implementation AVGTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, self.frame.size.height / 2 + 5, self.frame.size.width - 90, 20)];
        [self.contentView addSubview:self.nameLabel];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 70, 70)];
        self.titleLabel.layer.cornerRadius = 20;
        self.titleLabel.layer.borderWidth = 0.7;
        self.titleLabel.layer.opacity = 0.7;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        self.titleLabel.shadowOffset = CGSizeMake(0.7, 0.7);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
