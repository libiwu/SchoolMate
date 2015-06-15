//
//  UserInfoCell.m
//  SchoolMate
//
//  Created by libiwu on 15/6/10.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *lineView;
@end

@implementation UserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    
    CGFloat titleWid = (self.frame.size.width - 10.0 * 2)/3;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0.0, titleWid, self.frame.size.height)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0.0, titleWid * 2 - 35.0, self.frame.size.height)];
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentLabel setTextColor:[UIColor grayColor]];
    
    CGFloat avatarH = self.frame.size.height - 10.0;
    
    self.avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - avatarH - 15.0, 5.0, avatarH, avatarH)];
    self.avatarView.hidden = YES;
    
    CGFloat pictureH = self.frame.size.height - 10.0;
    
    self.pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - pictureH - 15.0, 5.0, pictureH, pictureH)];
    self.pictureView.hidden = YES;
    
    CGFloat arrowH = self.frame.size.height - 22.0;
    
    self.arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - arrowH - 15.0, 11.0, arrowH, arrowH)];
    [self.arrowView setImage:[UIImage imageNamed:@"youjiantou.png"]];
    self.arrowView.hidden = YES;
    
    self.lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, self.frame.size.height - .5, self.frame.size.width - 20.0, .5)];
    self.lineView.backgroundColor = RGBACOLOR(228.0, 228.0, 228.0, 1.0);
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
//    self.backImageView.image = [UIImage imageNamed:@"cellBack.png"];
    self.backImageView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    [self.contentView addSubview:self.backImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.pictureView];
    [self.contentView addSubview:self.arrowView];
    [self.contentView addSubview:self.lineView];
}
- (void)setUserInfoModel:(id)object indexPath:(NSIndexPath *)indexPath cellType:(UserInfoCellType)type {
    
    NSDictionary *dic = object;
    
    switch (type) {
        case UserInfoCellTypeDefault:
        {
            [self.titleLabel setText:dic[@"title"]];
            [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x,
                                                 self.titleLabel.frame.origin.y,
                                                 self.titleLabel.frame.size.width,
                                                 self.frame.size.height)];
            
            [self.contentLabel setText:dic[@"content"]];
            [self.contentLabel setHidden:NO];
            [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x,
                                                   self.contentLabel.frame.origin.y,
                                                   self.contentLabel.frame.size.width,
                                                   self.frame.size.height)];
            
            [self.avatarView setHidden:YES];
            
            [self.pictureView setHidden:YES];
            
            [self.arrowView setHidden: YES];
            
            [self.backImageView setFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
            
            [self.lineView setFrame:CGRectMake(self.lineView.frame.origin.x,
                                              self.frame.size.height - .5,
                                              self.lineView.frame.size.width,
                                               .5)];
        }
            break;
        case UserInfoCellTypeAvatar:
        {
            [self.titleLabel setText:dic[@"title"]];
            [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x,
                                                 self.titleLabel.frame.origin.y,
                                                 self.titleLabel.frame.size.width,
                                                 self.frame.size.height)];
            
            [self.contentLabel setText:dic[@"content"]];
            [self.contentLabel setHidden:YES];
            [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x,
                                                   self.contentLabel.frame.origin.y,
                                                   self.contentLabel.frame.size.width,
                                                   self.frame.size.height)];
            
            [self.avatarView setHidden:NO];
            [self.avatarView setImage:[UIImage imageNamed:@"headImage.png"]];
            [self.avatarView setFrame:CGRectMake(self.frame.size.width - self.frame.size.height + 22.0 - 15.0,
                                                 11.0,
                                                 self.frame.size.height - 22.0,
                                                 self.frame.size.height - 22.0)];
            
            [self.pictureView setHidden:YES];
            
            [self.arrowView setHidden:YES];
            
            [self.backImageView setFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
            
            [self.lineView setFrame:CGRectMake(self.lineView.frame.origin.x,
                                               self.frame.size.height - .5,
                                               self.lineView.frame.size.width,
                                               .5)];
        }
            break;
        case UserInfoCellTypeImage:
        {
            [self.titleLabel setText:dic[@"title"]];
            [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x,
                                                 self.titleLabel.frame.origin.y,
                                                 self.titleLabel.frame.size.width,
                                                 self.frame.size.height)];
            
            [self.contentLabel setText:dic[@"content"]];
            [self.contentLabel setHidden:YES];
            [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x,
                                                   self.contentLabel.frame.origin.y,
                                                   self.contentLabel.frame.size.width,
                                                   self.frame.size.height)];
            
            [self.avatarView setHidden:YES];
            
            [self.pictureView setHidden:NO];
            [self.pictureView setImage:[UIImage imageNamed:@"headImage.png"]];
            
            [self.arrowView setHidden: YES];
            
            [self.backImageView setFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
            
            [self.lineView setFrame:CGRectMake(self.lineView.frame.origin.x,
                                               self.frame.size.height - .5,
                                               self.lineView.frame.size.width,
                                               .5)];
        }
            break;
        case UserInfoCellTypeArrow:
        {
            [self.titleLabel setText:dic[@"title"]];
            [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x,
                                                 self.titleLabel.frame.origin.y,
                                                 self.titleLabel.frame.size.width,
                                                 self.frame.size.height)];
            
            [self.contentLabel setText:dic[@"content"]];
            [self.contentLabel setHidden:NO];
            [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x,
                                                   self.contentLabel.frame.origin.y,
                                                   self.contentLabel.frame.size.width,
                                                   self.frame.size.height)];
            
            [self.avatarView setHidden:YES];
            
            [self.pictureView setHidden:YES];
            
            [self.arrowView setHidden:NO];
            
            [self.backImageView setFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
            
            [self.lineView setFrame:CGRectMake(self.lineView.frame.origin.x,
                                               self.frame.size.height - .5,
                                               self.lineView.frame.size.width,
                                               .5)];
        }
            break;
        default:
            break;
    }
}


@end
