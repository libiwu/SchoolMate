//
//  SCBasicViewController.m
//  SecureCommunication
//
//  Created by libiwu on 14-6-23.
//  Copyright (c) 2014年 andy_wu. All rights reserved.
//

#import "SCBasicViewController.h"

#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface SCBasicViewController ()<UIGestureRecognizerDelegate>{
    
    BOOL            _hiddenTabbar;
    
    BOOL            _hiddenBackButton;
}

@property (nonatomic,strong) NSString * leftMenuTitle;

@property (nonatomic,strong) NSString * rightMenuTitle;

@end

@implementation SCBasicViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithHiddenTabBar:(BOOL)hiddenTabBar hiddenBackButton:(BOOL)hiddenBackButton
{
    self = [super init];
    if (self) {
        _hiddenNavBar = NO;
        
        self.hidesBottomBarWhenPushed = hiddenTabBar;
        
        _hiddenTabbar = hiddenTabBar;
        
        _hiddenBackButton = hiddenBackButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(234.0, 234.0, 234.0, 1.0);
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        } else {
            if (__IPHONE_7_0) {
                self.navigationController.navigationBar.barTintColor = RGBACOLOR(110.0, 200.0, 243.0, 1.0);
//                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationImage.png"] forBarMetrics:UIBarMetricsDefault];
            }else{
                self.navigationController.navigationBar.tintColor = RGBACOLOR(110.0, 200.0, 243.0, 1.0);
//                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationImage.png"] forBarMetrics:UIBarMetricsDefault];

            }
        }
    }
//    if(IS_IOS7) {
//        [self.navigationController.navigationBar setBarTintColor:RGBCOLOR(33.0, 41.0, 44.0)];
//        
//        if(self.navigationController.viewControllers.count == 1) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }else {
//            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        }
//        
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
//    else {
//        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
//    }
    
    if(__IPHONE_7_0){//布局适配
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
    }
    
    if (_hiddenBackButton) {
        self.navigationItem.hidesBackButton = YES;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 80.0, 44.0)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0.0, 11.5, 24.0, 21.0);
        [backButton setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        
        backButton.backgroundColor=[UIColor clearColor];
        backButton.exclusiveTouch = YES;
        [view addSubview:backButton];
        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 0.0, 40.0, 44.0)];
//        label.backgroundColor = [UIColor clearColor];
//        label.text = NSLocalizedString(@"返回", @"导航栏返回按钮");
//        label.textColor = RGBCOLOR(255, 255, 92);
//        label.textAlignment = NSTextAlignmentLeft;
//        [view addSubview:label];
        
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clickBtn.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height);
        [clickBtn addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:clickBtn];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem.tag = 100;
    }
}

