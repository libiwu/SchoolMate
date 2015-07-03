//
//  CommentViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/7/4.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "CommentViewController.h"
#import "IQTextView.h"
#import "IQKeyboardManager.h"

@interface CommentViewController () <UITextViewDelegate>
@property (nonatomic, strong) IQTextView *commentTextView;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"发评论"];
    
    [self setLeftMenuTitle:@"取消" andnorImage:nil selectedImage:nil];
    [self setRightMenuTitle:@"发送" andnorImage:nil selectedImage:nil];
    
    [self createContentView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}
- (void)leftMenuPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightMenuPressed:(id)sender {
    if ([self.commentTextView.text isEqualToString:@"写评论..."]) {
        [SMMessageHUD showMessage:@"请写评论" afterDelay:1.0];
    } else {
        [self requestSaveComment];
    }
}
- (void)createContentView {
    {
        IQTextView *text = [[IQTextView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0)];
        [text setDelegate:self];
        [text setBackgroundColor:[UIColor whiteColor]];
        [text setPlaceholder:@"写评论..."];
        [text setTextColor:[UIColor grayColor]];
        [text setFont:[UIFont systemFontOfSize:18.0]];
        [text becomeFirstResponder];
        [self.view addSubview:text];
        self.commentTextView = text;
        [IQKeyboardManager sharedManager].canAdjustTextView = YES;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    }
    {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          id object = note.userInfo;
                                                          CGSize size = [object[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
                                                          CGRect frame = self.commentTextView.frame;
                                                          frame.size.height = KScreenHeight - 64.0 - size.height;
                                                          self.commentTextView.frame = frame;
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          CGRect frame = self.commentTextView.frame;
                                                          frame.size.height = KScreenHeight - 64.0;
                                                          self.commentTextView.frame = frame;
                                                      }];
    }
}
#pragma mark - UITextViewDelegate

#pragma mark - request
#pragma mark 发送评论
- (void)requestSaveComment {
    [SMMessageHUD showLoading:@""];
    /*
     Param: {
     userId:1                 （必填，当前用户ID）
     boardBlogId:2            （必填，黑板报博客ID）
     content:有钱就是任性!    （必填，评论内容）
     }
     */
    [[AFHTTPRequestOperationManager manager] POST:kSMUrl(@"/classmate/m/board/blog/comment/save")
                                       parameters:@{@"userId" : [GlobalManager shareGlobalManager].userInfo.userId,
                                                    @"boardBlogId" : self.bbnpModel.boardBlogId,
                                                    @"content" : self.commentTextView.text}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSString *success = [Tools filterNULLValue:responseObject[@"success"]];
                                              [SMMessageHUD dismissLoading];
                                              if ([success isEqualToString:@"1"]) {
                                                  [SMMessageHUD showMessage:@"评论成功" afterDelay:1.0];
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                              } else {
                                                  NSString *string = [Tools filterNULLValue:responseObject[@"message"]];
                                                  [SMMessageHUD showMessage:string afterDelay:2.0];
                                              }
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SMMessageHUD dismissLoading];
                                              [SMMessageHUD showMessage:@"网络错误" afterDelay:1.0];
                                          }];
}
@end
