//
//  GlobalManager.h
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface GlobalManager : NSObject

@property (nonatomic, weak) UIViewController *currentViewController;

@property (nonatomic, strong) UserInfoModel *userInfo;
//同学圈班级列表
@property (nonatomic, strong) NSArray *classArray;

+ (instancetype)shareGlobalManager;
@end
