//
//  BBNewspaperViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "BBNewspaperViewController.h"
#import "NewspaperTableViewCell.h"

static NSString *const reuseIdentity = @"Cell";

@interface BBNewspaperViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel     *classNameLab;

@end

@implementation BBNewspaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"黑板报", nil)];
    
    [self creatContentView];
}

- (void)creatContentView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49)];
    _tableView.rowHeight  = 150;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self configureHeaderView];
    [_tableView registerNib:[UINib nibWithNibName:@"NewspaperTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentity];
    [self.view addSubview:_tableView];
}

- (UIView *)configureHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(67, 0, 3, 100)];
    image1.image = [[UIImage imageNamed:@"image04"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewspaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentity forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
