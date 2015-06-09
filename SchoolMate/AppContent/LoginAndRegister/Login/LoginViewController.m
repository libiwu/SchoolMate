//
//  LoginViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "LoginViewController.h"

#import "SCTabViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"登录", nil)];
    
    {
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setBackgroundColor:[UIColor redColor]];
        [loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        [loginBtn setFrame:CGRectMake(100.0, 100.0, 100.0, 50.0)];
        [loginBtn bk_addEventHandler:^(id sender) {
            [self jumpTabbar];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginBtn];
    }
}
- (void)jumpTabbar {
    SCTabViewController *tab = [[SCTabViewController alloc]init];
    [self presentViewController:tab animated:NO completion:nil];
}
@end
