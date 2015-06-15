//
//  SCPageViewController.h
//  SCImagesViewer
//  单一页面查看多张图片，和删除图片
//  Created by 庞东明 on 10/14/14.
//  Copyright (c) 2014 ZhongAo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPageViewController : UIPageViewController <UIPageViewControllerDataSource>

@property NSInteger startingIndex;//开始的页面索引 0,1,2...

@property (nonatomic,strong) NSMutableArray *imagesArray;//照片数据源(可删除操作)
- (void)setNavTitle:(NSString *)title;
@end
