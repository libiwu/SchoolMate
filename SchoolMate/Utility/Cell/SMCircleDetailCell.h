//
//  SMCircleDetailCell.h
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  每条评论 cell

#import <UIKit/UIKit.h>

@interface SMCircleDetailCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSMCircleDetailModel:(id)object indexPath:(NSIndexPath *)indexPath;
@end
