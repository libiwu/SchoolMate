//
//  CCSupportModel.h
//  SchoolMate
//
//  Created by libiwu on 15/7/10.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  同学圈点赞model
#import <Foundation/Foundation.h>
/*
 {
 "blogLikeId":7,
 "userBlogId":1,
 "addUserId":2,
 "addTime":1435984283000,
 "mobileNo":"555",
 "nickName":"B",
 "headImageUrl":null}
 */
@interface CCSupportModel : NSObject
@property (nonatomic, strong) NSNumber *blogLikeId;
@property (nonatomic, strong) NSNumber *userBlogId;
@property (nonatomic, strong) NSNumber *addUserId;
@property (nonatomic, strong) NSNumber *addTime;
@property (nonatomic, strong) NSString *mobileNo;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headImageUrl;
@end
