//
//  SCBasicViewController.h
//  SecureCommunication
//
//  Created by libiwu on 14-6-23.
//  Copyright (c) 2014年 andy_wu. All rights reserved.
//
//  所有ViewController的基类

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCNavTitleType) {
    SCNavTitleTypeDefault = 0,
    SCNavTitleTypeSelect,
};

@interface SCBasicViewController : UIViewController

@property (nonatomic,assign) BOOL hiddenNavBar;

- (id)initWithHiddenTabBar:(BOOL)hiddenTabBar hiddenBackButton:(BOOL)hiddenBackButton;

- (void)leftMenuPressed:(id)sender;

- (void)rightMenuPressed:(id)sender;

- (void)setLeftMenuTitle:(NSString *)leftMenuTitle
             andnorImage:(NSString *)norImage
           selectedImage:(NSString *)selectedimage;

- (void)setRightMenuTitle:(NSString *)rightMenuTitle
              andnorImage:(NSString *)norImage
            selectedImage:(NSString *)selectedimage;

- (void)setNavTitle:(NSString *)title;

- (void)setNavTitle:(NSString *)title type:(SCNavTitleType)type;

- (void)navigationClick:(UIButton *)btn;

- (void)createContentView;
@end
