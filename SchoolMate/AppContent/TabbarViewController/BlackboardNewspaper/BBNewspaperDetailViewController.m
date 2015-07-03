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

#import "CommentViewController.h"
#import "BBCommentModel.h"

@interface BBNewspaperDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

//当前选择的是评论（1）还是稀饭（2）
@property (nonatomic, assign) NSString *commentOrSupport;
@property (nonatomic, strong) NSArray *commentArray;
@property (nonatomic, strong) NSArray *supportArray;
@end

@implementation BBNewspaperDetailViewController
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
    
    [self requestComment];
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
        if ([weakSelf.commentOrSupport isEqualToString:@"1"]) {
            [weakSelf requestComment];
        } else {
            [weakSelf requestSupport];
        }
    }];
}
- (void)createBottomView {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0.0, KScreenHeight - 49.0 - 64.0, KScreenWidth, 49.0)];
    [backView setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    
    CGFloat wid = backView.frame.size.width/2;
    
    //评论
    UIButton *zhaopian = [UIButton buttonWithType:UIButtonTypeCustom];
    [zhaopian setFrame:CGRectMake(0.0, 0.0, wid, backView.frame.size.height)];
    
    UILabel *zpLabel = [[UILabel alloc]initWithFrame:zhaopian.frame];
    zpLabel.backgroundColor = [UIColor clearColor];
    [zpLabel setText:@"评论"];
    [zpLabel setTextAlignment:NSTextAlignmentCenter];
    [zpLabel setTextColor:[UIColor blackColor]];
    
    
    //稀饭
    UIButton *daoguo = [UIButton buttonWithType:UIButtonTypeCustom];
    [daoguo setFrame:CGRectMake(wid, 0.0, wid, backView.frame.size.height)];
    
    UILabel *dgLabel = [[UILabel alloc]initWithFrame:daoguo.frame];
    dgLabel.backgroundColor = [UIColor clearColor];
    [dgLabel setText:@"稀饭"];
    [dgLabel setTextAlignment:NSTextAlignmentCenter];
    [dgLabel setTextColor:[UIColor blackColor]];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(wid - .5, 10.0, 1.0, 30.0)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    
    [backView addSubview:zpLabel];
    [backView addSubview:dgLabel];
    
    [backView addSubview:zhaopian];
    [backView addSubview:daoguo];
    
    [backView addSubview:line1];
    
    WEAKSELF
    [zhaopian bk_addEventHandler:^(id sender) {
        CommentViewController *vc = [[CommentViewController alloc] init];
        vc.bbnpModel = weakSelf.bbnpModel;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [daoguo bk_addEventHandler:^(id sender) {
        UIButton *btn = sender;
        btn.enabled = NO;
        if ([weakSelf.bbnpModel.isLike isEqualToString:@"0"]) {
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
//                if (self.commentArray.count != 0) {
//                    WEAKSELF
//                    [self.tableView addLegendFooterWithRefreshingBlock:^{
//                        [weakSelf.tableView.footer endRefreshing];
//                    }];
//                } else {
//                    [self.tableView removeFooter];
//                }
                return self.commentArray.count ? self.commentArray.count : 1;
            }
                break;
            case 2:
            {
//                if (self.supportArray.count != 0) {
//                    WEAKSELF
//                    [self.tableView addLegendFooterWithRefreshingBlock:^{
//                        [weakSelf.tableView.footer endRefreshing];
//                    }];
//                } else {
//                    [self.tableView removeFooter];
//                }
                return self.supportArray.count ? self.supportArray.count : 1;
            }
                break;
            default:
                break;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [NewspaperTableViewCell configureCellHeightWithModel:self.bbnpModel];
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0;
    } else {
        return 42.0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 42.0)];
        view.backgroundColor = [UIColor grayColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 1.0, tableView.frame.size.width, 40.0)];
        [backView setBackgroundColor:self.view.backgroundColor];
        [view addSubview:backView];
        
        CGFloat wid = backView.frame.size.width/2;
        
        //评论
        UIButton *zhaopian = [UIButton buttonWithType:UIButtonTypeCustom];
        [zhaopian setFrame:CGRectMake(0.0, 0.0, wid, backView.frame.size.height)];
        
        UILabel *zpLabel = [[UILabel alloc]initWithFrame:zhaopian.frame];
        zpLabel.backgroundColor = [UIColor clearColor];
        [zpLabel setText:[NSString stringWithFormat:@"评论 %lu",(unsigned long)(self.commentArray.count ? self.commentArray.count : self.bbnpModel.commentCount.intValue)]];
        [zpLabel setTextAlignment:NSTextAlignmentCenter];
        if ([self.commentOrSupport isEqualToString:@"1"]) {
            [zpLabel setTextColor:[UIColor blackColor]];
        } else {
            [zpLabel setTextColor:[UIColor lightGrayColor]];
        }
        
        //稀饭
        UIButton *daoguo = [UIButton buttonWithType:UIButtonTypeCustom];
        [daoguo setFrame:CGRectMake(wid, 0.0, wid, backView.frame.size.height)];

        UILabel *dgLabel = [[UILabel alloc]initWithFrame:daoguo.frame];
        dgLabel.backgroundColor = [UIColor clearColor];
        [dgLabel setText:[NSString stringWithFormat:@"稀饭 %lu",(unsigned long)(self.supportArray.count ? self.supportArray.count : self.bbnpModel.likeCount.intValue)]];
        [dgLabel setTextAlignment:NSTextAlignmentCenter];
        if ([self.commentOrSupport isEqualToString:@"2"]) {
            [dgLabel setTextColor:[UIColor blackColor]];
        } else {
            [dgLabel setTextColor:[UIColor lightGrayColor]];
        }
        
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(wid - .5, 5.0, 1.0, 30.0)];
        [line2 setBackgroundColor:[UIColor lightGrayColor]];
        
        UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, backView.frame.size.height - .5, backView.frame.size.width, .5)];
        [line2 setBackgroundColor:[UIColor lightGrayColor]];
        
        [backView addSubview:zpLabel];
        [backView addSubview:dgLabel];
        
        [backView addSubview:zhaopian];
        [backView addSubview:daoguo];
        
        [backView addSubview:line2];
        [backView addSubview:line3];
       
        [zhaopian bk_addEventHandler:^(id sender) {
            [zpLabel setTextColor:[UIColor blackColor]];
            [dgLabel setTextColor:[UIColor lightGrayColor]];
            
            self.commentOrSupport = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [daoguo bk_addEventHandler:^(id sender) {
            [zpLabel setTextColor:[UIColor lightGrayColor]];
            [dgLabel setTextColor:[UIColor blackColor]];
            
            if (self.supportArray.count == 0) {
                [self requestSupport];
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
        NewspaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];

        [cell setContentWithModel:self.bbnpModel];
        
        CGRect frame = cell.lineImageV.frame;
        frame.origin.y = frame.origin.y/2;
        cell.lineImageV.frame = frame;
        
        frame = cell.rightMainBgView.frame;
        frame.origin.y = frame.origin.y/2;
        cell.rightMainBgView.frame = frame;
        
        return cell;
    } else {
        if (([self.commentOrSupport isEqualToString:@"1"] && self.commentArray.count == 0) ||
            ([self.commentOrSupport isEqualToString:@"2"] && self.supportArray.count == 0)) {
            
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
            
            [cell.imageView sd_setImageWithURL:nil placeholderImage:nil];
            cell.textLabel.text = @"";
            return cell;
        }
    }
}
#pragma mark - Request
#pragma mark 請求評論列表
- (void)requestComment {
    [SMMessageHUD showLoading:@""];
    /*
     Param {
     userId:1　　　　　　　 （必填，当前用户ID）
     boardBlogId:2　　　　　（必填，黑板报博客ID）
     }
     */
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/blog/comment/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"boardBlogId" : self.bbnpModel.boardBlogId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              [SMMessageHUD dismissLoading];
                                              if ([success isEqualToString:@"1"]) {
                                                  __block NSMutableArray *newArray = [NSMutableArray array];
                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                      BBCommentModel *model = [BBCommentModel objectWithKeyValues:obj];
                                                      [newArray addObject:model];
                                                  }];
                                                  self.commentArray = newArray;
                                                  self.commentOrSupport = @"1";
                                                  
                                                  self.bbnpModel.commentCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.commentArray.count];
                                                  [self.tableView reloadData];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                              [self.tableView.header endRefreshing];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              [self.tableView.header endRefreshing];
                                          }];
}
#pragma mark 请求赞列表
- (void)requestSupport {
    [SMMessageHUD showLoading:@""];
    /*
     Param {
     userId:1　　　　　　　 （必填，当前用户ID）
     boardBlogId:2　　　　　（必填，黑板报博客ID）
     }
     */
    self.commentOrSupport = @"2";
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/blog/like/list")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"boardBlogId" : self.bbnpModel.boardBlogId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              [SMMessageHUD dismissLoading];
                                              if ([success isEqualToString:@"1"]) {
//                                                  __block NSMutableArray *newArray = [NSMutableArray array];
//                                                  [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                                                      BBCommentModel *model = [BBCommentModel objectWithKeyValues:obj];
//                                                      [newArray addObject:model];
//                                                  }];
//                                                  self.commentArray = newArray;
//                                                  self.commentOrSupport = @"1";
//                                                  
//                                                  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                              [self.tableView.header endRefreshing];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              [self.tableView.header endRefreshing];
                                          }];
}
#pragma mark 稀饭（点赞）
- (void)requestSupportComplete:(void(^)(BOOL success))complete {
    /*
     Param: {
     userId:1　　　　　　　 （必填，当前用户ID）
     boardBlogId:2　　　　　（必填，黑板报博客ID）
     }
     */
    NewspaperTableViewCell *cell = (NewspaperTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.likeCountLab.text = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue + 1];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/blog/like/save")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"boardBlogId" : self.bbnpModel.boardBlogId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  //表示已赞
                                                  self.bbnpModel.isLike = @"1";
                                                  self.bbnpModel.likeCount = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue + 1];
                                                  if (complete) {
                                                      complete(NO);
                                                  }
                                                  [self requestSupport];
                                              } else {
                                                  if (complete) {
                                                      complete(NO);
                                                  }
                                                  cell.likeCountLab.text = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue - 1];
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              if (complete) {
                                                  complete(NO);
                                              }
                                              cell.likeCountLab.text = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue - 1];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
- (void)requestDeleteSupportComplete:(void(^)(BOOL success))complete{
    /*
     Param: {
     userId:1　　　　　　　 （必填，当前用户ID）
     boardBlogId:2　　　　　（必填，黑板报博客ID）
     }
     */
    NewspaperTableViewCell *cell = (NewspaperTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.likeCountLab.text = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue - 1];
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/blog/like/delete")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"boardBlogId" : self.bbnpModel.boardBlogId}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              if ([success isEqualToString:@"1"]) {
                                                  //表示已取消赞
                                                  self.bbnpModel.isLike = @"0";
                                                  self.bbnpModel.likeCount = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue - 1];
                                                  if (complete) {
                                                      complete(YES);
                                                  }
                                                  [self requestSupport];
                                              } else {
                                                  cell.likeCountLab.text = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue + 1];
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                                  if (complete) {
                                                      complete(NO);
                                                  }
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              cell.likeCountLab.text = [NSString stringWithFormat:@"%ld",self.bbnpModel.likeCount.integerValue + 1];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                              if (complete) {
                                                  complete(NO);
                                              }
                                          }];
}
@end
