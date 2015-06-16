//
//  BBNewspaperDetailViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/16.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "BBNewspaperDetailViewController.h"

#import "NewspaperTableViewCell.h"

#import "SMCircleDetailCell.h"

@interface BBNewspaperDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BBNewspaperDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"正文",  nil)];
    
    [self createContentView];
    
    [self createBottomView];
}
- (void)createContentView {
    
    self.tableView =
    ({
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0 - 49.0) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = [UIColor clearColor];
        table.separatorColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table registerNib:[UINib nibWithNibName:@"NewspaperTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        table;
    });
    [self.view addSubview:self.tableView];
    
    WEAKSELF
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.header endRefreshing];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.tableView.footer endRefreshing];
    }];
}
- (void)createBottomView {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0.0, KScreenHeight - 49.0 - 64.0, KScreenWidth, 49.0)];
    [backView setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    
    CGFloat wid = backView.frame.size.width/3;
    //广播
    UIButton *biji = [UIButton buttonWithType:UIButtonTypeCustom];
    [biji setFrame:CGRectMake(0.0, 0.0, wid, backView.frame.size.height)];
    
    UILabel *gbLabel = [[UILabel alloc]initWithFrame:biji.frame];
    gbLabel.backgroundColor = [UIColor clearColor];
    [gbLabel setText:@"广播"];
    [gbLabel setTextAlignment:NSTextAlignmentCenter];
    [gbLabel setTextColor:[UIColor blackColor]];
    
    
    //评论
    UIButton *zhaopian = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhaopian setFrame:CGRectMake(wid, 0.0, wid, backView.frame.size.height)];
    
    UILabel *zpLabel = [[UILabel alloc]initWithFrame:zhaopian.frame];
    zpLabel.backgroundColor = [UIColor clearColor];
    [zpLabel setText:@"评论"];
    [zpLabel setTextAlignment:NSTextAlignmentCenter];
    [zpLabel setTextColor:[UIColor blackColor]];
    
    
    //稀饭
    UIButton *daoguo = [UIButton buttonWithType:UIButtonTypeCustom];
    [daoguo setFrame:CGRectMake(wid * 2, 0.0, wid, backView.frame.size.height)];
    
    UILabel *dgLabel = [[UILabel alloc]initWithFrame:daoguo.frame];
    dgLabel.backgroundColor = [UIColor clearColor];
    [dgLabel setText:@"稀饭"];
    [dgLabel setTextAlignment:NSTextAlignmentCenter];
    [dgLabel setTextColor:[UIColor blackColor]];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(wid - .5, 10.0, 1.0, 30.0)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(wid * 2 - .5, 10.0, 1.0, 30.0)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];
    
    [backView addSubview:gbLabel];
    [backView addSubview:zpLabel];
    [backView addSubview:dgLabel];
    
    [backView addSubview:biji];
    [backView addSubview:zhaopian];
    [backView addSubview:daoguo];
    
    [backView addSubview:line1];
    [backView addSubview:line2];
    
    
    [biji bk_addEventHandler:^(id sender) {
        //        [gbLabel setTextColor:[UIColor blackColor]];
        //        [zpLabel setTextColor:[UIColor lightGrayColor]];
        //        [dgLabel setTextColor:[UIColor lightGrayColor]];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [zhaopian bk_addEventHandler:^(id sender) {
        //        [gbLabel setTextColor:[UIColor lightGrayColor]];
        //        [zpLabel setTextColor:[UIColor blackColor]];
        //        [dgLabel setTextColor:[UIColor lightGrayColor]];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [daoguo bk_addEventHandler:^(id sender) {
        //        [gbLabel setTextColor:[UIColor lightGrayColor]];
        //        [zpLabel setTextColor:[UIColor lightGrayColor]];
        //        [dgLabel setTextColor:[UIColor blackColor]];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backView];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150.0;
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    } else {
        return 50.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 50.0)];
        view.backgroundColor = self.view.backgroundColor;
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 10.0, tableView.frame.size.width, 40.0)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        
        [view addSubview:backView];
        
        CGFloat wid = backView.frame.size.width/3;
        //广播
        UIButton *biji = [UIButton buttonWithType:UIButtonTypeCustom];
        [biji setFrame:CGRectMake(0.0, 0.0, wid, backView.frame.size.height)];
        
        UILabel *gbLabel = [[UILabel alloc]initWithFrame:biji.frame];
        gbLabel.backgroundColor = [UIColor clearColor];
        [gbLabel setText:@"广播 32"];
        [gbLabel setTextAlignment:NSTextAlignmentCenter];
        [gbLabel setTextColor:[UIColor lightGrayColor]];
        
        
        //评论
        UIButton *zhaopian = [UIButton buttonWithType:UIButtonTypeCustom];
        [zhaopian setFrame:CGRectMake(wid, 0.0, wid, backView.frame.size.height)];
        
        UILabel *zpLabel = [[UILabel alloc]initWithFrame:zhaopian.frame];
        zpLabel.backgroundColor = [UIColor clearColor];
        [zpLabel setText:@"评论 498"];
        [zpLabel setTextAlignment:NSTextAlignmentCenter];
        [zpLabel setTextColor:[UIColor blackColor]];
        
        
        //稀饭
        UIButton *daoguo = [UIButton buttonWithType:UIButtonTypeCustom];
        [daoguo setFrame:CGRectMake(wid * 2, 0.0, wid, backView.frame.size.height)];
        
        UILabel *dgLabel = [[UILabel alloc]initWithFrame:daoguo.frame];
        dgLabel.backgroundColor = [UIColor clearColor];
        [dgLabel setText:@"稀饭 733"];
        [dgLabel setTextAlignment:NSTextAlignmentCenter];
        [dgLabel setTextColor:[UIColor lightGrayColor]];
        
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(wid - .5, 5.0, 1.0, 30.0)];
        [line1 setBackgroundColor:[UIColor lightGrayColor]];
        
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(wid * 2 - .5, 5.0, 1.0, 30.0)];
        [line2 setBackgroundColor:[UIColor lightGrayColor]];
        
        UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, backView.frame.size.height - .5, backView.frame.size.width, .5)];
        [line2 setBackgroundColor:[UIColor lightGrayColor]];
        
        [backView addSubview:gbLabel];
        [backView addSubview:zpLabel];
        [backView addSubview:dgLabel];
        
        [backView addSubview:biji];
        [backView addSubview:zhaopian];
        [backView addSubview:daoguo];
        
        [backView addSubview:line1];
        [backView addSubview:line2];
        [backView addSubview:line3];
        
        
        [biji bk_addEventHandler:^(id sender) {
            [gbLabel setTextColor:[UIColor blackColor]];
            [zpLabel setTextColor:[UIColor lightGrayColor]];
            [dgLabel setTextColor:[UIColor lightGrayColor]];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [zhaopian bk_addEventHandler:^(id sender) {
            [gbLabel setTextColor:[UIColor lightGrayColor]];
            [zpLabel setTextColor:[UIColor blackColor]];
            [dgLabel setTextColor:[UIColor lightGrayColor]];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [daoguo bk_addEventHandler:^(id sender) {
            [gbLabel setTextColor:[UIColor lightGrayColor]];
            [zpLabel setTextColor:[UIColor lightGrayColor]];
            [dgLabel setTextColor:[UIColor blackColor]];
        } forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NewspaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
//        [cell setSMCircleModel:nil indexPath:indexPath];
        
        return cell;
    } else {
        static NSString *identifier = @"SMCircleDetailCell";
        
        SMCircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[SMCircleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setSMCircleDetailModel:nil indexPath:indexPath];
        
        return cell;
    }
}
@end
