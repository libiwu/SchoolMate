//
//  SaySomethingReusableView.h
//  SecureCommunication
//  这一刻的想法
//  Created by 庞东明 on 8/12/14.
//  Copyright (c) 2014 andy_wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaySomethingReusableView : UICollectionReusableView

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) NSString *textViewPlaceholder;//占位字符串

@end
