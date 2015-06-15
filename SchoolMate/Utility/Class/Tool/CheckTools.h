//
//  CheckTools.h
//  DLMacaoApp
//
//  Created by libiwu on 14-6-19.
//  Copyright (c) 2014年 andy_wu. All rights reserved.
//
//  逻辑检查工具

#import <Foundation/Foundation.h>

//相机、相册、麦克风、通讯录
typedef enum : NSUInteger {
    ///相机权限
    CameraPermissions,
    ///相册权限
    PhotoPermissions,
    ///麦克风权限
    MicrophonePermissions,
    ///通讯录权限
    AddressBookPermissions,
} PermissionsType;

@interface CheckTools : NSObject
/**
 *  检查网络
 *
 *  @return yes==网络畅通。no=网络不可用
 */
+ (BOOL)checkNetWork;
/**
 *  只能输入数字
 *
 *  @param str
 */
+ (BOOL)isNumber:(NSString *)str;
/**
 *  只能输入数字小数点
 *
 *  @param str sf
 *
 *  @return asdf
 */
+ (BOOL)isCountNumber:(NSString *)str;
/**
 *  检查字符串是否是身份证号
 *
 *  @param identityCard 身份证
 *
 */
+ (BOOL)isValidateIdentityCard:(NSString *)identityCard;
/**
 *  检查密碼格式(字符和数字)
 *
 *  @param key 密碼
 */
+ (BOOL)isValidateKeyNum:(NSString *)key;
/**
 *  检测邮箱是否合法
 *
 *  @param candidate 邮箱
 */
+ (BOOL)isValidateEmail: (NSString *) candidate;
/**
 *  检测手机号是否合法
 *
 *  @param str 手机号
 */
+ (BOOL)isValidateMobileNumber: (NSString *)mobileNum countryCode: (NSString *)countryCode;
/**
 *  检测登陆用户名是否合法
 *
 *  @param str
 */
+ (BOOL)isLoginAccount:(NSString *)account;
/**
 *  真实姓名，汉字
 *
 *  @param str
 */
+ (BOOL)isRealName:(NSString *)realname;
/**
 *  判断是否为整型
 */
+ (BOOL)isPureInt:(NSString*)string;
/**
 *  判断是否为浮点型
 */
+ (BOOL)isPureFloat:(NSString*)string;
/**
 *  判断手机权限（相机、相册、麦克风、通讯录）
 *
 *  @param type 权限类型
 *
 *  @return 是否开启权限
 */
+ (BOOL)isPermissionsWithType:(NSUInteger)type;

+ (UIImage *)cellBackImage:(UIImage *)image;
@end
