//
//  NSString+Addition.m
//  OShopping
//
//  Created by libiwu on 15/4/23.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonCrypto.h>

#define IOS7     [[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@implementation NSString (Addition)
- (NSString *)MD5 {
    if(self.length == 0) {
        return nil;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}
- (CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
#ifdef IOS7
    CGRect newRect = [self boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName: font}
                                        context:nil];
    return newRect.size;
#else
    CGSize newSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    return newSize;
#endif
}
@end
