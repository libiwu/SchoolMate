//
//  UIImage+TestImage.h
//  TreatHelper
//
//  Created by 李必武 on 13-1-24.
//  Copyright (c) 2013年 李必武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Addition)

/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/   //压缩图片
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

//crop
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

//确认image的真实orientation
- (UIImage *)fixOrientation;

- (UIImage *)scaledImageV2WithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

+ (UIImage *)cellBackImage;
+ (UIImage *)placeholderImage_square;
+ (UIImage *)placeholderImage_rectangle;
@end
