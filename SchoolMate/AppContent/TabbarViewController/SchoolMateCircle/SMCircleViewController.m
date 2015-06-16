//
//  SMCircleViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMCircleViewController.h"
#import "SMCircleCell.h"
#import "SMCircleDetailViewController.h"
#import "SMNavigationPopView.h"
#import "PublishNoteViewController.h"

@interface SMCircleViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SMCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"同学会", nil) type:SCNavTitleTypeSelect];
    
    self.view.backgroundColor = RGBACOLOR(234.0, 234.0, 234.0, 1.0);
    
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    [leftbtn setImage:[UIImage imageNamed:@"zuo.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    [rightbtn setImage:[UIImage imageNamed:@"you.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    [self createContentView];
}
- (void)createContentView {
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0 - 49.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
    }
}
- (void)navigationClick:(UIButton *)btn {
    SMNavigationPopView *view = [[SMNavigationPopView alloc]initWithDataArray:@[@"董藩",@"西方",@"南宫",@"慕容",@"欧阳",@"欧龙生",@"梁羽生",@"皇普奇"]];
    [view setTableViewSelectBlock:^(NSUInteger index, NSString *string) {
        [self setNavTitle:string type:SCNavTitleTypeSelect];
    }];
    [view show];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 47.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 47.0)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat wid = backView.frame.size.width/3;
    //笔记
    UIButton *biji = [UIButton buttonWithType:UIButtonTypeCustom];
    [biji setBackgroundImage:[UIImage imageNamed:@"bijing.png"] forState:UIControlStateNormal];
    [biji setFrame:CGRectMake(0.0, 0.0, wid, backView.frame.size.height)];
    WEAKSELF
    [biji bk_addEventHandler:^(id sender) {
        PublishNoteViewController *vc = [[PublishNoteViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    //照片
    UIButton *zhaopian = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhaopian setBackgroundImage:[UIImage imageNamed:@"zhaopian.png"] forState:UIControlStateNormal];
    [zhaopian setFrame:CGRectMake(wid, 0.0, wid, backView.frame.size.height)];
    [zhaopian bk_addEventHandler:^(id sender) {
        PublishNoteViewController *vc = [[PublishNoteViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    //到过
    UIButton *daoguo = [UIButton buttonWithType:UIButtonTypeCustom];
    [daoguo setBackgroundImage:[UIImage imageNamed:@"daoguo.png"] forState:UIControlStateNormal];
    [daoguo setFrame:CGRectMake(wid * 2, 0.0, wid, backView.frame.size.height)];
    [daoguo bk_addEventHandler:^(id sender) {
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(wid - .5, 5.0, 1.0, 37.0)];
    [line1 setBackgroundColor:[UIColor grayColor]];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(wid * 2 - .5, 5.0, 1.0, 37.0)];
    [line2 setBackgroundColor:[UIColor grayColor]];
    
    [backView addSubview:biji];
    [backView addSubview:zhaopian];
    [backView addSubview:daoguo];
    
    [backView addSubview:line1];
    [backView addSubview:line2];
    
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    SMCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[SMCircleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setSMCircleModel:nil indexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
    [self.navigationController pushViewController:view animated:YES];
}
@end

