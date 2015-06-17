//
//  BBPlaceViewController.h
//  SchoolMate
//
//  Created by SuperDanny on 15/6/17.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  发表黑板报地点

#import <UIKit/UIKit.h>
#import "SCBasicViewController.h"

typedef void(^SetPlaceBlock)(NSString *placeStr);

@interface BBPlaceViewController : SCBasicViewController

@property (copy, nonatomic) SetPlaceBlock block;

@end