- (void)creatContentView {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [GlobalManager shareGlobalManager].currentViewController = self;
    
    self.navigationController.navigationBar.hidden = _hiddenNavBar;
    
    self.navigationController.view.userInteractionEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"当前的controller是---------%@",NSStringFromClass([self class]));
    
    if(__IPHONE_7_0){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        if(![self isKindOfClass:[self.navigationController.viewControllers[0] class]]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if ([CurrentViewController isKindOfClass:[PatternLockViewController class]] ||
//                    [CurrentViewController isKindOfClass:[MyWalletViewController class]] ||
//                    [CurrentViewController isKindOfClass:[SettingMyWalletViewController class]] ||
//                    [CurrentViewController isKindOfClass:[RegisterViewController class]]) {
//                    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//                    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//                } else {
//                    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//                    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//                }
            });
        }
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)leftMenuPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightMenuPressed:(id)sender
{
    
}
- (void)setNavTitle:(NSString *)title
{
    UILabel *lablel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    lablel.text = [NSString stringWithFormat:@"%@",title];
    lablel.textColor = [UIColor blackColor];
    lablel.backgroundColor = [UIColor clearColor];
    lablel.textAlignment = NSTextAlignmentCenter;
    lablel.font = [UIFont boldSystemFontOfSize:18.0];
    lablel.minimumScaleFactor = 0.8;
    lablel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView = lablel;
}
- (void)setNavTitle:(NSString *)title type:(SCNavTitleType)type {
    switch (type) {
        case SCNavTitleTypeDefault:
        {
            [self setNavTitle:title];
        }
            break;
        case SCNavTitleTypeSelect:
        {
            UIView *backView = [[UIView alloc]init];
            [backView setBackgroundColor:RGBACOLOR(164.0, 219.0, 246.0, 1.0)];
            
            UIView *titleView = [[UIView alloc]init];
            [titleView setBackgroundColor:[UIColor clearColor]];
            
            UILabel *lablel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 30.0)];
            [lablel setText:[NSString stringWithFormat:@"%@",title]];
            [lablel setTextColor:[UIColor blackColor]];
            [lablel setBackgroundColor:[UIColor clearColor]];
            [lablel setTextAlignment:NSTextAlignmentCenter];
            [lablel setFont:[UIFont boldSystemFontOfSize:18.0]];
            lablel.minimumScaleFactor = 0.8;
            lablel.adjustsFontSizeToFitWidth = YES;
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [titleBtn setBackgroundColor:[UIColor clearColor]];
            [titleBtn bk_addEventHandler:^(id sender) {
                [self navigationClick:sender];
            } forControlEvents:UIControlEventTouchUpInside];
            
            CGSize size = [lablel.text newSizeWithFont:lablel.font
                                     constrainedToSize:CGSizeMake(200.0, 30.0)
                                         lineBreakMode:NSLineBreakByCharWrapping];
            [lablel setFrame:CGRectMake(lablel.frame.origin.x,
                                        lablel.frame.origin.y,
                                        size.width,
                                        lablel.frame.size.height)];
            [titleView setFrame:lablel.frame];
            [titleView addSubview:lablel];
            
            [backView setFrame:CGRectMake(0.0, 7.0, 200.0, 30.0)];
            [backView addSubview:titleView];
            
            titleView.center = CGPointMake(backView.frame.size.width/2,
                                           backView.frame.size.height/2);
            
            [titleBtn setFrame:backView.bounds];
            [backView addSubview:titleBtn];
            
            self.navigationItem.titleView = backView;
        }
            break;
        default:
            break;
    }
}
- (void)navigationClick:(UIButton *)btn {
    
}
- (void)setLeftMenuTitle:(NSString *)leftMenuTitle andnorImage:(NSString *)norImage selectedImage:(NSString *)selectedimage
{
    _leftMenuTitle = [leftMenuTitle copy];
    UIButton * button = [[UIButton alloc]init];
    UIImage * image = [UIImage imageNamed:norImage ? norImage : @""];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:selectedimage ? selectedimage : @""];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0,image.size.width, image.size.height-3);
    button.exclusiveTouch = YES;
    [button setTitleColor:RGBCOLOR(255, 255, 92) forState:UIControlStateNormal];
    
    [button setTitle:_leftMenuTitle forState:UIControlStateNormal];
    if ([_leftMenuTitle length] > 0) {
        CGSize size = [_leftMenuTitle sizeWithFont:[UIFont systemFontOfSize:18.0]];
        CGRect frame = button.frame;
        frame.size.width = size.width+15;
        button.frame = frame;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem.tag = 100;
}

- (void)setRightMenuTitle:(NSString *)rightMenuTitle andnorImage:(NSString *)norImage selectedImage:(NSString *)selectedimage
{
    _rightMenuTitle = [rightMenuTitle copy];
    UIButton * button = [[UIButton alloc]init];
    UIImage * image = [UIImage imageNamed:norImage ? norImage : @""];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(255, 255, 92) forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:selectedimage ? selectedimage : @""];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0,image.size.width, image.size.height-3);
    button.exclusiveTouch = YES;
    
    [button setTitle:_rightMenuTitle forState:UIControlStateNormal];
    if ([_rightMenuTitle length]) {
        CGSize size = [_rightMenuTitle sizeWithFont:[UIFont systemFontOfSize:18.0]];
        CGRect frame = button.frame;
        frame.size.width = MIN(90.0, size.width + 15) ;
        if (frame.size.width == 90.0) {
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
        button.frame = frame;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
