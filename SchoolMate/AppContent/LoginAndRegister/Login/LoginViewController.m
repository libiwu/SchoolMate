//
//  LoginViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "LoginViewController.h"

#import "SCTabViewController.h"
#import "RegisterViewController.h"

#import "UserInfoModel.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *pwdTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"登录", nil)];

    self.backImageView =
    ({
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0)];
        backImage.image = [UIImage imageNamed:@"LoginBack.png"];
        backImage.userInteractionEnabled = YES;
        [self.view addSubview:backImage];
        backImage;
    });
    
    self.phoneTextField =
    ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90.0, 180.0, 180.0, 35.0)];
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField setDelegate:self];
        [textField setText:@"18500191316"];
        [textField setPlaceholder:NSLocalizedString(@"手机/邮箱/用户名", nil)];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.backImageView addSubview:textField];
        textField;
    });
    
    self.pwdTextField =
    ({
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(90.0, 225.0, 180.0, 35.0)];
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField setDelegate:self];
        [textField setText:@"111111"];
        [textField setPlaceholder:NSLocalizedString(@"密码", nil)];
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textField setSecureTextEntry:YES];
        [self.backImageView addSubview:textField];
        textField;
    });
    
    {
        //登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundColor:[UIColor clearColor]];
        [loginBtn setFrame:CGRectMake(40.0, 284.0, 240.0, 44.0)];
        [loginBtn bk_addEventHandler:^(id sender) {
            if (![CheckTools isValidateMobile:self.phoneTextField.text]) {
                [SMMessageHUD showMessage:@"手机号格式不对" afterDelay:2.0];
                return ;
            } else if (![CheckTools isValidateKeyNum:self.pwdTextField.text]) {
                [SMMessageHUD showMessage:@"密码格式不对" afterDelay:2.0];
                return ;
            } else {
                [self requestLogin];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:loginBtn];
    }
    
    {
        //QQ 登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundColor:[UIColor clearColor]];
        [loginBtn setFrame:CGRectMake(64.0, 366.0, 38.0, 42.0)];
        [loginBtn bk_addEventHandler:^(id sender) {
            [SMMessageHUD showMessage:NSLocalizedString(@"QQ 登录", nil) afterDelay:1.0];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:loginBtn];
    }
    
    {
        //微信登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundColor:[UIColor clearColor]];
        [loginBtn setFrame:CGRectMake(136.0, 366.0, 48.0, 42.0)];
        [loginBtn bk_addEventHandler:^(id sender) {
            [SMMessageHUD showMessage:NSLocalizedString(@"微信登录", nil) afterDelay:1.0];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:loginBtn];
    }
    
    {
        //sina 登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundColor:[UIColor clearColor]];
        [loginBtn setFrame:CGRectMake(214.0, 366.0, 46.0, 42.0)];
        [loginBtn bk_addEventHandler:^(id sender) {
            [SMMessageHUD showMessage:NSLocalizedString(@"sina 登录", nil) afterDelay:1.0];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:loginBtn];
    }
    
    {
        //忘记密码
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundColor:[UIColor clearColor]];
        [loginBtn setFrame:CGRectMake(0.0, 458.0, 84.0, 30.0)];
        [loginBtn bk_addEventHandler:^(id sender) {
            [SMMessageHUD showMessage:NSLocalizedString(@"忘记密码", nil) afterDelay:1.0];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:loginBtn];
    }
    
    {
        //注册
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundColor:[UIColor clearColor]];
        [loginBtn setFrame:CGRectMake(266.0, 460.0, 44.0, 24.0)];
        [loginBtn bk_addEventHandler:^(id sender) {
            RegisterViewController *view = [[RegisterViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
            [self.navigationController pushViewController:view animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:loginBtn];
    }
}
#pragma mark - Request
- (void)requestLogin {
    [[AFHTTPRequestOperationManager manager] POST:@"http://120.24.169.36:8080/classmate/m/user/login"
                                       parameters:@{@"mobileNo" : self.phoneTextField.text,
                                                    @"password" : self.pwdTextField.text}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"登录成功" afterDelay:2.0];
                                                  
                                                  UserInfoModel *model = [UserInfoModel objectWithKeyValues:responseObject[@"data"]];
                                                  
                                                  [GlobalManager shareGlobalManager].userInfo = model;
                                                                                                    
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      [self jumpTabbar];
                                                  });
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
#pragma mark - Function
- (void)jumpTabbar {
    SCTabViewController *tab = [[SCTabViewController alloc]init];
    [self presentViewController:tab animated:NO completion:nil];
}


#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:.26
                     animations:^{
                         [self.backImageView setFrame:CGRectMake(self.backImageView.frame.origin.x,
                                                                 -90.0,
                                                                 self.backImageView.frame.size.width,
                                                                 self.backImageView.frame.size.height)];
                     } completion:^(BOOL finished) {
                         
                     }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:.26
                     animations:^{
                         [self.backImageView setFrame:CGRectMake(self.backImageView.frame.origin.x,
                                                                 0.0,
                                                                 self.backImageView.frame.size.width,
                                                                 self.backImageView.frame.size.height)];
                     } completion:^(BOOL finished) {
                         
                     }];
}
@end
