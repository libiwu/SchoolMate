//
//  SchoolViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/27.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SchoolViewController.h"
#import "SchoolTypeViewController.h"
#import "SchoolModel.h"
#import "EnterSchoolInfoViewController.h"

@interface SchoolViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"学校"];
    
    [self setRightMenuTitle:@"添加" andnorImage: nil selectedImage:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createContentView];
    
//    [self requestSchoolList];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.table.header beginRefreshing];
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
        
        [tableView addLegendHeaderWithRefreshingBlock:^{
            [self requestSchoolList];
        }];
    }
}
- (void)rightMenuPressed:(id)sender {
    SchoolTypeViewController *view = [[SchoolTypeViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
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
    
    SchoolModel *model = self.dataArray[indexPath.row];
    
    NSString *typeStr = @"";
    switch (model.schoolType.integerValue) {
        case 1:
        {
            typeStr = @"小学";
        }
            break;
        case 2:
        {
            typeStr = @"初中";
        }
            break;
        case 3:
        {
            typeStr = @"高中";
        }
            break;
        case 4:
        {
            typeStr = @"大学";
        }
            break;
        default:
            break;
    }
    UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 60.0, 80.0)];
    [type setText:typeStr];
    [type setTextAlignment:NSTextAlignmentRight];
    [type setBackgroundColor:[UIColor clearColor]];
    [type setTextColor:[UIColor grayColor]];
    [cell.contentView addSubview:type];
    
    UILabel *school = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(type.frame) + 40.0, 10.0, KScreenWidth - CGRectGetMaxX(type.frame) - 60.0 - 40.0, 20.0)];
    [school setText:model.schoolName];
    [school setTextAlignment:NSTextAlignmentLeft];
    [school setFont:[UIFont systemFontOfSize:14.0]];
    [school setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:school];
    
    UILabel *class = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(school.frame), CGRectGetMaxY(school.frame), school.frame.size.width, 20.0)];
    NSString *classStr = model.schoolType.integerValue == 4 ? model.department : model.className;
    [class setText:classStr];
    [class setTextAlignment:NSTextAlignmentLeft];
    [class setFont:[UIFont systemFontOfSize:14.0]];
    [class setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:class];
    
    UILabel *graduation = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(class.frame), CGRectGetMaxY(class.frame), school.frame.size.width, 20.0)];
    [graduation setText:[NSString stringWithFormat:@"%@%@",model.graduationYear,@"毕业"]];
    [graduation setTextAlignment:NSTextAlignmentLeft];
    [graduation setBackgroundColor:[UIColor clearColor]];
    [graduation setFont:[UIFont systemFontOfSize:14.0]];
    [cell.contentView addSubview:graduation];
    
    cell.frame = CGRectMake(0.0, 0.0, KScreenWidth, 80.0);
    
    if (indexPath.row != self.dataArray.count - 1) {
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, cell.frame.size.height - .5, cell.frame.size.width - 20.0, 0.5)];
        lineImage.backgroundColor = RGBCOLOR(212, 212, 212);
        [cell.contentView addSubview:lineImage];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    EnterSchoolInfoViewController *view = [[EnterSchoolInfoViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
    view.viewtype = ViewTypeEdit;
    view.schoolModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - Http
- (void)requestSchoolList {
    /*
     schoolTypeId:2
     name:二中
     country:中国
     province:广东
     city:珠海
     district:香洲区
     */
    
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/class/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  NSMutableArray *array = [NSMutableArray array];
                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      SchoolModel *model = [SchoolModel objectWithKeyValues:obj];
                                                      [array addObject:model];
                                                  }];
                                                  self.dataArray = array;
                                                  [self.table reloadData];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                              [self.table.header endRefreshing];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              [self.table.header endRefreshing];
                                          }];
}
@end
