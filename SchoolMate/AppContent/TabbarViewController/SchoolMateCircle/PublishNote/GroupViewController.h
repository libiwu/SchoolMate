//
//  GroupViewController.h
//  SchoolMate
//
//  Created by libiwu on 15/6/16.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  笔记分组 (广播,同班可见,同级可见,同校可见)

#import "SCBasicViewController.h"
#import "BBNPClassModel.h"

typedef void(^SelectBlock)(BBNPClassModel *model,NSIndexPath *indexPath);

@interface GroupViewController : SCBasicViewController
@property (nonatomic, copy  ) SelectBlock selectBlock;
- (void)setSelectBlock:(SelectBlock)selectBlock;
@end
