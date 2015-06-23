//
//  RegisterViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"注册", nil)];
    
    [self createContentView];
}
- (void)createContentView {
    
//    self.backImageView =
//    ({
//        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0)];
//        backImage.image = [UIImage imageNamed:@"registerBack.png"];
//        backImage.userInteractionEnabled = YES;
//        [self.view addSubview:backImage];
//        backImage;
//    });
    
    self.phoneTextField =
    ({
        UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(20.0, 20.0, 170.0, 40.0)];
        phoneText.placeholder = NSLocalizedString(@"输入电话号码", nil);
        phoneText.delegate = self;
        phoneText.backgroundColor = [UIColor whiteColor];
        phoneText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, phoneText.frame.size.height)];
        phoneText.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:phoneText];
        phoneText;
    });
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(200.0, 20.0, 100.0, 40)];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor redColor]];
        [btn bk_addEventHandler:^(id sender) {
            [self requestCode];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    self.codeTextField =
    ({
        UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(20.0, 70.0, KScreenWidth - 40.0, 40.0)];
        phoneText.placeholder = NSLocalizedString(@"输入验证码", nil);
        phoneText.delegate = self;
        phoneText.backgroundColor = [UIColor whiteColor];
        phoneText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, phoneText.frame.size.height)];
        phoneText.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:phoneText];
        phoneText;
    });
    
    self.pwdTextField =
    ({
        UITextField *phoneText = [[UITextField alloc]initWithFrame:CGRectMake(20.0, 120.0, KScreenWidth - 40.0, 40.0)];
        phoneText.placeholder = NSLocalizedString(@"输入密码", nil);
        phoneText.delegate = self;
        phoneText.backgroundColor = [UIColor whiteColor];
        phoneText.secureTextEntry = YES;
        phoneText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, phoneText.frame.size.height)];
        phoneText.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:phoneText];
        phoneText;
    });
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20.0, 170.0, KScreenWidth - 40.0, 40)];
        [btn setTitle:@"注册" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor redColor]];
        btn.layer.cornerRadius = 6.0;
        [btn bk_addEventHandler:^(id sender) {
            [self requestRegister];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)requestCode {
    
    if (self.phoneTextField.text.length != 11) {
        [SMMessageHUD showMessage:@"手机格式错误" afterDelay:1.0];
        return;
    }
    
    [[AFHTTPRequestOperationManager manager] POST:@"http://120.24.169.36:8080/classmate/m/user/sendRegisterSecurityCode"
                                       parameters:@{@"mobileNo" : self.phoneTextField.text}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"短信已发送" afterDelay:2.0];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}

- (void)requestRegister {
    
    if (![CheckTools isValidateKeyNum:self.pwdTextField.text]) {
        [SMMessageHUD showMessage:@"密码格式不正确" afterDelay:1.0];
        return;
    }
    
    [[AFHTTPRequestOperationManager manager] POST:@"http://120.24.169.36:8080/classmate/m/user/register"
                                       parameters:@{@"securityCode" : self.codeTextField.text,
                                                    @"mobileNo" : self.phoneTextField.text,
                                                    @"password" : self.pwdTextField.text}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"注册成功" afterDelay:2.0];
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  });
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
@end
