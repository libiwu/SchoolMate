//
//  BBNPModel.h
//  SchoolMate
//
//  Created by libiwu on 15/7/2.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  黑板报model

#import <Foundation/Foundation.h>
/*
 {
 addLocation = "";
 addTime = 1435770577000;
 addUserId = 9;
 blogType = 2;
 boardBlogId = 12;
 boardId = 5;
 commentCount = 0;
 content = "The ";
 headImageUrl = "http://120.24.169.36:8080/classmate_file/user/headimages/9/20150702010323845_50.png";
 images =             (
 {
 blogImageId = 16;
 boardBlogId = 12;
 imageUrl = "http://120.24.169.36:8080/classmate_file/board/blog/12/images/1/20150702010936924_63.jpg";
 },
 {
 blogImageId = 17;
 boardBlogId = 12;
 imageUrl = "http://120.24.169.36:8080/classmate_file/board/blog/12/images/2/20150702010936937_34.jpg";
 }
 );
 isLike = 0;
 likeCount = 0;
 mobileNo = 18500191316;
 nickName = libiwu;
 photoDate = "<null>";
 photoLocation = "";
 }
 */
@interface BBNPModel : NSObject
@property (nonatomic, strong) NSString *addLocation;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *addUserId;
@property (nonatomic, strong) NSString *blogType;
@property (nonatomic, strong) NSString *boardBlogId;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSArray *images;
// 0 未赞    1 已赞
@property (nonatomic, strong) NSString *isLike;
@property (nonatomic, strong) NSString *likeCount;
@property (nonatomic, strong) NSString *mobileNo;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *photoDate;
@property (nonatomic, strong) NSString *photoLocation;
@end

@interface BBNPImageModel : NSObject
@property (nonatomic, strong) NSString *blogImageId;
@property (nonatomic, strong) NSString *boardBlogId;
@property (nonatomic, strong) NSString *imageUrl;
@end
