//
//  ChangeAccountViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/16.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "ChangeAccountViewController.h"

@interface ChangeAccountViewController ()

@end

@implementation ChangeAccountViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"更改账号", nil)];
    
    [self createContentView];
    
    self.view.backgroundColor = RGBCOLOR(255.0, 255.0, 255.0);
}
- (void)createContentView {
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 15.0, KScreenWidth, 44.0)];
    backImage.userInteractionEnabled = YES;
    backImage.backgroundColor = RGBCOLOR(230.0, 230.0, 230.0);
    
    [self.view addSubview:backImage];
    
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.textAlignment = NSTextAlignmentCenter;
    leftView.textColor = [UIColor blackColor];
    leftView.text = NSLocalizedString(@"账号", nil);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0,
                                                                          0.0,
                                                                          backImage.frame.size.width,
                                                                          backImage.frame.size.height)];
    textField.placeholder = NSLocalizedString(@"输入账号", nil);
    textField.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [backImage addSubview:textField];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0,
                                                                 CGRectGetMaxY(backImage.frame),
                                                                 backImage.frame.size.width - 40.0,
                                                                 40.0)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.text = NSLocalizedString(@"朋友可以通过账号搜索到你", nil);
    [self.view addSubview:tipLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setCornerRadius:4.0];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:NSLocalizedString(@"保 存", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [SMMessageHUD showMessage:NSLocalizedString(@"修改成功", nil) afterDelay:1.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(40.0, CGRectGetMaxY(tipLabel.frame) + 5.0, KScreenWidth - 80.0, 35.0)];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
