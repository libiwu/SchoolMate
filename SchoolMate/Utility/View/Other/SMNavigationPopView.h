//
//  SMNavigationPopView.h
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tableViewSelectBlock)(NSUInteger index, NSString *string);

@interface SMNavigationPopView : UIView

@property (nonatomic, copy  ) tableViewSelectBlock  selectBlock;

- (instancetype)initWithDataArray:(NSArray *)array;
- (void)setTableViewCenter:(CGPoint)point;
/**
 *  显示
 */
- (void)show;
/**
 *  隐藏
 */
- (void)dismiss;

- (void)setTableViewSelectBlock:(tableViewSelectBlock)block;
@end
