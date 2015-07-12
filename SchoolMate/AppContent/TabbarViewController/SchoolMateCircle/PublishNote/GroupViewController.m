//
//  GroupViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/16.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "GroupViewController.h"
#import "BBNPClassModel.h"

@interface GroupViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) BOOL  didSelect;
@end

@implementation GroupViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:@"groupString"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"分组", nil)];
    self.didSelect = NO;
    /*
     @property (nonatomic, strong) NSNumber *boardId;
     @property (nonatomic, strong) NSString *className;
     @property (nonatomic, strong) NSNumber *createTime;
     @property (nonatomic, strong) NSNumber *createUserId;
     @property (nonatomic, strong) NSString *graduationYear;
     @property (nonatomic, strong) NSString *name;
     @property (nonatomic, strong) NSString *schoolName;
     @property (nonatomic, strong) NSNumber *schoolType;
     */
    BBNPClassModel *model = [BBNPClassModel objectWithKeyValues:@{@"boardId" : @"0",
                                                                  @"className" : @"所有人可见",
                                                                  @"createTime" : @"",
                                                                  @"createUserId" : @"",
                                                                  @"graduationYear" : @"",
                                                                  @"name" : @"",
                                                                  @"schoolName" : @"",
                                                                  @"schoolType" : @""}];
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:[GlobalManager shareGlobalManager].classArray];
    [newArray insertObject:model atIndex:0];
    self.dataArray = newArray;
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
    }
    
    [self setRightMenuTitle:@"完成" andnorImage:nil selectedImage:nil];
}
- (void)rightMenuPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.selectBlock && self.didSelect) {
        self.selectBlock(self.dataArray[self.selectIndexPath.row], self.selectIndexPath);
    }
}
- (void)setSelectBlock:(SelectBlock)selectBlock {
    _selectBlock = selectBlock;
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
    
    BBNPClassModel *model = (BBNPClassModel *)self.dataArray[indexPath.row];
    
    cell.textLabel.text = model.schoolType.integerValue == 4 ? model.schoolName : model.className;
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 43.5, tableView.frame.size.width, .5)];
    lineImage.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelect = YES;
    if (self.selectIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectIndexPath];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectIndexPath = indexPath;
}
@end
