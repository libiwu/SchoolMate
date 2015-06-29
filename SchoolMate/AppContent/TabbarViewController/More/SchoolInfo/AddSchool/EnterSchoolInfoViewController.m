//
//  EnterSchoolInfoViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/27.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "EnterSchoolInfoViewController.h"
#import "SMDatePickPopView.h"

@interface EnterSchoolInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;

//记录修改后的值
@property (nonatomic, strong) NSString *editSchoolName;
@property (nonatomic, strong) NSString *editGraduationYear;
@property (nonatomic, strong) NSString *editNianji;
@property (nonatomic, strong) NSString *editBanji;
@property (nonatomic, strong) NSString *editDepartment;
@end

@implementation EnterSchoolInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"编辑学校"];
    [self setRightMenuTitle:@"完成" andnorImage:nil selectedImage:nil];
    
    SchoolTypeModel *model = [[SchoolTypeModel alloc]init];
    if (self.viewtype == ViewTypeEdit) {
        model.schoolTypeId = self.schoolModel.schoolType;
        NSString *string = @"";
        switch (model.schoolTypeId.integerValue) {
            case 1:
            {
                string = @"小学";
            }
                break;
            case 2:
            {
                string = @"初中";
            }
                break;
            case 3:
            {
                string = @"高中";
            }
                break;
            case 4:
            {
                string = @"大学";
            }
                break;
            default:
                break;
        }
        model.name = string;
        self.schoolType = model;
    }
    
    [self createContentView];
}
- (void)rightMenuPressed:(id)sender {
    
}
- (void)createContentView {
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        self.table = tableView;
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.schoolType.schoolTypeId isEqual:@(4)]) {
        return 3;
    } else {
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = RGBCOLOR(240.0, 240.0, 240.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    if (self.schoolType.schoolTypeId.integerValue == 4) {
        if (indexPath.row == 2) {
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 120.0, rect.size.height)];
            [title setText:@"毕业时间"];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:title];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (self.viewtype == ViewTypeEdit) {
                [btn setTitle:self.schoolModel.graduationYear forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else if (self.viewtype == ViewTypeAdd) {
                [btn setTitle:@"请选择" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            [btn setFrame:CGRectMake(CGRectGetMaxX(title.frame), 0.0, rect.size.width - CGRectGetMaxX(title.frame) - 10.0, rect.size.height)];
            [btn setBackgroundColor:[UIColor clearColor]];
            
            [btn bk_addEventHandler:^(id sender) {
//                UIPickerView *view = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, KScreenHeight - 64.0 - 150.0, KScreenWidth, 150.0)];
//                view.dataSource = self;
//                view.delegate = self;
            } forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        } else {
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 120.0, rect.size.height)];
            [title setText:indexPath.row == 0 ? self.schoolType.name : @"院系"];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:title];
            
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0.0, rect.size.width - CGRectGetMaxX(title.frame) - 10.0, rect.size.height)];
            field.backgroundColor = [UIColor clearColor];
            field.leftViewMode = UITextFieldViewModeAlways;
            field.placeholder = indexPath.row == 0 ? @"请输入学校" : @"请输入院系";
            if (self.viewtype == ViewTypeEdit) {
                field.text = indexPath.row == 0 ? self.schoolModel.schoolName : self.schoolModel.department;
            }
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:field];
        }
    } else {
        if (indexPath.row == 0 || indexPath.row == 2)/*学校 和 班级*/ {
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 120.0, rect.size.height)];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:title];
            
            UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0.0, rect.size.width - CGRectGetMaxX(title.frame) - 10.0, rect.size.height)];
            field.backgroundColor = [UIColor clearColor];
            field.leftViewMode = UITextFieldViewModeAlways;
            field.placeholder = @"请输入";
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            field.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:field];
            if (indexPath.row == 0) {
                field.text = self.schoolModel.schoolName;
                [title setText:self.schoolType.name];
            } else {
                field.text = self.schoolModel.className;
                [title setText:@"班级"];
            }
        } else /*年级 和 毕业时间*/{
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 120.0, rect.size.height)];
            [title setText:indexPath.row == 1 ? @"年级" : @"毕业时间"];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:title];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (self.viewtype == ViewTypeEdit) {
                if (indexPath.row == 1) {
                    [btn setTitle:self.schoolModel.className forState:UIControlStateNormal];
                } else {
                    [btn setTitle:self.schoolModel.graduationYear forState:UIControlStateNormal];
                }
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else if (self.viewtype == ViewTypeAdd) {
                [btn setTitle:@"请选择" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            [btn setFrame:CGRectMake(CGRectGetMaxX(title.frame), 0.0, rect.size.width - CGRectGetMaxX(title.frame) - 10.0, rect.size.height)];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn bk_addEventHandler:^(id sender) {
                
            } forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
    }
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, rect.size.height - .5, rect.size.width - 20.0, 0.5)];
    lineImage.backgroundColor = RGBCOLOR(212, 212, 212);
    [cell.contentView addSubview:lineImage];
    
    return cell;
}

#pragma mark - Http
- (void)requestUpdateSchoolInfo {
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/update")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"schoolType" : self.schoolType.schoolTypeId.stringValue,
                                                    @"schoolName" :self.editSchoolName,
                                                    @"graduationYear" : self.editGraduationYear,
                                                    @"department" : self.editDepartment,
                                                    @"major" : self.schoolModel.major,
                                                    @"className" : self.editBanji,
                                                    @"userClassId" : self.schoolModel.userClassId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"修改成功" afterDelay:1.0];
                                                  
//                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
- (void)requestSaveSchoolInfo {
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/update")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"schoolType" : self.schoolType.schoolTypeId.stringValue,
                                                    @"schoolName" :self.editSchoolName,
                                                    @"graduationYear" : self.editGraduationYear,
                                                    @"department" : self.editDepartment,
                                                    @"major" : self.schoolModel.major,
                                                    @"className" : self.editBanji}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"添加成功" afterDelay:1.0];
                                                  
//                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
@end
