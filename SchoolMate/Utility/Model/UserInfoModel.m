//
//  UserInfoModel.m
//  SchoolMate
//
//  Created by SuperDanny on 15/6/22.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "UserInfoModel.h"


@implementation AddressModel
MJCodingImplementation
@end

@implementation UserInfoModel
MJCodingImplementation
+ (NSDictionary *)objectClassInArray {
    return @{@"AddressModel" : @"address",
             @"SchoolModel" : @"userClass"};
}
//@property (nonatomic, strong) NSNumber *userId;
//@property (nonatomic, copy  ) NSString *mobileNo;
//@property (nonatomic, copy  ) NSString *email;
//@property (nonatomic, copy  ) NSString *nickName;
//@property (nonatomic, copy  ) NSString *realName;
//@property (nonatomic, copy  ) NSString *gender;
//@property (nonatomic, copy  ) NSString *headImageUrl;
//@property (nonatomic, copy  ) NSString *backgroundImageUrl;
//@property (nonatomic, copy  ) NSString *signature;
//@property (nonatomic, strong) NSNumber *birthday;
//@property (nonatomic, strong) AddressModel *address;
//@property (nonatomic, copy  ) NSString *company;
//@property (nonatomic, copy  ) NSString *position;
//@property (nonatomic, strong) SchoolModel *userClass;
- (NSString *)mobileNo {
    return _mobileNo ? _mobileNo : @"";
}
- (NSString *)email {
    return _email ? _email : @"";
}
- (NSString *)nickName {
    return _nickName ? _nickName : @"";
}
- (NSString *)realName {
    return _realName ? _realName : @"";
}
- (NSString *)gender {
    return _gender ? _gender : @"";
}
- (NSString *)headImageUrl {
    return _headImageUrl ? _headImageUrl : @"";
}
- (NSString *)backgroundImageUrl {
    return _backgroundImageUrl ? _backgroundImageUrl : @"";
}
- (NSString *)signature {
    return _signature ? _signature : @"";
}
- (NSString *)company {
    return _company ? _company : @"";
}
- (NSString *)position {
    return _position ? _position : @"";
}
- (NSNumber *)birthday {
    return _birthday ? _birthday : @(0);
}
@end


