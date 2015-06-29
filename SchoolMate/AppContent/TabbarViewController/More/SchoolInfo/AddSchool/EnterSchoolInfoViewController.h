//
//  EnterSchoolInfoViewController.h
//  SchoolMate
//
//  Created by libiwu on 15/6/27.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  添加学校-输入学校信息

#import "SCBasicViewController.h"
#import "SchoolModel.h"

typedef NS_ENUM(NSUInteger, ViewType) {
    //添加学校
    ViewTypeAdd = 0,
    //修改学校信息
    ViewTypeEdit
};

@interface EnterSchoolInfoViewController : SCBasicViewController
@property (nonatomic, assign) ViewType viewtype;
@property (nonatomic, strong) SchoolTypeModel *schoolType;
@property (nonatomic, strong) SchoolModel *schoolModel;
@end
