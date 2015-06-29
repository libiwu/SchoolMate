//
//  SMPickerView.m
//  SchoolMate
//
//  Created by libiwu on 15/6/29.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMPickerView.h"

@interface SMPickerView ()
@property (nonatomic, strong) UIImageView *backView;
@end

@implementation SMPickerView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    self.frame = AppWindow.frame;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setFrame:self.frame];
    WEAKSELF
    [btn bk_addEventHandler:^(id sender) {
        [weakSelf dismiss];
    } forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    CGFloat hei = 200;
    self.backView =
    ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, hei)];
        imageView.backgroundColor = RGBACOLOR(110.0, 200.0, 243.0, 0.8);
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    [self addSubview:self.backView];
    
    UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.backView.frame.size.width, self.backView.frame.size.height)];
    [self.backView addSubview:pick];
    self.pickerView = pick;
}
#pragma mark -
/**
 *  显示
 */
- (void)show {
    self.backView.frame = CGRectMake(self.backView.frame.origin.x,
                                       [UIScreen mainScreen].bounds.size.height,
                                       self.backView.frame.size.width,
                                       self.backView.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:.26
                     animations:^{
                         [self.backView setFrame:CGRectMake(self.backView.frame.origin.x,
                                                              [UIScreen mainScreen].bounds.size.height - self.backView.frame.size.height,
                                                              self.backView.frame.size.width,
                                                              self.backView.frame.size.height)];
                     } completion:^(BOOL finished) {
                         
                     }];
}
/**
 *  隐藏
 */
- (void)dismiss {
    
    __weak SMPickerView *weakSelf = self;
    
    [UIView animateWithDuration:.26 animations:^{
        [self.backView setFrame:CGRectMake(self.backView.frame.origin.x,
                                             [UIScreen mainScreen].bounds.size.height,
                                             self.backView.frame.size.width,
                                             self.backView.frame.size.height)];
        weakSelf.alpha = .0;
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}
@end
