//
//  CCBlogModel.h
//  SchoolMate
//
//  Created by libiwu on 15/7/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  同学圈blog model

#import <Foundation/Foundation.h>
/*
 {
 commentCount = 0;
 content = "\U6211\U4eec\U5f53\U65f6\U65c5\U6e38\U7684\U56fe\U7247";
 createTime = 1435983923000;
 friendSchoolType = 0;
 friendType = 0;
 headImageUrl = "http://120.24.169.36:8080/classmate_file/user/headimages/1/20150628052309378_39.jpg";
 images =             (
 {
 blogImageId = 17;
 imageUrl = "http://120.24.169.36:8080/classmate_file/user/blog/10/images/1/20150704122523477_19.";
 name = "";
 uploadTime = 1435983919000;
 userBlogId = 10;
 },
 {
 blogImageId = 18;
 imageUrl = "http://120.24.169.36:8080/classmate_file/user/blog/10/images/2/20150704122523537_45.";
 name = "";
 uploadTime = 1435983919000;
 userBlogId = 10;
 }
 );
 isLike = 0;
 isPublic = 1;
 labels = "<null>";
 likeCount = 0;
 location = "\U5e7f\U4e1c\U7701\U73e0\U6d77\U5e02\U9999\U6d32\U533a\U5149\U5927\U56fd\U8d38";
 nickName = "\U540c\U5b66\U79d1\U628012";
 userBlogId = 10;
 userId = 1;
 visibleType = 1;
 },
 */
@interface CCBlogModel : NSObject
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *friendSchoolType;
@property (nonatomic, strong) NSNumber *friendType;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSNumber *isLike;
@property (nonatomic, strong) NSNumber *isPublic;
@property (nonatomic, strong) NSString *labels;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSNumber *userBlogId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *visibleType;
@end


@interface CCBlogImageModel : NSObject
@property (nonatomic, strong) NSNumber *blogImageId;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *uploadTime;
@property (nonatomic, strong) NSNumber *userBlogId;
@end