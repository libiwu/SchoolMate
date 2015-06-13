//
//  UserInfoView.m
//  SchoolMate
//
//  Created by libiwu on 15/6/10.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "UserInfoView.h"
#import "UserInfoCell.h"

@interface UserInfoView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *contentArray;
@end

@implementation UserInfoView

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    
    self.titleArray = @[@[NSLocalizedString(@"头像", nil),
                          NSLocalizedString(@"昵称", nil),
                          NSLocalizedString(@"真是姓名", nil),
                          NSLocalizedString(@"生日", nil),
                          NSLocalizedString(@"账号", nil),
                          NSLocalizedString(@"性别", nil),
                          NSLocalizedString(@"二维码名片", nil)],
                        @[NSLocalizedString(@"职位", nil),
                          NSLocalizedString(@"工作单位", nil),
                          NSLocalizedString(@"联系地址", nil),
                          NSLocalizedString(@"地区", nil)]];
    
    self.contentArray = @[@[NSLocalizedString(@"头像", nil),
                            NSLocalizedString(@"同学科技", nil),
                            NSLocalizedString(@"呆萌萌", nil),
                            NSLocalizedString(@"1980年10月1日", nil),
                            NSLocalizedString(@"tongxuekeji", nil),
                            NSLocalizedString(@" 男", nil),
                            NSLocalizedString(@"二维码名片", nil)],
                          @[NSLocalizedString(@"漫画家", nil),
                            NSLocalizedString(@"珠海同学科技有限公司", nil),
                            NSLocalizedString(@"联系地址", nil),
                            NSLocalizedString(@"广东 珠海", nil)]];
    
    self.tableView =
    ({
        UITableView *table = [[UITableView alloc]initWithFrame:self.frame];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:table];
        table;
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 85.0;
    } else {
        return 44.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10.0;
            break;
        default:
        {
            return 10.0;
        }
            break;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"UserInfoCell";
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        cell = [[UserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UserInfoCellType type = 0;
    if (indexPath.section == 0 && indexPath.row == 0) {
        type = UserInfoCellTypeAvatar;
    } else if (indexPath.section == 0 && indexPath.row == 6) {
        type = UserInfoCellTypeImage;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        type = UserInfoCellTypeDefault;
    } else {
        type = UserInfoCellTypeArrow;
    }
    
    [cell setUserInfoModel:@{@"title" : self.titleArray[indexPath.section][indexPath.row],
                             @"content" : self.contentArray[indexPath.section][indexPath.row]}
                 indexPath:indexPath
                  cellType:type];
    
    return cell;
}
@end
