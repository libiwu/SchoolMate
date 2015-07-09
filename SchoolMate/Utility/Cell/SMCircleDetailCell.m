//
//  SMCircleDetailCell.m
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMCircleDetailCell.h"

@interface SMCircleDetailCell ()
//头像
@property (nonatomic, strong) UIImageView *avatarView;
//名字
@property (nonatomic, strong) UILabel *nameLabel;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//评论内容
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIImageView *lineImage;
@end

@implementation SMCircleDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    self.avatarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headImage.png"]];
    [self.avatarView setFrame:CGRectMake(10.0, 10.0, 30.0, 30.0)];
    
    self.nameLabel =
    [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 10.0,
                                             CGRectGetMinY(self.avatarView.frame),
                                             self.frame.size.width - self.avatarView.frame.origin.x * 4 - self.avatarView.frame.size.width * 2,
                                             20.0)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.nameLabel setBackgroundColor: [UIColor clearColor]];
    [self.nameLabel setTextColor:[UIColor grayColor]];
    
    self.timeLabel =
    [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x,
                                             CGRectGetMaxY(self.nameLabel.frame),
                                             self.nameLabel.frame.size.width,
                                             10.0)];
    [self.timeLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self.timeLabel setBackgroundColor:[UIColor clearColor]];
    [self.timeLabel setTextColor:[UIColor grayColor]];
    
    self.commentLabel =
    [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x,
                                             CGRectGetMaxY(self.avatarView.frame) + 10.0,
                                             self.frame.size.width - self.avatarView.frame.origin.x * 3 - self.avatarView.frame.size.width,
                                             0.0)];
    [self.commentLabel setNumberOfLines:0];
    [self.commentLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.commentLabel setBackgroundColor:[UIColor clearColor]];
    [self.commentLabel setTextColor:[UIColor grayColor]];
    
    self.lineImage = [[UIImageView alloc]init];
    [self.lineImage setBackgroundColor:[UIColor grayColor]];
    
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentLabel];
    [self.contentView addSubview:self.lineImage];
}
- (void)setSMCircleDetailModel:(id)object indexPath:(NSIndexPath *)indexPath {
    
    NSString *headImageUrl = @"";
    NSString *nickName = @"";
    NSString *addTime = @"";
    NSString *content = @"";
    if ([object isKindOfClass:[BBCommentModel class]]) {
        BBCommentModel *model = object;
        headImageUrl = model.headImageUrl;
        nickName = model.nickName;
        addTime = model.addTime;
        content = model.content;
    } else {
        CCCommentModel *model = object;
        headImageUrl = model.headImageUrl;
        nickName = model.nickName;
        addTime = model.addTime.stringValue;
        content = model.content;
    }
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:nil];
    
    [self.nameLabel setText:nickName];
    
    [self.timeLabel setText:[SMTimeTool stringFrom_SM_DBTimeInterval:addTime.integerValue dateFormat:@"yy-mm-dd     HH:mm"]];
    
    [self.commentLabel setText:content];
    
    CGSize size = [self.commentLabel.text newSizeWithFont:self.commentLabel.font
                                        constrainedToSize:CGSizeMake(self.commentLabel.frame.size.width, 2000.0)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    [self.commentLabel setFrame:CGRectMake(self.commentLabel.frame.origin.x,
                                           self.commentLabel.frame.origin.y,
                                           self.commentLabel.frame.size.width,
                                           size.height)];
    
    [self setFrame:CGRectMake(self.frame.origin.x,
                              self.frame.origin.y,
                              self.frame.size.width,
                              CGRectGetMaxY(self.commentLabel.frame) + 10.0)];
    
    
    [self.lineImage setFrame:CGRectMake(0.0, self.frame.size.height - .5, self.frame.size.width, .5)];
}
@end
