//
//  TrueNameViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "TrueNameViewController.h"

@interface TrueNameViewController ()

@end

@implementation TrueNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"更改姓名", nil)];
    
    [self createContentView];
    
    self.view.backgroundColor = RGBCOLOR(255.0, 255.0, 255.0);
}
- (void)createContentView {
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 15.0, KScreenWidth, 44.0)];
    backImage.userInteractionEnabled = YES;
    backImage.backgroundColor = RGBCOLOR(230.0, 230.0, 230.0);
    
    [self.view addSubview:backImage];
    
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 44.0)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.textAlignment = NSTextAlignmentCenter;
    leftView.textColor = [UIColor blackColor];
    leftView.text = NSLocalizedString(@"真实姓名", nil);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0,
                                                                          0.0,
                                                                          backImage.frame.size.width,
                                                                          backImage.frame.size.height)];
    textField.placeholder = NSLocalizedString(@"输入姓名", nil);
    textField.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    [backImage addSubview:textField];
    
    CGRect rect ;
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:RGBCOLOR(230.0, 230.0, 230.0)];
        [btn.layer setCornerRadius:4.0];
        [btn setTitle:NSLocalizedString(@"不公开", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn bk_addEventHandler:^(id sender) {
            [SMMessageHUD showMessage:NSLocalizedString(@"不公开", nil) afterDelay:1.0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(30.0, CGRectGetMaxY(backImage.frame) + 25.0, 230.0/2, 30.0)];
        [self.view addSubview:btn];
        rect = btn.frame;
    }
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn.layer setCornerRadius:4.0];
        [btn setTitle:NSLocalizedString(@"公开", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn bk_addEventHandler:^(id sender) {
            [SMMessageHUD showMessage:NSLocalizedString(@"公开", nil) afterDelay:1.0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(CGRectGetMaxX(rect) + 30.0, rect.origin.y, rect.size.width, rect.size.height)];
        [self.view addSubview:btn];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
