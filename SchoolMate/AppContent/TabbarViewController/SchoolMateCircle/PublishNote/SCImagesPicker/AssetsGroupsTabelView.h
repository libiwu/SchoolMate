//
//  ViewController.h
//  AssetsLibraryPra1
//
//  Created by 庞东明 on 10/9/14.
//  Copyright (c) 2014 ZhongAo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumContentsViewController.h"


@interface AssetsGroupsTabelView : UITableViewController

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;

@end

