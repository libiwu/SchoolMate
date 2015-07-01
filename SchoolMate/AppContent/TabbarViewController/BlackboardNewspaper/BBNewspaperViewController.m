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
#import "BBPublishViewController.h"

static NSString *const reuseIdentity = @"Cell";

@interface BBNewspaperViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView         *tableView;
@property (strong, nonatomic) UILabel             *classNameLab;
@property (strong, nonatomic) NSArray             *classNameArr;
@property (strong, nonatomic) SMNavigationPopView *navPopView;
@property (strong, nonatomic) NSMutableArray      *tempClassNameArr;
///当前选择的黑板报id
@property (copy, nonatomic) NSString *boardId;

@end

@implementation BBNewspaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _classNameArr = [NSArray array];
    
    [self setNavTitle:@"" type:SCNavTitleTypeSelect];
    
    [self creatContentView];
    
    [self requestGetClassList];
}

- (void)creatContentView {
    self.view.backgroundColor = RGBACOLOR(234.0, 234.0, 234.0, 1.0);
    //
    
    [self setLeftMenuTitle:nil andnorImage:@"26" selectedImage:@"26"];
    [self setRightMenuTitle:nil andnorImage:@"27" selectedImage:@"27"];
    
//    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftbtn setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
//    [leftbtn setImage:[UIImage imageNamed:@"26.png"] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
//    
//    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightbtn setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
//    [rightbtn setImage:[UIImage imageNamed:@"27.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    //
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight       = 150;
    _tableView.dataSource      = self;
    _tableView.delegate        = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
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

#pragma mark - Request

#pragma mark 黑板报班级列表
- (void)requestGetClassList {
    WEAKSELF
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  weakSelf.classNameArr = responseObject[@"data"];
                                                  [weakSelf configureNavTitleData];
                                                  
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}

#pragma mark 黑板报博客列表
- (void)requestBlackboardListWithBoardId:(NSString *)boardId {
    WEAKSELF
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/blog/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"boardId" : boardId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  
                                                  
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}

#pragma mark -
- (void)configureNavTitleData {
    /**
     {"schoolTypeId":1,"name":"小学"},
     {"schoolTypeId":2,"name":"初中"},
     {"schoolTypeId":3,"name":"高中"},
     {"schoolTypeId":4,"name":"大学"}
     */
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [_classNameArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *schoolType = obj[@"schoolType"];
        if ([schoolType integerValue] != 4) {
            //显示班级
            [tempArr addObject:obj[@"className"]];
        }
        else {
            //显示学校名
            [tempArr addObject:obj[@"schoolName"]];
        }
    }];
    
    self.tempClassNameArr = tempArr;
    if (tempArr.count) {
        [self setNavTitle:tempArr[0] type:SCNavTitleTypeSelect];
        _boardId = _classNameArr[0][@"boardId"];
        [self requestBlackboardListWithBoardId:_boardId];
    }
    
}

- (void)navigationClick:(UIButton *)btn {
    
    _navPopView = [[SMNavigationPopView alloc] initWithDataArray:_tempClassNameArr];
    
    WEAKSELF
    [_navPopView setTableViewSelectBlock:^(NSUInteger index, NSString *string) {
        [weakSelf setNavTitle:string type:SCNavTitleTypeSelect];
        DLog(@"boardId:%@",weakSelf.classNameArr[index][@"boardId"]);
        _boardId = weakSelf.classNameArr[index][@"boardId"];
        [weakSelf requestBlackboardListWithBoardId:weakSelf.boardId];
    }];
    [_navPopView show];
}

- (void)leftMenuPressed:(id)sender {
    BBPublishViewController *vc = [[BBPublishViewController alloc] initWithHiddenTabBar:YES hiddenBackButton:NO];
    vc.boardId = _boardId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightMenuPressed:(id)sender {
    
}

- (UIView *)configureHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    headerView.backgroundColor = RGBCOLOR(239, 239, 239);
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(67, 0, 3, 60)];
    image1.image = [UIImage imageNamed:@"image04"];
    [headerView addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+3, 12, 220, 35)];
    image2.image = [UIImage imageNamed:@"28"];
    [headerView addSubview:image2];
    
    _classNameLab      = [[UILabel alloc] initWithFrame:CGRectMake(95, 16, 183, 21)];
    _classNameLab.textColor     = RGBCOLOR(51, 101, 126);
    _classNameLab.textAlignment = NSTextAlignmentCenter;
    _classNameLab.font          = [UIFont systemFontOfSize:16];
    _classNameLab.text          = @"初三五班";
    [headerView addSubview:_classNameLab];
    
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
    BBNewspaperDetailViewController *vc = [[BBNewspaperDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 60;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [self configureHeaderView];
//}

@end
