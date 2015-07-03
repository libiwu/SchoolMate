//
//  CompanyViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/16.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "CompanyViewController.h"

@interface CompanyViewController ()
@property (nonatomic, strong) UITextField *companyTextField;
@end

@implementation CompanyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"工作单位", nil)];
    
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
    leftView.text = NSLocalizedString(@"工作单位", nil);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0,
                                                                          0.0,
                                                                          backImage.frame.size.width,
                                                                          backImage.frame.size.height)];
    textField.placeholder = NSLocalizedString(@"工作单位", nil);
    textField.text = [GlobalManager shareGlobalManager].userInfo.company;
    textField.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField becomeFirstResponder];
    
    [backImage addSubview:textField];
    
    self.companyTextField = textField;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setCornerRadius:4.0];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:NSLocalizedString(@"保 存", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [textField resignFirstResponder];
        [self requestChangeCompany];
    } forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(40.0, CGRectGetMaxY(backImage.frame) + 20.0, KScreenWidth - 80.0, 35.0)];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestChangeCompany {
    [SMMessageHUD showLoading:@"正在加载..."];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/update")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"nickName" : [GlobalManager shareGlobalManager].userInfo.nickName,
                                                    @"realName" :[GlobalManager shareGlobalManager].userInfo.realName,
                                                    @"birthday" : [GlobalManager shareGlobalManager].userInfo.birthday,
                                                    @"gender" : [GlobalManager shareGlobalManager].userInfo.gender,
                                                    @"company" : self.companyTextField.text,
                                                    @"email" : [GlobalManager shareGlobalManager].userInfo.email,
                                                    @"signature" : [GlobalManager shareGlobalManager].userInfo.signature,
                                                    @"position" : [GlobalManager shareGlobalManager].userInfo.position}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [SMMessageHUD dismissLoading];
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"修改成功" afterDelay:1.0];
                                                  
                                                  [GlobalManager shareGlobalManager].userInfo.company = self.companyTextField.text;
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:1.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
@end
