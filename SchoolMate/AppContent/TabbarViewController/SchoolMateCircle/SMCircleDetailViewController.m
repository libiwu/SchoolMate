//
//  SMCircleDetailViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMCircleDetailViewController.h"
#import "SMCircleCell.h"
#import "SMCircleDetailCell.h"
#import "MJRefresh.h"

#import "CommentViewController.h"
#import "CCSupportModel.h"
#import "CCCommentModel.h"

@interface SMCircleDetailViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
//当前选择的是评论（1）还是稀饭（2）还是广播（3）
@property (nonatomic, assign) NSString *commentOrSupport;
@property (nonatomic, strong) NSArray *commentArray;
@property (nonatomic, strong) NSArray *supportArray;
@property (nonatomic, strong) NSArray *boardcastArray;
@end

@implementation SMCircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"正文",  nil)];
    
    self.view.backgroundColor = RGBCOLOR(230, 230, 230);
    
    self.commentOrSupport = @"1";
    
    [self createContentView];
    
    [self createBottomView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestComment:@"0"];
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
        table;
    });
    WEAKSELF
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        if ([weakSelf.commentOrSupport isEqualToString:@"1"]) {
            [weakSelf requestComment:@"0"];
        } else if ([weakSelf.commentOrSupport isEqualToString:@"2"]) {
            [weakSelf requestSupport:@"0"];
        } else {
            
        }
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        if ([weakSelf.commentOrSupport isEqualToString:@"1"]) {
            [weakSelf requestComment:@"1"];
        } else if ([weakSelf.commentOrSupport isEqualToString:@"2"]){
            [weakSelf requestSupport:@"1"];
        } else {
            
        }
    }];
    
    [self.view addSubview:self.tableView];
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
    
    
    WEAKSELF
    [biji bk_addEventHandler:^(id sender) {

    } forControlEvents:UIControlEventTouchUpInside];
    [zhaopian bk_addEventHandler:^(id sender) {
//        CommentViewController *vc = [[CommentViewController alloc] init];
//        vc.bbnpModel = weakSelf.bbnpModel;
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        [weakSelf presentViewController:nav animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [daoguo bk_addEventHandler:^(id sender) {
        UIButton *btn = sender;
        btn.enabled = NO;
        if ([weakSelf.blogModel.isLike.stringValue isEqualToString:@"0"]) {
            [weakSelf requestSupportComplete:^(BOOL success) {
                btn.enabled = YES;
            }];
        } else {
            [weakSelf requestDeleteSupportComplete:^(BOOL success) {
                btn.enabled = YES;
            }];
        }
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
        switch (self.commentOrSupport.integerValue) {
            case 1:
            {
                return self.commentArray.count ? self.commentArray.count : 1;
            }
                break;
            case 2:
            {
                return self.supportArray.count ? self.supportArray.count : 1;
            }
                break;
            case 3:
            {
                return self.boardcastArray.count ? self.boardcastArray.count : 1;
            }
                break;
            default:
                break;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        [gbLabel setTextAlignment:NSTextAlignmentCenter];
        NSString *gbString = @"";
        if (self.boardcastArray && self.boardcastArray.count) {
            gbString = [NSString stringWithFormat:@"广播 %lu",(unsigned long)self.boardcastArray.count];
        } else {
            gbString = self.blogModel.likeCount.stringValue;
        }
        [gbLabel setText:gbString];
        [gbLabel setTextAlignment:NSTextAlignmentCenter];
        if ([self.commentOrSupport isEqualToString:@"3"]) {
            [gbLabel setTextColor:[UIColor blackColor]];
        } else {
            [gbLabel setTextColor:[UIColor lightGrayColor]];
        }
        
        //评论
        UIButton *zhaopian = [UIButton buttonWithType:UIButtonTypeCustom];
        [zhaopian setFrame:CGRectMake(wid, 0.0, wid, backView.frame.size.height)];
        
        UILabel *zpLabel = [[UILabel alloc]initWithFrame:zhaopian.frame];
        zpLabel.backgroundColor = [UIColor clearColor];
        NSString *zpString = @"";
        if (self.commentArray && self.commentArray.count) {
            zpString = [NSString stringWithFormat:@"广播 %lu",(unsigned long)self.commentArray.count];
        } else {
            zpString = self.blogModel.commentCount.stringValue;
        }
        [zpLabel setText:zpString];
        [zpLabel setTextAlignment:NSTextAlignmentCenter];
        if ([self.commentOrSupport isEqualToString:@"1"]) {
            [zpLabel setTextColor:[UIColor blackColor]];
        } else {
            [zpLabel setTextColor:[UIColor lightGrayColor]];
        }
        
        //稀饭
        UIButton *daoguo = [UIButton buttonWithType:UIButtonTypeCustom];
        [daoguo setFrame:CGRectMake(wid * 2, 0.0, wid, backView.frame.size.height)];
        
        UILabel *dgLabel = [[UILabel alloc]initWithFrame:daoguo.frame];
        dgLabel.backgroundColor = [UIColor clearColor];
        NSString *dgString = @"";
        if (self.supportArray && self.supportArray.count) {
            dgString = [NSString stringWithFormat:@"广播 %lu",(unsigned long)self.supportArray.count];
        } else {
            dgString = self.blogModel.likeCount.stringValue;
        }
        [dgLabel setText:dgString];
        [dgLabel setTextAlignment:NSTextAlignmentCenter];
        if ([self.commentOrSupport isEqualToString:@"2"]) {
            [dgLabel setTextColor:[UIColor blackColor]];
        } else {
            [dgLabel setTextColor:[UIColor lightGrayColor]];
        }
        
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
            
            if ([self.commentOrSupport isEqualToString:@"3"]) {
                return ;
            }
            if (self.supportArray.count == 0) {
                self.commentOrSupport = @"3";
//                [self requestSupport:@"0"];
            } else {
                self.commentOrSupport = @"3";
                
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        } forControlEvents:UIControlEventTouchUpInside];
        [zhaopian bk_addEventHandler:^(id sender) {
            [gbLabel setTextColor:[UIColor lightGrayColor]];
            [zpLabel setTextColor:[UIColor blackColor]];
            [dgLabel setTextColor:[UIColor lightGrayColor]];
            
            if ([self.commentOrSupport isEqualToString:@"1"]) {
                return ;
            }
            self.commentOrSupport = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        } forControlEvents:UIControlEventTouchUpInside];
        [daoguo bk_addEventHandler:^(id sender) {
            [gbLabel setTextColor:[UIColor lightGrayColor]];
            [zpLabel setTextColor:[UIColor lightGrayColor]];
            [dgLabel setTextColor:[UIColor blackColor]];
            
            if ([self.commentOrSupport isEqualToString:@"2"]) {
                return ;
            }
            if (self.supportArray.count == 0) {
                self.commentOrSupport = @"2";
                [self requestSupport:@"0"];
            } else {
                self.commentOrSupport = @"2";
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"SMCircleCell";
        
        SMCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[SMCircleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setSMCircleModel:self.blogModel indexPath:indexPath];
        
        return cell;
    } else {
        if (([self.commentOrSupport isEqualToString:@"1"] && self.commentArray.count == 0) ||
            ([self.commentOrSupport isEqualToString:@"2"] && self.supportArray.count == 0) ||
            ([self.commentOrSupport isEqualToString:@"3"] && self.supportArray.count == 0)) {
            
            static NSString *identifier = @"csCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"无数据";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor grayColor];
            
            return cell;
        } else if ([self.commentOrSupport isEqualToString:@"1"]){
            static NSString *identifier = @"SMCircleDetailCell";
            SMCircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[SMCircleDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell setSMCircleDetailModel:self.commentArray[indexPath.row] indexPath:indexPath];
            
            return cell;
        } else {
            static NSString *identifier = @"SupportCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.contentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
            CCSupportModel *model = self.supportArray[indexPath.row];
            
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:nil];
            [imageView setFrame:CGRectMake(10, 10, 30, 30)];
            [cell.contentView addSubview:imageView];
            
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+ 10,
                                                                          0.0,
                                                                          220.0,
                                                                          50.0)];
            textLabel.text = model.nickName;
            textLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:textLabel];
            
            cell.frame = CGRectMake(0, 0, tableView.frame.size.width, 50.0);
            
            UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, cell.frame.size.height - 0.5, cell.frame.size.width, 0.5)];
            lineImage.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:lineImage];
            
            return cell;
        }
    }
}
#pragma mark - Request
#pragma mark 請求評論列表
//1 -> up   0 -> down(下拉刷新)
- (void)requestComment:(NSString *)upOrdown {
    [SMMessageHUD showLoading:@""];
    /*
     用户博客评论列表
     Request URL:http://120.24.169.36:8080/classmate/m/user/blog/comment/list
     Request Method:POST
     Param: {
     userId:1            （必填，当前用户ID）
     userBlogId:1        （必填，用户博客ID）
     orderBy:addTime     （选填，排序字段，默认为addTime - 评论添加时间）
     orderType:desc      （选填，排序顺序，"desc" - 倒序 或者 "asc" - 升序，默认为desc）
     offset:0            （选填，记录开始索引，默认为0）
     limit:20            （选填，返回记录数，默认为20）
     }
     */
    NSString *offset = [NSString stringWithFormat:@"%lu",upOrdown.integerValue == 0 ? 0 : self.commentArray.count];
    NSString *limit = [NSString stringWithFormat:@"%lu",upOrdown.integerValue == 0 ? 10 : self.commentArray.count + 10];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/blog/comment/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"userBlogId" : self.blogModel.userBlogId,
                                                    @"orderBy" : @"addTime",
                                                    @"orderType" : @"desc",
                                                    @"offset" : offset,
                                                    @"limit" : limit}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              [SMMessageHUD dismissLoading];
                                              if ([success isEqualToString:@"1"]) {
                                                  __block NSMutableArray *newArray = nil;
                                                  if (upOrdown.integerValue == 0) {
                                                      newArray = [NSMutableArray array];
                                                  } else {
                                                      newArray = [NSMutableArray arrayWithArray:self.commentArray];
                                                  }
                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      CCCommentModel *model = [CCCommentModel objectWithKeyValues:obj];
                                                      [newArray addObject:model];
                                                  }];
                                                  self.commentArray = newArray;
                                                  self.commentOrSupport = @"1";
                                                  
                                                  self.blogModel.commentCount = [NSNumber numberWithInteger:self.commentArray.count];
                                                  [self.tableView reloadData];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                              [self.tableView.header endRefreshing];
                                              [self.tableView.footer endRefreshing];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              [self.tableView.header endRefreshing];
                                              [self.tableView.footer endRefreshing];
                                          }];
}
#pragma mark 请求赞列表
//1 -> up   0 -> down(下拉刷新)
- (void)requestSupport:(NSString *)upOrdown{
    [SMMessageHUD showLoading:@""];
    /*
     Request URL:http://localhost:8080/classmate/m/user/blog/like/list
     Request Method:POST
     Param: {
     userId:1            （必填，当前用户ID）
     userBlogId:1        （必填，用户博客ID）
     orderBy:addTime     （选填，排序字段，默认为addTime - 点赞时间）
     orderType:desc      （选填，排序顺序，"desc" - 倒序 或者 "asc" - 升序，默认为desc）
     offset:0            （选填，记录开始索引，默认为0）
     limit:20            （选填，返回记录数，默认为20）
     }
     */
    NSString *offset = [NSString stringWithFormat:@"%lu",upOrdown.integerValue == 0 ? 0 : self.supportArray.count];
    NSString *limit = [NSString stringWithFormat:@"%lu",upOrdown.integerValue == 0 ? 10 : self.supportArray.count + 10];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/blog/like/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"userBlogId" : self.blogModel.userBlogId,
                                                    @"orderBy" : @"addTime",
                                                    @"orderType" : @"desc",
                                                    @"offset" : offset,
                                                    @"limit" : limit}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              [SMMessageHUD dismissLoading];
                                              if ([success isEqualToString:@"1"]) {
                                                  __block NSMutableArray *newArray = nil;
                                                  if (upOrdown.integerValue == 0) {
                                                      newArray = [NSMutableArray array];
                                                  } else {
                                                      newArray = [NSMutableArray arrayWithArray:self.supportArray];
                                                  }
                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      CCSupportModel *model = [CCSupportModel objectWithKeyValues:obj];
                                                      [newArray addObject:model];
                                                  }];
                                                  self.supportArray = newArray;
                                                  
                                                  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                              [self.tableView.header endRefreshing];
                                              [self.tableView.footer endRefreshing];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              [self.tableView.header endRefreshing];
                                              [self.tableView.footer endRefreshing];
                                          }];
}
#pragma mark 稀饭（点赞）
- (void)requestSupportComplete:(void(^)(BOOL success))complete {
    /*
     Request URL:http://120.24.169.36:8080/classmate/m/user/blog/like/save
     Request Method:POST
     Param: {
     userId:1
     userBlogId:1
     }
     */
//    SMCircleCell *cell = (SMCircleCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue + 1];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/user/blog/like/save")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"userBlogId" : self.blogModel.userBlogId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  //表示已赞
                                                  self.blogModel.isLike = @(1);
                                                  self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue + 1];
                                                  if (complete) {
                                                      complete(NO);
                                                  }
                                                  [self requestSupport:@"0"];
                                              } else {
                                                  if (complete) {
                                                      complete(NO);
                                                  }
                                                  self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue - 1];
                                                  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              if (complete) {
                                                  complete(NO);
                                              }
                                              self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue - 1];
                                              [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
- (void)requestDeleteSupportComplete:(void(^)(BOOL success))complete{
    /*
     Request URL:http://120.24.169.36:8080/classmate/m/user/blog/like/delete
     Request Method:POST
     Param: {
     userId:1
     userBlogId:1
     }
     */
//    SMCircleCell *cell = (SMCircleCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue - 1];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/blog/like/delete")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"userBlogId" : self.blogModel.userBlogId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  //表示已取消赞
                                                  self.blogModel.isLike = @(0);
                                                  self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue - 1];
                                                  if (complete) {
                                                      complete(YES);
                                                  }
                                                  [self requestSupport:@"0"];
                                              } else {
                                                  self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue + 1];
                                                  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                                  if (complete) {
                                                      complete(NO);
                                                  }
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              self.blogModel.likeCount = [NSNumber numberWithInteger:self.blogModel.likeCount.integerValue + 1];
                                              [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              if (complete) {
                                                  complete(NO);
                                              }
                                          }];
}
@end
