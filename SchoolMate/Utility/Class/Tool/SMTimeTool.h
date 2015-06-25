//
//  SMTimeTool.h
//  SchoolMate
//
//  Created by libiwu on 15/6/25.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  操作时间

#import <Foundation/Foundation.h>

@interface SMTimeTool : NSObject
/*
 *  时间戳转换成时间字符串
 */
+ (NSString *)stringFrom_SM_DBTimeInterval:(NSTimeInterval)interval dateFormat:(NSString *)format;
/*
 *  NSDate转换成时间戳
 */
+ (NSTimeInterval)timeIntervalFrom_SM_Time:(NSDate *)date;
/*
 *  字符串转换成时间戳
 */
+ (NSTimeInterval)timeIntervalFrom_SM_TimeString:(NSString *)time dateFormat:(NSString *)format;
@end
