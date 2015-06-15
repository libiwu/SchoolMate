//
//  SMDatePickPopView.m
//  SchoolMate
//
//  Created by libiwu on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMDatePickPopView.h"

@implementation SMDatePickPopView
- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = AppWindow.frame;
        
        [self setUp];
    }
    return self;
}
- (void)setUp {
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setFrame:self.frame];
        WEAKSELF
        [btn bk_addEventHandler:^(id sender) {
            [weakSelf dismiss];
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, 270.0, 180.0)];
    backImage.backgroundColor = RGBACOLOR(110.0, 200.0, 243.0, 0.9);
    backImage.userInteractionEnabled = YES;
    [self addSubview:backImage];
    
    self.datePicker = ({
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(-20.0,
                                                                             -20.0,
                                                                             backImage.frame.size.width,
                                                                             backImage.frame.size.height)];
        picker.backgroundColor = [UIColor clearColor];
        picker.datePickerMode = UIDatePickerModeDate;
        [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [backImage addSubview:picker];
        picker;
    });
    
    
    backImage.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
}
#pragma mark - Action
- (void)dateChanged:(UIDatePicker *)picker {
    if (self.valueChangeBlock) {
        self.valueChangeBlock(picker);
    }
}
#pragma mark -
/**
 *  显示
 */
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
/**
 *  隐藏
 */
- (void)dismiss {
    
    __weak SMDatePickPopView *weakSelf = self;
    
    [UIView animateWithDuration:.26 animations:^{
        
        weakSelf.alpha = .0;
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}
- (void)setValueChange:(DataPickerValueChange)block {
    _valueChangeBlock = block;
}
@end
