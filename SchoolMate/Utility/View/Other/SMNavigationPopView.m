//
//  SMNavigationPopView.m
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMNavigationPopView.h"

@interface SMNavigationPopView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
/**
 *  alertView框
 */
@property (nonatomic, strong) UIImageView    *backView;
@end

@implementation SMNavigationPopView

- (instancetype)initWithDataArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.dataArray = array;
        [self setUp];
    }
    return self;
}
- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    self.frame = AppWindow.frame;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setFrame:self.frame];
    WEAKSELF
    [btn bk_addEventHandler:^(id sender) {
        [weakSelf dismiss];
    } forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    
    CGFloat hei = 0;
    if (self.dataArray.count > 7) {
        hei = 280.0;
    } else {
        hei = 40.0 * self.dataArray.count;
    }
    self.backView =
    ({
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(85.0, 70.0, 150.0, hei)];
        imageView.backgroundColor = RGBACOLOR(110.0, 200.0, 243.0, 0.9);
        imageView.userInteractionEnabled = YES;
        imageView;
    });
    [self addSubview:self.backView];
    
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.backView.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        [self.backView addSubview:tableView];
    }
}
- (void)setTableViewCenter:(CGPoint)point {
    self.backView.center = point;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *view = [cell.contentView viewWithTag:140000];
    [view removeFromSuperview];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 39.5, tableView.frame.size.width, 0.5)];
    lineImage.backgroundColor = [UIColor lightGrayColor];
    lineImage.tag = 140000;
    [cell.contentView addSubview:lineImage];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
    [self dismiss];
    
    if (self.selectBlock) {
        self.selectBlock(indexPath.row,self.dataArray[indexPath.row]);
    }
}

#pragma mark -
/**
 *  显示
 */
- (void)show {
    self.backView.transform = CGAffineTransformMakeScale(1.0, 0.0);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3
                     animations:^{
                         self.backView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     } completion:^(BOOL finished) {
                         
                     }];
}
/**
 *  隐藏
 */
- (void)dismiss {
    
    __weak SMNavigationPopView *weakSelf = self;
    
    [UIView animateWithDuration:.26 animations:^{
        self.backView.transform = CGAffineTransformMakeScale(.4, .4);
        weakSelf.alpha = .0;
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}
- (void)setTableViewSelectBlock:(tableViewSelectBlock)block {
    self.selectBlock = block;
}
@end
