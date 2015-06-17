//
//  GroupViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/16.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation GroupViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:@"groupString"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"分组", nil)];
    
    self.dataArray = @[@"广播",@"同班可见",@"同级可见",@"同校可见"];
    
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    if ([self.groupString isEqualToString:cell.textLabel.text]) {
        self.selectIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 43.5, tableView.frame.size.width, .5)];
    lineImage.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectIndexPath];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        self.groupString = cell.textLabel.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupString" object:self.groupString];
    }
    
    self.selectIndexPath = indexPath;
}
@end
