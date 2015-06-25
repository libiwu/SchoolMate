//
//  NickNameViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()
@property (nonatomic, strong) UITextField *niceTextField;
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"更改昵称", nil)];
    
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
    leftView.text = NSLocalizedString(@"昵称", nil);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0,
                                                                          0.0,
                                                                          backImage.frame.size.width,
                                                                          backImage.frame.size.height)];
    textField.placeholder = NSLocalizedString(@"输入昵称", nil);
    textField.text = [GlobalManager shareGlobalManager].userInfo.nickName;
    [textField becomeFirstResponder];
    textField.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    self.niceTextField = textField;
    
    [backImage addSubview:textField];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0,
                                                                 CGRectGetMaxY(backImage.frame),
                                                                 backImage.frame.size.width - 40.0,
                                                                 40.0)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.text = NSLocalizedString(@"好名字可以让你的朋友更容易记住你", nil);
    [self.view addSubview:tipLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setCornerRadius:4.0];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:NSLocalizedString(@"保 存", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [self requestChangeNickName];
    } forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(40.0, CGRectGetMaxY(tipLabel.frame) + 5.0, KScreenWidth - 80.0, 35.0)];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestChangeNickName {
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/update")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"nickName" :self.niceTextField.text,
                                                    @"realName" :[GlobalManager shareGlobalManager].userInfo.realName,
                                                    @"birthday" : [GlobalManager shareGlobalManager].userInfo.birthday,
                                                    @"gender" : [GlobalManager shareGlobalManager].userInfo.gender,
                                                    @"company" : [GlobalManager shareGlobalManager].userInfo.company,
                                                    @"email" : [GlobalManager shareGlobalManager].userInfo.email,
                                                    @"signature" : [GlobalManager shareGlobalManager].userInfo.signature,
                                                    @"position" : [GlobalManager shareGlobalManager].userInfo.position}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"修改成功" afterDelay:2.0];
                                                  
                                                  [GlobalManager shareGlobalManager].userInfo.nickName = self.niceTextField.text;
                                              
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
@end
