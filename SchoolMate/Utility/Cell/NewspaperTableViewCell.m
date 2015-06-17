//
//  NewspaperTableViewCell.m
//  SchoolMate
//
//  Created by SuperDanny on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "NewspaperTableViewCell.h"

@interface NewspaperTableViewCell ()

///喜欢总数
@property (weak, nonatomic) IBOutlet UILabel     *likeCountLab;
///评论总数
@property (weak, nonatomic) IBOutlet UILabel     *commentCountLab;
///用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImgV;
///用户名称
@property (weak, nonatomic) IBOutlet UILabel     *userNameLab;
///用户生日
@property (weak, nonatomic) IBOutlet UILabel     *userBornLab;
///用户标签
@property (weak, nonatomic) IBOutlet UILabel     *userTagLab;
///用户分享图片
@property (weak, nonatomic) IBOutlet UIImageView *sharePicImgV;


@end

@implementation NewspaperTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 喜欢
- (IBAction)likeAction:(id)sender {
    NSLog(@"like");
}

#pragma mark - 评论
- (IBAction)commentAction:(id)sender {
    NSLog(@"comment");
}

@end
