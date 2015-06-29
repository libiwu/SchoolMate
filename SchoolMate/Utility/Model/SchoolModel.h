//
//  SchoolModel.h
//  SchoolMate
//
//  Created by libiwu on 15/6/27.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {"userClassId":5,"userId":1,"schoolType":2,"schoolName":"珠海二中","className":"初一3班","graduationYear":"1995","department":"","major":"","degree":null},
 */
@interface SchoolModel : NSObject
@property (nonatomic, strong) NSNumber *userClassId;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *schoolType;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *graduationYear;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *degree;
@end

/*  
 {"schoolTypeId":1,"name":"小学"},
 {"schoolTypeId":2,"name":"初中"},
 {"schoolTypeId":3,"name":"高中"},
 {"schoolTypeId":4,"name":"大学"}
 */
@interface SchoolTypeModel : NSObject
@property (nonatomic, strong) NSNumber *schoolTypeId;
@property (nonatomic, strong) NSString *name;
@end