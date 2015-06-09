//
//  NSString+Addition.h
//  OShopping
//
//  Created by libiwu on 15/4/23.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)
/**
 *  MD5转换
 */
- (NSString *)MD5;
/**
 *  计算 size
 */
- (CGSize)newSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end
