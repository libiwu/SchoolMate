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
    return @{@"AddressModel" : @"Address"};
}
@end


