//
//  RegisterViewController.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (nonatomic, strong) UIImageView *backImageView;
//@property (nonatomic, strong) UITextField *phoneTextField;
//@property (nonatomic, strong) UITextField *
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:NSLocalizedString(@"注册", nil)];
    
    [self createContentView];
}
- (void)createContentView {
    
    self.backImageView =
    ({
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenHeight - 64.0)];
        backImage.image = [UIImage imageNamed:@"registerBack.png"];
        backImage.userInteractionEnabled = YES;
        [self.view addSubview:backImage];
        backImage;
    });
}
@end
