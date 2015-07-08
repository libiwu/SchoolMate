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
typedef void(^DeleteClick)(UIButton *btn);

@interface NewspaperTableViewCell : UITableViewCell

@property (strong, nonatomic) BBNPModel *bbnpModel;
@property (nonatomic, copy  ) SupportClick supportBlock;
@property (nonatomic, copy  ) CommentClick commentBlock;
@property (nonatomic, copy  ) DeleteClick deleteBlock;
///喜欢总数
@property (weak, nonatomic) IBOutlet UILabel        *likeCountLab;
@property (weak, nonatomic) IBOutlet UIView         *rightMainBgView;
@property (weak, nonatomic) IBOutlet UIImageView    *lineImageV;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteBtn:(id)sender;
+ (CGFloat)configureCellHeightWithModel:(BBNPModel *)model;

- (void)setContentWithModel:(BBNPModel *)model;

- (void)setSupportAction:(SupportClick)support;
- (void)setCommentAction:(CommentClick)comment;
- (void)setDeleteAction:(DeleteClick)deleteAction;
@end
