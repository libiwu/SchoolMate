//
//  SMPickerView.h
//  SchoolMate
//
//  Created by libiwu on 15/6/29.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPickerView : UIView
@property (nonatomic, strong) UIPickerView *pickerView;
- (instancetype)init;
/**
 *  显示
 */
- (void)show;
/**
 *  隐藏
 */
- (void)dismiss;
@end
