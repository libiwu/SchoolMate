//
//  CCBlogModel.m
//  SchoolMate
//
//  Created by libiwu on 15/7/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "CCBlogModel.h"

@implementation CCBlogModel
MJCodingImplementation
+ (NSDictionary *)objectClassInArray {
    return @{@"images" : @"CCBlogImageModel"};
}
@end

@implementation CCBlogImageModel
MJCodingImplementation
@end