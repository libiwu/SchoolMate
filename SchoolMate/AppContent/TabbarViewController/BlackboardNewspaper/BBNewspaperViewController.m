//
//  BBNewspaperViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "BBNewspaperViewController.h"
#import "NewspaperTableViewCell.h"
#import "SMNavigationPopView.h"
#import "BBNewspaperDetailViewController.h"

static NSString *const reuseIdentity = @"Cell";

@interface BBNewspaperViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel     *classNameLab;

@end

@implementation BBNewspaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"一班", nil) type:SCNavTitleTypeSelect];
    
    [self creatContentView];
}

- (void)creatContentView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.rowHeight  = 150;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.tableHeaderView = [self configureHeaderView];
    [_tableView registerNib:[UINib nibWithNibName:@"NewspaperTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentity];
    [self.view addSubview:_tableView];
    
    WEAKSELF
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.header endRefreshing];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.tableView.footer endRefreshing];
    }];
}
- (void)navigationClick:(UIButton *)btn {
    SMNavigationPopView *view = [[SMNavigationPopView alloc]initWithDataArray:@[@"一班",@"二班",@"三班",@"四班"]];
    [view setTableViewSelectBlock:^(NSUInteger index, NSString *string) {
        [self setNavTitle:string type:SCNavTitleTypeSelect];
    }];
    [view show];
}
- (UIView *)configureHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    headerView.backgroundColor = RGBCOLOR(239, 239, 239);
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(67, 0, 3, 60)];
    image1.image = [UIImage imageNamed:@"image04"];
    [headerView addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+3, 12, 220, 35)];
    image2.image = [UIImage imageNamed:@"image05"];
    [headerView addSubview:image2];
    return headerView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewspaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentity forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBNewspaperDetailViewController *vc = [[BBNewspaperDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self configureHeaderView];
}

@end
