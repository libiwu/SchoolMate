//
//  Tools.m
//  OShopping
//
//  Created by Mac on 15/3/26.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>

#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define CC_MD5_Length               32

@implementation Tools

#pragma mark 获取一个字符串的宽高
+ (CGSize)getSizeOfString:(NSString *)string
                  andFont:(UIFont *)font
                  andSize:(CGSize)tempSize{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize size = [string boundingRectWithSize:tempSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return size;
    }
    else{
        CGSize size = [string sizeWithFont:font constrainedToSize:tempSize lineBreakMode:NSLineBreakByWordWrapping];
        return size;
    }
}

#pragma mark 使用这句话的原因，是为了避免使用数据的时候出现空或者其他的，导致闪退
+ (NSString *)filterNULLValue: (NSString *)string {
    
    NSString * newStr = [NSString stringWithFormat:@"%@",string];
    if ([newStr isKindOfClass:[NSNull class]] ||
        newStr == nil ||
        [newStr isEqualToString:@"(null)"]||
        [newStr isEqualToString:@""] ||
        [newStr isEqualToString:@"null"] ||
        [newStr isEqualToString:@"<null>"]) {
        newStr = @"";
    }
    return newStr;
}

#pragma -mark 图片压缩
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
#pragma mark 转换数据库的时间格式
+ (NSString *)stringFrom_OS_DBTimeString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date = [formatter dateFromString:string];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * newstr = [formatter stringFromDate:date];
    return newstr;
}

#pragma mark - 格式化手機號碼
+ (NSString *)formatPhoneNumberFromString:(NSString *)string {
    /*
     *  先計算字符串每4位一组之后剩餘幾位數
     *  然后从剩余位数之后开始每4位增加一个空格
     *  最後再將字符串重新整理
     */
    string = [Tools filterNULLValue:string];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableString *str = [NSMutableString string];
    
    if (string.length >= 5) {
        //每隔4位增加一个空格
        NSUInteger dlgit = 4;
        //获取组数
        NSUInteger group = string.length/dlgit;
        //剩余几位
        NSUInteger remainder = string.length%dlgit;
        
//        将字符串拆分成group+1组存在数组里面
        NSMutableArray *tempArr = [NSMutableArray array];
        NSRange rang;
        rang.length = remainder;
        rang.location = 0;
        //将不足4位的先存起来
        [tempArr addObject:[string substringWithRange:rang]];
        
        [str insertString:[string substringWithRange:rang] atIndex:str.length];
        
        //然后再将满足4位的存起来
        for (int i = 0; i < group; i++) {
            rang.length = dlgit;
            rang.location = remainder+i*dlgit;
            
            NSString *tempStr = [string substringWithRange:rang];
            
            [str insertString:@" " atIndex:str.length];
            [str insertString:tempStr atIndex:str.length];
//            [tempArr addObject:@" "];
//            [tempArr addObject:tempStr];
        }
        DLog(@"%@",str);
    }
    else {
        str = [NSMutableString stringWithString:string];
    }
    return str;
}
/*
+ (NSString *)numberStringFromString:(NSString *)remainAmount{
    remainAmount = [Tools filterNULLValue:remainAmount];
    remainAmount = [remainAmount stringByReplacingOccurrencesOfString:@"" withString:@" "];
    NSString *numberString = nil;
    NSDecimalNumber *remainNumber = [NSDecimalNumber decimalNumberWithString:remainAmount];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.currencySymbol = @"";//符号
    formatter.positiveFormat = @" ####";
    numberString = [formatter stringFromNumber:remainNumber];
    return numberString;
}
*/

// en:英文 zh-Hans:简体中文 zh-Hant:繁体中文 zh-HK:繁体香港
+ (NSString*)getPreferredLanguage
{
    NSUserDefaults *defs    = [NSUserDefaults standardUserDefaults];
    NSArray *languages      = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

@end
