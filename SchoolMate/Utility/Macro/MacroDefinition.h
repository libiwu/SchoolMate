//
//  MacroDefinition.h
//  OShopping
//
//  Created by libiwu on 15/3/24.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  宏定义

#ifndef OShopping_MacroDefinition_h
#define OShopping_MacroDefinition_h

#pragma mark - 宏定义

#define RGBACOLOR(r,g,b,a)              [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLOR(r,g,b)                 [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((0xFF0000 & 0xFF0000) >> 16))/255.0 green:((float)((0xFF0000 & 0xFF00) >> 8))/255.0 blue:((float)(0xFF0000 & 0xFF))/255.0 alpha:1.0];

#define CurrentViewController           [GlobalManager shareGlobalManager].currentViewController
#define AppWindow                       [UIApplication sharedApplication].delegate.window
#define IS_IOS7                         (IOS_VERSION >= 7.0)
#define IOS_VERSION                     [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPAD                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_iPhone5                      CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
/**
 *  友盟
 */
#define UmengKey                        @"5547460a67e58ed9c20022b3"
/**
 *  生成二维码时,拼接字符串用到的 key
 */
#define ScanSeparateKey                 @"{*$*}"
/**
 *  生成请求所带的userInfo
 */
#define UserInfoKey_AFNetWorking        @"AFNetWorking_UserInfoKey"
#define AFNet_UserInfo(a)               [NSDictionary dictionaryWithObjectsAndKeys:a,UserInfoKey_AFNetWorking,nil]

/**
 *  NSUserDefaults
 */
#define NSUser_Defaults_set(a,b)        [[NSUserDefaults standardUserDefaults] setObject:a forKey:b];[[NSUserDefaults standardUserDefaults] synchronize]
#define NSUser_Defaults_get(a)          [[NSUserDefaults standardUserDefaults] objectForKey:a]
#define NSUser_Defaults_remove(a)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:a];[[NSUserDefaults standardUserDefaults] synchronize]
/**
 *  尺寸
 */
#define KScreenHeight                   [[UIScreen mainScreen] bounds].size.height
#define KScreenWidth                    [[UIScreen mainScreen] bounds].size.width
#define kTabBarHeight                   49.0f
#define kNavBarHeight                   44.0f

/**
 *  保存图案密码key
 */
//#define GESTURE_PASSWORD_KEY    [NSString stringWithFormat:@"GESTURE_PASSWORD_KEY_%@%@",[LoginModel shareLoginModel].countryCode, [LoginModel shareLoginModel].mobile]
#define GESTURE_PASSWORD_KEY    @"GESTURE_PASSWORD_KEY_"
/**
 * 获取控件到视图边缘高度和宽度
 */
#define CURRENT_ORIGIN_X(lastView)  (lastView.frame.origin.x + lastView.frame.size.width)
#define CURRENT_ORIGIN_Y(lastView)  (lastView.frame.origin.y + lastView.frame.size.height)

// block self
#define WEAKSELF                        typeof(self) __weak weakSelf = self;
#define STRONGSELF                      typeof(weakSelf) __strong strongSelf = weakSelf;

#pragma mark - 缓存路径

#define PATH_TO_STORE_IMAGE             [[NSHomeDirectory() stringByAppendingPathComponent:@"/Library"] stringByAppendingPathComponent:@"/Caches/image"]
#define PATH_TO_STORY_READ              [[NSHomeDirectory() stringByAppendingPathComponent:@"/Library"] stringByAppendingPathComponent:@"/Read.plist"]
// tmp目录
#define TMP_DIRECTORY                   [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
// caches目录
#define CACHES_DIRECTORY                [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"]


/**
 *  自定义全局释放变量
 */
#define RELEASE_OBJECT__(_OBJ_) ( {if(_OBJ_){[_OBJ_ release]; _OBJ_ = nil;}})
#define RELEASE_VIEW_(_VIEW_) ({if(_VIEW_ && _VIEW_.superview){[_VIEW_ removeFromSuperview];[_VIEW_ release];_VIEW_ = nil;}})


/**
 *  自定义宏输出
 */
#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog(@"< %s -> %@",__func__,[NSString stringWithFormat:fmt, ##__VA_ARGS__]);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif

#endif
