//
//  SMMessageHUD.h
//  SchoolMate
//
//  Created by libiwu on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMessageHUD : NSObject
+ (void)showMessage:(NSString *)string afterDelay:(NSTimeInterval)delay;
@end
