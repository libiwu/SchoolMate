//
//  SaySomethingViewController.h
//  SecureCommunication
//  发表说说
//  Created by 庞东明 on 10/9/14.
//  Copyright (c) 2014 andy_wu. All rights reserved.
//

#import "SCBasicViewController.h"
#import "SaySomethingReusableView.h"

extern NSString *kFriendCircleViewReloadDataNotification;
extern NSString *kEnableScrollToTopFlagNotification;
///聊天信息
@interface SaySomethingViewController : SCBasicViewController

@property (nonatomic,strong) NSMutableArray *imagesArray;//当前照片

@end
