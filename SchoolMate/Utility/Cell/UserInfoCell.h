//
//  UserInfoCell.h
//  SchoolMate
//
//  Created by libiwu on 15/6/10.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  个人信息

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UserInfoCellType) {
    UserInfoCellTypeDefault = 0,
    UserInfoCellTypeAvatar,
    UserInfoCellTypeImage,
    UserInfoCellTypeArrow
};


@interface UserInfoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *contentLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setUserInfoModel:(id)object indexPath:(NSIndexPath *)indexPath cellType:(UserInfoCellType)type;
@end
