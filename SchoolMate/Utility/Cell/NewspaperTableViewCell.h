//
//  NewspaperTableViewCell.h
//  SchoolMate
//
//  Created by SuperDanny on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBNPModel.h"

typedef void(^SupportClick)(UIButton *btn);
typedef void(^CommentClick)(UIButton *btn);

@interface NewspaperTableViewCell : UITableViewCell

@property (strong, nonatomic) BBNPModel *model;
@property (nonatomic, copy  ) SupportClick supportBlock;
@property (nonatomic, copy  ) CommentClick commentBlock;
///喜欢总数
@property (weak, nonatomic) IBOutlet UILabel        *likeCountLab;
@property (weak, nonatomic) IBOutlet UIView         *rightMainBgView;
@property (weak, nonatomic) IBOutlet UIImageView    *lineImageV;
+ (CGFloat)configureCellHeightWithModel:(BBNPModel *)model;

- (void)setContentWithModel:(BBNPModel *)model;

- (void)setSupportAction:(SupportClick)support;

- (void)setCommentAction:(CommentClick)comment;
@end
