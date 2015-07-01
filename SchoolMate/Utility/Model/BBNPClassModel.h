//
//  BBNPClassModel.h
//  SchoolMate
//
//  Created by libiwu on 15/7/2.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  黑板报班级model

#import <Foundation/Foundation.h>
/*
 {
 boardId = 6;
 className = Uu;
 createTime = 1435601049000;
 createUserId = 9;
 graduationYear = 1900;
 name = Uu;
 schoolName = Uu;
 schoolType = 2;
 }
 */
@interface BBNPClassModel : NSObject
@property (nonatomic, strong) NSNumber *boardId;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *createUserId;
@property (nonatomic, strong) NSString *graduationYear;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSNumber *schoolType;
@end
