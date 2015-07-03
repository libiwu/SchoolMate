//
//  SMCircleDetailCell.h
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  每条评论 cell

#import <UIKit/UIKit.h>
#import "BBCommentModel.h"

@interface SMCircleDetailCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSMCircleDetailModel:(BBCommentModel *)model indexPath:(NSIndexPath *)indexPath;
@end
