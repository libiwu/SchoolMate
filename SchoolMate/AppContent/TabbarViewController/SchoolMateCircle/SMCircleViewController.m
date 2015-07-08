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
#import "BBNPClassModel.h"
#import "CCBlogModel.h"

@interface SMCircleViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/*朋友圈班级列表*/
@property (nonatomic, strong) NSArray *classArray;
@property (nonatomic, strong) NSArray *classTitleArray;
///当前选择id
@property (copy, nonatomic) NSString *boardId;
/*同学圈博客列表*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation SMCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     高三六班
     初三六班
     01计机一班
     */
//    [self setNavTitle:NSLocalizedString(@"初三六班", nil) type:SCNavTitleTypeSelect];
    
    self.view.backgroundColor = RGBACOLOR(234.0, 234.0, 234.0, 1.0);
    
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    [leftbtn setImage:[UIImage imageNamed:@"26.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    [rightbtn setImage:[UIImage imageNamed:@"27.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    [self requestClassList];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCirclePublishComplete
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.tableView.header beginRefreshing];
                                                  }];
    
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
        self.tableView = tableView;
        
        __block UITableView *ta = tableView;
        [tableView addLegendHeaderWithRefreshingBlock:^{
            [ta.header endRefreshing];
        }];
        [tableView addLegendFooterWithRefreshingBlock:^{
            [ta.footer endRefreshing];
        }];
    }
}
- (void)navigationClick:(UIButton *)btn {
    SMNavigationPopView *view = [[SMNavigationPopView alloc]initWithDataArray:@[@"初三六班",@"高三六班",@"01计机一班"]];
    WEAKSELF
    [view setTableViewSelectBlock:^(NSUInteger index, NSString *string) {
        [self setNavTitle:string type:SCNavTitleTypeSelect];
        BBNPClassModel *model = weakSelf.classArray[index];
        _boardId = model.boardId.stringValue;
        [weakSelf requestBlogListWithBoardId:weakSelf.boardId upOrDown:@"0"];
    }];
    [view show];
}
#pragma mark - Functions
- (void)configureNavTitleData {
    /**
     {"schoolTypeId":1,"name":"小学"},
     {"schoolTypeId":2,"name":"初中"},
     {"schoolTypeId":3,"name":"高中"},
     {"schoolTypeId":4,"name":"大学"}
     */
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [self.classArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BBNPClassModel *model = obj;
        if ([model.schoolType integerValue] != 4) {
            //显示班级
            [tempArr addObject:model.className];
        }
        else {
            //显示学校名
            [tempArr addObject:model.schoolName];
        }
    }];
    self.classTitleArray = tempArr;
    if (tempArr.count) {
        [self setNavTitle:self.classTitleArray[0] type:SCNavTitleTypeSelect];
        BBNPClassModel *model = self.classArray.firstObject;
        _boardId = model.boardId.stringValue;
        [self requestBlogListWithBoardId:self.boardId upOrDown:@"0"];
    }
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    CCBlogModel *model = self.dataArray[indexPath.row];
    [cell setSMCircleModel:model indexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
    view.blogModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - request
#pragma mark 请求班级列表
- (void)requestClassList {
    WEAKSELF
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  
                                                  __block NSMutableArray *newArray = [NSMutableArray array];
                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      BBNPClassModel *model = [BBNPClassModel objectWithKeyValues:obj];
                                                      [newArray addObject:model];
                                                  }];
                                                  weakSelf.classArray = newArray;
                                                  [GlobalManager shareGlobalManager].classArray = newArray;
                                                  [weakSelf configureNavTitleData];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
#pragma mark 请求博客列表
/**
 *  @author libiwu, 15-07-08 01:07
 *
 *  请求黑板报博客列表
 *
 *  @param boardId     班级id
 *  @param requestType 0:下拉刷新或第一次请求 1:加载更多
 */
- (void)requestBlogListWithBoardId:(NSString *)boardId upOrDown:(NSString *)requestType{
    /*
     Request URL:http://120.24.169.36:8080/classmate/m/user/blog/list
     Request Method:POST
     Param: {
     userId:1                  （必填，当前用户ID）
     userClassId:24            （必填，用户班级ID，如果搜索所有班级博客，为0）
     orderBy:createTime        （选填，排序字段，默认为createTime - 微博添加时间）
     orderType:desc            （选填，排序顺序，"desc" - 倒序 或者 "asc" - 升序，默认为desc）
     offset:0                  （选填，记录开始索引，默认为0）
     limit:5                   （选填，返回记录数，默认为5）
     
     }
     */
    WEAKSELF
    NSString *offset = [NSString stringWithFormat:@"%lu",requestType.integerValue == 0 ? 0 : self.dataArray.count];
    NSString *limit = [NSString stringWithFormat:@"%lu",requestType.integerValue == 0 ? 5 : self.dataArray.count + 5];
    NSString *userClassId = _boardId;
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/blog/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"userClassId" : @"0",
                                                    @"orderBy" : @"addTime",
                                                    @"orderType" : @"asc",
                                                    @"offset" : offset,
                                                    @"limit" : limit}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  __block NSMutableArray *newArray = nil;
                                                  if (requestType.integerValue == 0) {
                                                      newArray = [NSMutableArray array];
                                                  } else {
                                                      newArray = [NSMutableArray arrayWithArray:self.dataArray];
                                                  }
                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      CCBlogModel *model = [CCBlogModel objectWithKeyValues:obj];
                                                      [newArray addObject:model];
                                                  }];
                                                  weakSelf.dataArray = newArray;
                                                  [weakSelf.tableView reloadData];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                              [weakSelf.tableView.header endRefreshing];
                                              [weakSelf.tableView.footer endRefreshing];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              [weakSelf.tableView.header endRefreshing];
                                              [weakSelf.tableView.footer endRefreshing];
                                          }];
}

@end

