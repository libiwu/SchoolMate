//
//  CCCommentModel.h
//  SchoolMate
//
//  Created by libiwu on 15/7/10.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  同学圈评论model

#import <Foundation/Foundation.h>
/*
 {
 "blogCommentId":2,
 "userBlogId":1,
 "addUserId":1,
 "content":"吃完再减肥?",
 "addTime":1435673533000,
 "nickName":"同学科技12",
 "headImageUrl":"http://120.24.169.36:8080/classmate_file/user/headimages/1/20150628052309378_39.jpg",
 "friendType":0,       （版本1先不用，朋友类型，0：普通朋友, 2：同学，默认为0）
 "friendSchoolType":0  （版本1先不用，朋友学校类型，1：小学同学，2：初中同学，3：高中同学，4：大学同学，0：不是同学。默认为0）
 }
 */
@interface CCCommentModel : NSObject
@property (nonatomic, strong) NSNumber *blogCommentId;
@property (nonatomic, strong) NSNumber *userBlogId;
@property (nonatomic, strong) NSNumber *addUserId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *addTime;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSNumber *friendType;
@property (nonatomic, strong) NSNumber *friendSchoolType;
@end
