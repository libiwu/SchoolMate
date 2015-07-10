//
//  SMImageTool.h
//  SchoolMate
//
//  Created by libiwu on 15/7/11.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMImageTool : NSObject
/**
 *  压缩图片 可能会缩小图片尺寸
 *
 *  @param aSrcImage     图片Image
 *  @param aQuality      质量（0-1），1最高
 *  @param maxSize       图片image的size
 *  @param maxDataLength 图片存储大小，以K为单位
 *
 *  @return 图片二进制
 */
+(NSData *)compressImage:(UIImage *)aSrcImage       //原始图
              andQuality:(CGFloat)aQuality          //图片压缩质量
              andMaxSize:(CGSize)maxSize            //图片最大尺寸，宽*高
        andMaxDataLength:(NSUInteger)maxDataLength;
@end
