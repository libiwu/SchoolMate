//
//  SMImageTool.m
//  SchoolMate
//
//  Created by libiwu on 15/7/11.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMImageTool.h"
#import "UIImage+Addition.h"
@implementation SMImageTool
+(NSData *)compressImage:(UIImage *)aSrcImage       //原始图
              andQuality:(CGFloat)aQuality          //图片压缩质量
              andMaxSize:(CGSize)maxSize            //图片最大尺寸，宽*高
        andMaxDataLength:(NSUInteger)maxDataLength{
    
    if (aSrcImage == nil) {
        return nil;
    }
    NSUInteger imageSize = maxDataLength;
    NSData *ret = nil;
    
    if (aQuality>1 || aQuality < 0.3){
        aQuality = 0.65;
    }
    
    NSLog(@"<_compressAndSend> ========== Start ==========");
    UIImage *image = aSrcImage;
    CGSize sizeBig = aSrcImage.size;
    CGFloat maxLength = (maxSize.width > maxSize.height ? maxSize.width : maxSize.height);
    double rateW = maxLength/sizeBig.width;
    double rateH = maxLength/sizeBig.height;
    double rate = rateW<rateH?rateW:rateH;
    
    image = [aSrcImage scaledImageWithWidth:sizeBig.width*rate andHeight:sizeBig.height*rate];
    NSLog(@"<_compressAndSend> 图片尺寸压缩到 = %f x %f",image.size.width,image.size.height);
    
    //原始图片文件体积
    NSData *data = UIImageJPEGRepresentation(image,aQuality);
    NSLog(@"<_compressAndSend> UIImageJPEGRepresentation(image,aQuality)图片文件大小%lu,直接发送",(unsigned long)[data length]);
    
    //如果文件体积小于100k  直接发送
    if ([data length] < 1024 * imageSize){
        NSLog(@"<_compressAndSend> 图片文件体积小于100K,直接发送");
        ret = data;
    }else{
        NSLog(@"<_compressAndSend> 图片文件体积大于100K,准备压缩后发送");
        NSData *data  = UIImageJPEGRepresentation(image,aQuality);
        NSInteger i = 1;
        while([data length] > 1024 *imageSize)
        {
            NSLog(@"<_compressAndSend> 正在进行第%ld次压缩,压缩前文件体积：%lu",(long)i,(unsigned long)[data length]);
            
            
            rate = rate * 0.8;
            image = [aSrcImage scaledImageWithWidth:sizeBig.width * rate andHeight:sizeBig.height * rate];
            
            data = UIImageJPEGRepresentation(image,aQuality);
            NSLog(@"<_compressAndSend> 第%ld次压缩完成,压缩后文件体积：%lu",(long)i,(unsigned long)[data length]);
            
            i++;
        }
        ret = data;
    }
    return ret;
}

@end
