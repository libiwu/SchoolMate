//
//  SCImagesPickerController.h
//  AssetsLibraryPra1
//
//  Created by 庞东明 on 10/14/14.
//  Copyright (c) 2014 ZhongAo. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kDidFinishedPickingImagesNotification;//完成选择
extern NSString *kDidCanceledPickingImagesNotification;//取消选择

@class SCImagesPickerController;

@protocol SCImagesPickerControllerDelegate <NSObject>

- (void)imagesPickerController:(SCImagesPickerController *)picker didFinishPickingImages:(NSArray *)images;

- (void)imagesPickerControllerDidCancel:(SCImagesPickerController *)picker;

@end


@interface SCImagesPickerController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic,assign) NSUInteger maxPhotosCount;//可选择最大照片数量

@property (nonatomic,assign) id<UINavigationControllerDelegate,SCImagesPickerControllerDelegate> delegates;

@end
