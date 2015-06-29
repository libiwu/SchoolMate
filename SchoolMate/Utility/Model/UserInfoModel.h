//
//  UserInfoModel.h
//  SchoolMate
//
//  Created by SuperDanny on 15/6/22.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  用户信息

#import <Foundation/Foundation.h>
#import "SchoolModel.h"
/*
 {"receiverName":"张三2","receiverMobileNo":"13868767777","receiverRegion":"广东 珠海 香洲区","receiverAddress":"东大新城2栋301","receiverPostcode":"59300"}
 */
@interface AddressModel : NSObject
@property (nonatomic, copy  ) NSString *receiverName;
@property (nonatomic, copy  ) NSString *receiverMobileNo;
@property (nonatomic, copy  ) NSString *receiverRegion;
@property (nonatomic, copy  ) NSString *receiverAddress;
@property (nonatomic, copy  ) NSString *receiverPostcode;
@end

/*
 {
 "userId":1,
 "mobileNo":"13802676527",
 "email":"4555555@tx.com",
 "nickName":"同学科技",
 "realName":"布耀孝",
 "gender":"男",
 "headImageUrl":"http://localhost:8080/classmate_file/user/headimages/1/20150605114332567_22.jpg",
 "backgroundImageUrl":"http://localhost:8080/classmate_file/user/backgroundimages/1/20150605114801301_48.jpg",
 "signature":"那年匆匆的岁月","birthday":1435161600000,
 "company":"珠海同学科技有限公司",
 "position":"项目经理",
 "address":{"receiverName":"张三2","receiverMobileNo":"13868767777","receiverRegion":"广东 珠海 香洲区","receiverAddress":"东大新城2栋301","receiverPostcode":"59300"}
 }
 */
@interface UserInfoModel : NSObject
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy  ) NSString *mobileNo;
@property (nonatomic, copy  ) NSString *email;
@property (nonatomic, copy  ) NSString *nickName;
@property (nonatomic, copy  ) NSString *realName;
@property (nonatomic, copy  ) NSString *gender;
@property (nonatomic, copy  ) NSString *headImageUrl;
@property (nonatomic, copy  ) NSString *backgroundImageUrl;
@property (nonatomic, copy  ) NSString *signature;
@property (nonatomic, strong) NSNumber *birthday;
@property (nonatomic, strong) AddressModel *address;
@property (nonatomic, copy  ) NSString *company;
@property (nonatomic, copy  ) NSString *position;
@property (nonatomic, strong) SchoolModel *userClass;
@end

