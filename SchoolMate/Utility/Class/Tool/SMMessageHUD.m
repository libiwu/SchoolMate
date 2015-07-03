//
//  SMMessageHUD.m
//  SchoolMate
//
//  Created by libiwu on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMMessageHUD.h"

@interface SMMessageHUD ()
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@end
@implementation SMMessageHUD
+ (instancetype)shareHUD {
    static SMMessageHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil)
            instance = [[SMMessageHUD alloc]init];
    });
    return instance;
}
#pragma mark - MB HUD
+ (void)showMessage:(NSString *)string afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:AppWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = string;
    hud.margin = 10.f;
    [hud hide:YES afterDelay:delay];
}
+ (void)showLoading:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:AppWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = string;
    hud.margin = 10.f;
}
+ (void)dismissLoading {
    [MBProgressHUD hideAllHUDsForView:AppWindow animated:YES];
}
@end
