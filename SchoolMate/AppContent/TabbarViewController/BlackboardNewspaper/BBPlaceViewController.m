//
//  BBPlaceViewController.m
//  SchoolMate
//
//  Created by SuperDanny on 15/6/17.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "BBPlaceViewController.h"

@interface BBPlaceViewController ()

@end

@implementation BBPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"地点", nil)];
    [self creatContentView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}
- (void)creatContentView {
    
    self.view.backgroundColor = RGBCOLOR(255.0, 255.0, 255.0);
    
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 15.0, KScreenWidth, 44.0)];
    backImage.userInteractionEnabled = YES;
    backImage.backgroundColor = RGBCOLOR(230.0, 230.0, 230.0);
    
    [self.view addSubview:backImage];
    
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.textAlignment = NSTextAlignmentCenter;
    leftView.textColor = [UIColor blackColor];
    leftView.text = NSLocalizedString(@"地点", nil);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0,
                                                                          0.0,
                                                                          backImage.frame.size.width,
                                                                          backImage.frame.size.height)];
    textField.placeholder = NSLocalizedString(@"地点", nil);
    textField.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    [backImage addSubview:textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setCornerRadius:4.0];
    [btn setBackgroundColor:[UIColor colorWithRed:0.989 green:0.371 blue:0.393 alpha:1.000]];
    [btn setTitle:NSLocalizedString(@"保 存", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [SMMessageHUD showMessage:NSLocalizedString(@"修改成功", nil) afterDelay:1.0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_block) {
                _block(textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    } forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(30.0, CGRectGetMaxY(backImage.frame) + 20.0, KScreenWidth - 60.0, 35.0)];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
