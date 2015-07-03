//
//  SchoolTypeViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/27.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SchoolTypeViewController.h"
#import "SchoolModel.h"
#import "EnterSchoolInfoViewController.h"

@interface SchoolTypeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SchoolTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"添加学校"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createContentView];
    
    [self requestSchoolType];
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
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
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
 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SchoolTypeModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.textColor = [UIColor blackColor];
    
    CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
    if (indexPath.row != self.dataArray.count - 1) {
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, rect.size.height - .5, rect.size.width - 20.0, 0.5)];
        lineImage.backgroundColor = RGBCOLOR(212, 212, 212);
        [cell.contentView addSubview:lineImage];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EnterSchoolInfoViewController *view = [[EnterSchoolInfoViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
    view.schoolType = self.dataArray[indexPath.row];
    view.viewtype = ViewTypeAdd;
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - Http
- (void)requestSchoolType {
    [SMMessageHUD showLoading:@"正在加载..."];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/schoolType/list")
                                       parameters:@{}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              [SMMessageHUD dismissLoading];
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  NSMutableArray *array = [NSMutableArray array];
                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      SchoolTypeModel *model = [SchoolTypeModel objectWithKeyValues:obj];
                                                      [array addObject:model];
                                                  }];
                                                  self.dataArray = array;
                                                  [self.table reloadData];
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
