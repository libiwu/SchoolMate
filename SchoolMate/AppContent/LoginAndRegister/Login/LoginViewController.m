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
            [self jumpTabbar];
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
