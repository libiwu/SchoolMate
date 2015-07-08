//
//  SMTimeTool.m
//  SchoolMate
//
//  Created by libiwu on 15/6/25.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMTimeTool.h"

@implementation SMTimeTool
#pragma mark 时间戳装换成时间字符串
+ (NSString *)stringFrom_SM_DBTimeInterval:(NSTimeInterval)interval dateFormat:(NSString *)format{
    //因为时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeInterval value = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: value];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    NSString * newstr = [formatter stringFromDate:localeDate];
    return newstr;
}
#pragma mark 字符串装换成时间戳
+ (NSTimeInterval)timeIntervalFrom_SM_Time:(NSDate *)date {
    NSTimeInterval interval = [date timeIntervalSince1970];
    return interval * 1000;
}
+ (NSTimeInterval)timeIntervalFrom_SM_TimeString:(NSString *)time dateFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    
    NSDate *date = [formatter dateFromString:time];
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    return interval * 1000;
}
@end
