//
//  NewspaperTableViewCell.h
//  SchoolMate
//
//  Created by SuperDanny on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBNPModel.h"


@interface NewspaperTableViewCell : UITableViewCell

@property (strong, nonatomic) BBNPModel *model;
+ (CGFloat)configureCellHeightWithModel:(BBNPModel *)model;
- (void)setContentWithModel:(BBNPModel *)model;

@end
