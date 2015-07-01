//
//  BBNPModel.m
//  SchoolMate
//
//  Created by libiwu on 15/7/2.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "BBNPModel.h"

@implementation BBNPModel
MJCodingImplementation
+ (NSDictionary *)objectClassInArray {
    return @{@"images" : @"BBNPImageModel"};
}
@end


@implementation BBNPImageModel
MJCodingImplementation
@end