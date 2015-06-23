//
//  UserInfoModel.h
//  SchoolMate
//
//  Created by SuperDanny on 15/6/22.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  用户信息

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic, copy  ) NSString *receiverName;
@property (nonatomic, copy  ) NSString *receiverMobileNo;
@property (nonatomic, copy  ) NSString *receiverRegion;
@property (nonatomic, copy  ) NSString *receiverAddress;
@property (nonatomic, copy  ) NSString *receiverPostcode;
@end

/*
 "userId":1,"mobileNo":
 "13802676527",
 "userName":"Tongxuekeji",
 "email":"4555555@tx.com",
 "password":"e1adc3949ba59abbe56e057f2f883e",
 "registTime":1433518751000,
 "registIp":"192.168.1.105",
 "lastLoginTime":null,
 "lastLoginIp":null,
 "loginCount":0,
 "isLock":0,
 "lockStartime":null,
 "lockPeriod":null,
 "nickName":"同学科技",
 "realName":"布耀孝",
 "gender":"男",
 "headImageUrl":null,
 "backgroundImageUrl":null,
 "signature":"那年匆匆的岁月",
 "birthday":339177600000,
 "country":null,
 "province":"广东",
 "city":"珠海",
 "district":null,
 "address":"香洲区东大新村",
 "postcode":"59300",
 "company":"珠海同学科技有限公司",
 "position":null,
 "occupation":"漫画家"
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
@property (nonatomic, copy  ) NSString *occupation;
@end

