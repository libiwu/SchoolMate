//
//  ContactAddressViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/27.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "ContactAddressViewController.h"
#import "IQKeyboardManager.h"

@interface ContactAddressViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeholderArray;
@property (nonatomic, strong) NSArray *contentArray;
@end

@implementation ContactAddressViewController
-(void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"联系地址"];
    
    self.titleArray = @[@"收货人", @"手机号码", @"地区信息", @"详细地址", @"邮政编码"];
    self.placeholderArray = @[@"姓名", @"11位手机号", @"地区信息", @"街道门牌信息", @"邮政编码"];
    if (self.addressModel) {
        self.contentArray = @[self.addressModel.receiverName ? self.addressModel.receiverName : @"",
                              self.addressModel.receiverMobileNo ? self.addressModel.receiverMobileNo : @"",
                              self.addressModel.receiverRegion ? self.addressModel.receiverRegion : @"",
                              self.addressModel.receiverAddress ? self.addressModel.receiverAddress : @"",
                              self.addressModel.receiverPostcode ? self.addressModel.receiverPostcode : @""];
    } else {
        self.contentArray = @[@"", @"", @"", @"", @""];
    }
    
    
    self.view.backgroundColor = RGBCOLOR(255, 255, 255);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setFrame:self.view.bounds];
    [btn bk_addEventHandler:^(id sender) {
        [self.view endEditing:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self createContentView];
}
- (void)createContentView {
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        self.table = tableView;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [IQKeyboardManager enableKeyboardManger];
//    [IQKeyBoardManager disableKeyboardManager];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 10.0)];
    [view setBackgroundColor:self.view.backgroundColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 100.0)];
    [view setBackgroundColor:self.view.backgroundColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.layer setCornerRadius:4.0];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:NSLocalizedString(@"保 存", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        [self requestChangeContactAddress];
    } forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(40.0, 15.0, view.frame.size.width - 80.0, 35.0)];
    [view addSubview:btn];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = RGBCOLOR(240, 240, 240);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, rect.size.width)];
    [titleLabel setText:self.titleArray[indexPath.row]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor blackColor]];
    
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, rect.size.height)];
    field.backgroundColor = [UIColor clearColor];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.leftView = titleLabel;
    field.placeholder = self.placeholderArray[indexPath.row];
    field.text = self.contentArray[indexPath.row];
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (indexPath.row == 1) {
        field.keyboardType = UIKeyboardTypeNumberPad;
    } else if (indexPath.row == 4) {
        field.keyboardType = UIKeyboardTypeNumberPad;
    }else {
        field.keyboardType = UIKeyboardTypeDefault;
    }
    
    [cell.contentView addSubview:field];
    
    if (indexPath.row != self.titleArray.count - 1) {
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, rect.size.height - .5, tableView.frame.size.width - 20.0, 0.5)];
        lineImage.backgroundColor = RGBCOLOR(212, 212, 212);
        [cell.contentView addSubview:lineImage];
    }
    
    return cell;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - Function
- (UITextField *)textFieldWithIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    
    __block UITextField *textField = nil;
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            textField = obj;
            *stop = YES;
        }
    }];
    
    return textField;
}
#pragma mark - Http
- (void)requestChangeContactAddress {
    /*
     userId:1
     receiverName:张三
     receiverMobileNo:13868767777
     receiverRegion:广东 珠海 香洲区
     receiverAddress:东大新城2栋301
     receiverPostcode:59300
     */
    
    UITextField *nameText = [self textFieldWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *mobileText = [self textFieldWithIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *regionText = [self textFieldWithIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *addressText = [self textFieldWithIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    UITextField *postcodeText = [self textFieldWithIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    if (nameText.text.length == 0) {
        [SMMessageHUD showMessage:@"请输入姓名" afterDelay:1.5];
        return;
    } else if (mobileText.text.length != 11) {
        [SMMessageHUD showMessage:@"手机号格式错误" afterDelay:1.5];
        return;
    } else if (regionText.text.length == 0) {
        [SMMessageHUD showMessage:@"请输入地区信息" afterDelay:1.5];
        return;
    } else if (addressText.text.length == 0) {
        [SMMessageHUD showMessage:@"请输入街道信息" afterDelay:1.5];
        return;
    } else if (postcodeText.text.length == 0) {
        [SMMessageHUD showMessage:@"请输入邮政编码" afterDelay:1.5];
        return;
    }
    
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/updateAddress")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"receiverName" : nameText.text,
                                                    @"receiverMobileNo" : mobileText.text,
                                                    @"receiverRegion" : regionText.text,
                                                    @"receiverAddress" : addressText.text,
                                                    @"receiverPostcode" : postcodeText.text}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"修改成功" afterDelay:1.0];
                                                  
                                                  [GlobalManager shareGlobalManager].userInfo.address.receiverName = nameText.text;
                                                  [GlobalManager shareGlobalManager].userInfo.address.receiverMobileNo = mobileText.text;
                                                  [GlobalManager shareGlobalManager].userInfo.address.receiverRegion = regionText.text;
                                                  [GlobalManager shareGlobalManager].userInfo.address.receiverAddress = addressText.text;
                                                  [GlobalManager shareGlobalManager].userInfo.address.receiverPostcode = postcodeText.text;
                                                  
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
