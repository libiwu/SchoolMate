//
//  EnterSchoolInfoViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/27.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "EnterSchoolInfoViewController.h"
#import "SMDatePickPopView.h"
#import "SMPickerView.h"
#import "UserInfoModel.h"
#import "SMNavigationPopView.h"

@interface EnterSchoolInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UITableView *table;

//记录修改后的值
@property (nonatomic, strong) NSString *editSchoolName;
@property (nonatomic, strong) NSString *editGraduationYear;
@property (nonatomic, strong) NSString *editNianji;
@property (nonatomic, strong) NSString *editBanji;
@property (nonatomic, strong) NSString *editDepartment;


//时间选择器
@property (nonatomic, strong) SMPickerView *smPicker;
@property (nonatomic, strong) NSArray *pickerArray;
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
    //时间选择准备
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = com.year;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 1900; i <= year; i ++) {
        [array addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    self.pickerArray = array;
    self.editGraduationYear = self.viewtype == ViewTypeAdd ? @"1900" : self.schoolModel.graduationYear;
    
    self.editBanji = @"";
    self.editDepartment = @"";
    self.editNianji = @"";
    self.editSchoolName = @"";
    
    [self createContentView];
}
- (void)rightMenuPressed:(id)sender {
    [self.view endEditing:YES];
    
    if (self.viewtype == ViewTypeAdd) {
        if (self.schoolType.schoolTypeId.integerValue == 4) {
            if (self.editSchoolName.length == 0) {
                [SMMessageHUD showMessage:@"请输入学校名字" afterDelay:1.0];
            } else if (self.editDepartment.length == 0) {
                [SMMessageHUD showMessage:@"请输入院系" afterDelay:1.0];
            } else if (self.editGraduationYear.length == 0) {
                [SMMessageHUD showMessage:@"请选择毕业时间" afterDelay:1.0];
            } else {
                [self requestSaveSchoolInfo];
            }
        } else {
            if (self.editSchoolName.length == 0) {
                [SMMessageHUD showMessage:@"请输入学校名字" afterDelay:1.0];
            } else if (self.editNianji.length == 0) {
                [SMMessageHUD showMessage:@"请选择年级" afterDelay:1.0];
            } else if (self.editBanji.length == 0) {
                [SMMessageHUD showMessage:@"请输入班级" afterDelay:1.0];
            } else if (self.editGraduationYear.length == 0) {
                [SMMessageHUD showMessage:@"请选择毕业时间" afterDelay:1.0];
            } else {
                [self requestSaveSchoolInfo];
            }
        }
    } else {
        if (self.schoolType.schoolTypeId.integerValue == 4) {
            if (self.editSchoolName.length == 0) {
                [SMMessageHUD showMessage:@"请输入学校名字" afterDelay:1.0];
            } else if (self.editDepartment.length == 0) {
                [SMMessageHUD showMessage:@"请输入院系" afterDelay:1.0];
            } else if (self.editGraduationYear.length == 0) {
                [SMMessageHUD showMessage:@"请选择毕业时间" afterDelay:1.0];
            } else {
                [self requestUpdateSchoolInfo];
            }
        } else {
            if (self.editSchoolName.length == 0) {
                [SMMessageHUD showMessage:@"请输入学校名字" afterDelay:1.0];
            } else if (self.editNianji.length == 0) {
                [SMMessageHUD showMessage:@"请选择年级" afterDelay:1.0];
            } else if (self.editBanji.length == 0) {
                [SMMessageHUD showMessage:@"请输入班级" afterDelay:1.0];
            } else if (self.editGraduationYear.length == 0) {
                [SMMessageHUD showMessage:@"请选择毕业时间" afterDelay:1.0];
            } else {
                [self requestUpdateSchoolInfo];
            }
        }
    }
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
                [self.view endEditing:YES];
                SMPickerView *picker = [[SMPickerView alloc]init];
                picker.pickerView.delegate = self;
                picker.pickerView.dataSource = self;
                [picker.pickerView selectRow:self.editGraduationYear.integerValue - 1900 inComponent:0 animated:NO];
                [picker show];
                [btn setTitle:self.editGraduationYear forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
            [field bk_addObserverForKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       task:^(id obj, NSDictionary *change) {
                                           if (indexPath.row == 0) {
                                               self.editSchoolName = field.text;
                                           } else {
                                               self.editDepartment = field.text;
                                           }
                                       }];
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
                if (self.schoolType.schoolTypeId.integerValue == 1) {
                    self.editBanji = [self.schoolModel.className substringFromIndex:3];
                } else {
                    self.editBanji = [self.schoolModel.className substringFromIndex:2];
                }
                field.text = self.editBanji;
                [title setText:@"班级"];
            }
            [field bk_addObserverForKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                       task:^(id obj, NSDictionary *change) {
                                           if (indexPath.row == 0) {
                                               self.editSchoolName = field.text;
                                           } else {
                                               self.editBanji = field.text;
                                           }
                                       }];
        } else /*年级 和 毕业时间*/{
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 120.0, rect.size.height)];
            [title setText:indexPath.row == 1 ? @"年级" : @"毕业时间"];
            [title setTextAlignment:NSTextAlignmentCenter];
            [title setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:title];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (self.viewtype == ViewTypeEdit) {
                if (indexPath.row == 1) {
                    if (self.schoolType.schoolTypeId.integerValue == 1) {
                        self.editNianji = [self.schoolModel.className substringToIndex:3];
                    } else {
                        self.editNianji = [self.schoolModel.className substringToIndex:2];
                    }
                    [btn setTitle:self.editNianji forState:UIControlStateNormal];
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
                [self.view endEditing:YES];
                if (indexPath.row == 1) {
                    NSArray *array = @[];
                    if (self.schoolType.schoolTypeId.integerValue == 1) {
                        array = @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级"];
                    } else if (self.schoolType.schoolTypeId.integerValue == 2) {
                        array = @[@"初一", @"初二", @"初三"];
                    } else {
                        array = @[@"高一", @"高二", @"高三"];
                    }
                    SMNavigationPopView *view = [[SMNavigationPopView alloc]initWithDataArray:array];
                    [view setTableViewCenter:AppWindow.center];
                    [view setTableViewSelectBlock:^(NSUInteger index, NSString *string) {
                        self.editNianji = string;
                        [btn setTitle:string forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }];
                    [view show];
                } else {
                    SMPickerView *picker = [[SMPickerView alloc]init];
                    picker.pickerView.delegate = self;
                    picker.pickerView.dataSource = self;
                    [picker.pickerView selectRow:self.editGraduationYear.integerValue - 1900 inComponent:0 animated:NO];
                    [picker show];
                    [btn setTitle:self.editGraduationYear forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
    }
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, rect.size.height - .5, rect.size.width - 20.0, 0.5)];
    lineImage.backgroundColor = RGBCOLOR(212, 212, 212);
    [cell.contentView addSubview:lineImage];
    
    return cell;
}
#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerArray[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.schoolType.schoolTypeId.integerValue == 4) {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = obj;
                [btn setTitle:self.pickerArray[row] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.editGraduationYear = self.pickerArray[row];
            }
        }];
    } else {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = obj;
                [btn setTitle:self.pickerArray[row] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.editGraduationYear = self.pickerArray[row];
            }
        }];
    }
}
#pragma mark - Http
- (void)requestUpdateSchoolInfo {
    [SMMessageHUD showLoading:@"正在加载..."];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/class/update")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"schoolType" : self.schoolType.schoolTypeId.stringValue,
                                                    @"schoolName" :self.editSchoolName,
                                                    @"graduationYear" : self.editGraduationYear,
                                                    @"department" : self.editDepartment,
                                                    @"major" : self.schoolModel.major,
                                                    @"className" : [NSString stringWithFormat:@"%@%@",self.editNianji,self.editBanji],
                                                    @"userClassId" : self.schoolModel.userClassId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [SMMessageHUD dismissLoading];
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"修改成功" afterDelay:1.0];
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                                                  });
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
- (void)requestSaveSchoolInfo {
    [SMMessageHUD showLoading:@"正在加载..."];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/class/save")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"schoolType" : self.schoolType.schoolTypeId.stringValue,
                                                    @"schoolName" :self.editSchoolName,
                                                    @"graduationYear" : self.editGraduationYear,
                                                    @"department" : self.editDepartment,
                                                    @"major" : @"",
                                                    @"className" : [NSString stringWithFormat:@"%@%@",self.editNianji,self.editBanji]}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [SMMessageHUD dismissLoading];
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"添加成功" afterDelay:1.0];
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                      [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                                                  });
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
