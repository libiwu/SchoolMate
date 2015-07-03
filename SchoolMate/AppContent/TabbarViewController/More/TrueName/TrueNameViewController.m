//
//  TrueNameViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "TrueNameViewController.h"

@interface TrueNameViewController ()
@property (nonatomic, strong) UITextField *realTextField;
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
    textField.text = [GlobalManager shareGlobalManager].userInfo.realName;
    textField.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField becomeFirstResponder];
    
    [backImage addSubview:textField];
    self.realTextField = textField;
    CGRect rect ;
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:RGBCOLOR(230.0, 230.0, 230.0)];
        [btn.layer setCornerRadius:4.0];
        [btn setTitle:NSLocalizedString(@"不公开", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn bk_addEventHandler:^(id sender) {
            [SMMessageHUD showMessage:NSLocalizedString(@"不公开", nil) afterDelay:1.0];
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
            [textField resignFirstResponder];
            [self requestChangeRealName];
        } forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(CGRectGetMaxX(rect) + 30.0, rect.origin.y, rect.size.width, rect.size.height)];
        [self.view addSubview:btn];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestChangeRealName {
    [SMMessageHUD showLoading:@"正在加载..."];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/update")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"nickName" :self.realTextField.text,
                                                    @"realName" :[GlobalManager shareGlobalManager].userInfo.realName,
                                                    @"birthday" : [GlobalManager shareGlobalManager].userInfo.birthday,
                                                    @"gender" : [GlobalManager shareGlobalManager].userInfo.gender,
                                                    @"company" : [GlobalManager shareGlobalManager].userInfo.company,
                                                    @"email" : [GlobalManager shareGlobalManager].userInfo.email,
                                                    @"signature" : [GlobalManager shareGlobalManager].userInfo.signature,
                                                    @"position" : [GlobalManager shareGlobalManager].userInfo.position}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [SMMessageHUD dismissLoading];
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"修改成功" afterDelay:2.0];
                                                  
                                                  [GlobalManager shareGlobalManager].userInfo.realName = self.realTextField.text;
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
@end
