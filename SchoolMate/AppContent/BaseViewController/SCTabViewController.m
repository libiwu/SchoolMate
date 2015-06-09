//
//  DLMTabViewController.m
//  DLMacaoApp
//
//  Created by libiwu on 14-6-14.
//  Copyright (c) 2014年 andy_wu. All rights reserved.
//

#import "SCTabViewController.h"

#import "SMCircleViewController.h"
#import "FindSMViewController.h"
#import "WhisperViewController.h"
#import "BBNewspaperViewController.h"
#import "MoreViewController.h"

@implementation SCTabViewController

- (void)dealloc
{
    NSLog(@"%@.dealloc has called",NSStringFromClass([self class]));
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    UINavigationController *smNav = [self createNavigationControllerWithRootController:[SMCircleViewController class]
                                                                           tabBarTitle:NSLocalizedString(@"同学圈", nil)
                                                                            imageNamed:@"tabbar"
                                                                    selectedImageNamed:@"tabbar_hl"];
    
    
    UINavigationController *fsmNav = [self createNavigationControllerWithRootController:[FindSMViewController class]
                                                                            tabBarTitle:NSLocalizedString(@"找同学", nil)
                                                                             imageNamed:@"tabbar"
                                                                     selectedImageNamed:@"tabbar_hl"];
    
    UINavigationController *wNav = [self createNavigationControllerWithRootController:[WhisperViewController class]
                                                                          tabBarTitle:NSLocalizedString(@"悄悄话", nil)
                                                                           imageNamed:@"tabbar"
                                                                   selectedImageNamed:@"tabbar_hl"];
    
    UINavigationController *bbNav = [self createNavigationControllerWithRootController:[BBNewspaperViewController class]
                                                                           tabBarTitle:NSLocalizedString(@"黑板报", nil)
                                                                            imageNamed:@"tabbar"
                                                                    selectedImageNamed:@"tabbar_hl"];
    
    UINavigationController *moreNav = [self createNavigationControllerWithRootController:[MoreViewController class]
                                                                             tabBarTitle:NSLocalizedString(@"更多", nil)
                                                                              imageNamed:@"tabbar"
                                                                      selectedImageNamed:@"tabbar_hl"];

    self.viewControllers = @[smNav, fsmNav, wNav, bbNav, moreNav];
    
    //自定义tabbar背景
//    self.tabBar.tintColor = [UIColor blueColor];
//    self.tabBar.barTintColor = [UIColor blueColor];
//    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
//    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_selectedIndicator"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:9/255.0 green:187/255.0 blue:7/255.0 alpha:1];
}


- (UINavigationController *)createNavigationControllerWithRootController:(Class) vcClass
                                                             tabBarTitle:(NSString *)title
                                                              imageNamed:(NSString *)imageName
                                                      selectedImageNamed:(NSString *)selectedImageName{
    
    SCBasicViewController *vc = [[vcClass alloc] initWithHiddenTabBar:NO hiddenBackButton:YES];
    
    //tabBarItem自定义
    UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selectedImageName]];
    //字体属性
//    [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    vc.tabBarItem = barItem;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    return nav;
}

- (void)setTabBarHidden:(BOOL)hidden
{
    self.tabBarController.hidesBottomBarWhenPushed = hidden;
    self.tabBar.hidden = hidden;
}

@end





