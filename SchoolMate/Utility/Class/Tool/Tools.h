//
//  Tools.h
//  OShopping
//
//  Created by Mac on 15/3/26.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  工具类

#import <Foundation/Foundation.h>

@interface Tools : NSObject

/**
 *  指定字体大小，获取字符串长度及高度
 */
+ (CGSize)getSizeOfString:(NSString *)string
                  andFont:(UIFont *)font
                  andSize:(CGSize)tempSize;

/**
 *  使用这句话的原因，是为了避免使用数据的时候出现空或者其他的，导致闪退
 */
+ (NSString *)filterNULLValue: (NSString *)string;

/**
 *  修改图片尺寸
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 *  格式化手機號碼
 */
+ (NSString *)formatPhoneNumberFromString:(NSString *)string;

/**
 *  得到本机现在用的语言
 *  en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
 */
+ (NSString*)getPreferredLanguage;

@end
