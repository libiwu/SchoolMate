//
//  BBCommentModel.h
//  SchoolMate
//
//  Created by libiwu on 15/7/4.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  黑板报评论Model

#import <Foundation/Foundation.h>
/*
{
    addTime = 1435951614000;
    addUserId = 9;
    blogCommentId = 8;
    boardBlogId = 17;
    content = "\U8fc7\U5c4b\U660eU7a7a";
    headImageUrl = "http://120.24.169.36:8080/classmate_file/user/headimages/9/20150702010323845_50.png";
    mobileNo = 18500191316;
    nickName = "libiwu\U554a";
}
*/
@interface BBCommentModel : NSObject
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *addUserId;
@property (nonatomic, strong) NSString *blogCommentId;
@property (nonatomic, strong) NSString *boardBlogId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *mobileNo;
@property (nonatomic, strong) NSString *nickName;
@end
