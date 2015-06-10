//
//  GlobalManager.m
//  SchoolMate
//
//  Created by libiwu on 15/6/9.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "GlobalManager.h"

@implementation GlobalManager
+ (instancetype)shareGlobalManager {
    static GlobalManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil)
            instance = [[GlobalManager alloc]init];
    });
    return instance;
}
- (instancetype)init {
    self  = [super init];
    if (self) {
        
    }
    return self;
}
@end
