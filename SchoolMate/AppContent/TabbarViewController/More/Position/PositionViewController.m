//
//  PositionViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/28.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "PositionViewController.h"

@interface PositionViewController ()
@property (nonatomic, strong) UITextField *positionTextField;
@end

@implementation PositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"职位"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createContentView];
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
    leftView.text = NSLocalizedString(@"职位", nil);
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0.0,
                                                                          0.0,
                                                                          backImage.frame.size.width,
                                                                          backImage.frame.size.height)];
    textField.placeholder = NSLocalizedString(@"职位", nil);
    textField.text = [GlobalManager shareGlobalManager].userInfo.position;
    textField.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField becomeFirstResponder];
    
    [backImage addSubview:textField];
    
    self.positionTextField = textField;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setCornerRadius:4.0];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:NSLocalizedString(@"保 存", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [textField resignFirstResponder];
        [self requestChangePosition];
    } forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(40.0, CGRectGetMaxY(backImage.frame) + 20.0, KScreenWidth - 80.0, 35.0)];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestChangePosition {
    [SMMessageHUD showLoading:@"正在加载..."];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/update")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"nickName" : [GlobalManager shareGlobalManager].userInfo.nickName,
                                                    @"realName" :[GlobalManager shareGlobalManager].userInfo.realName,
                                                    @"birthday" : [GlobalManager shareGlobalManager].userInfo.birthday,
                                                    @"gender" : [GlobalManager shareGlobalManager].userInfo.gender,
                                                    @"company" : [GlobalManager shareGlobalManager].userInfo.company,
                                                    @"email" : [GlobalManager shareGlobalManager].userInfo.email,
                                                    @"signature" : [GlobalManager shareGlobalManager].userInfo.signature,
                                                    @"position" : self.positionTextField.text}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [SMMessageHUD dismissLoading];
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"修改成功" afterDelay:1.0];
                                                  
                                                  [GlobalManager shareGlobalManager].userInfo.position = self.positionTextField.text;
                                                  
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
