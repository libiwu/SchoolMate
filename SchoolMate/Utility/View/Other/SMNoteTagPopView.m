//
//  SMNoteTagPopView.m
//  SchoolMate
//
//  Created by libiwu on 15/6/16.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMNoteTagPopView.h"

@interface SMNoteTagPopView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SMNoteTagPopView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    
    self.backgroundColor = [UIColor clearColor];
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setFrame:self.frame];
        WEAKSELF
        [btn bk_addEventHandler:^(id sender) {
            [weakSelf dismiss];
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    self.dataArray = @[@"生活",@"聚会",@"合作",@"福利",@"自定义"];
    
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, 264.0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBACOLOR(110.0, 200.0, 243.0, 0.9);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
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
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 43.5, tableView.frame.size.width, .5)];
    lineImage.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lineImage];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.selectIndexPath = indexPath;
}
#pragma mark -
/**
 *  显示
 */
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
/**
 *  隐藏
 */
- (void)dismiss {
    
    __weak SMNoteTagPopView *weakSelf = self;
    
    [UIView animateWithDuration:.26 animations:^{
        
        weakSelf.alpha = .0;
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}

@end
