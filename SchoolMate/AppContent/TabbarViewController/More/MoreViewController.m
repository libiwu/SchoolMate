//
//  MoreViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "MoreViewController.h"
#import "UserInfoView.h"

@interface MoreViewController ()
@property (nonatomic, strong) UserInfoView *userInfoView;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"更多", nil)];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.userInfoView) {
        UserInfoView *view = [[UserInfoView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0 - 49.0)];
        [view setUp];
        [self.view addSubview:view];
        
        self.userInfoView = view;
    } else {
        [self.userInfoView refreshContentArray];
    }
}
@end
