//
//  ViewController.m
//  AssetsLibraryPra1
//
//  Created by 庞东明 on 10/9/14.
//  Copyright (c) 2014 ZhongAo. All rights reserved.
//

#import "AssetsGroupsTabelView.h"
#import "AlbumContentsViewController.h"
#import "AssetsGroupsTabelView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PageViewControllerData.h"
#import "SCImagesPickerController.h"
@implementation AssetsGroupsTabelView

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 80.0, 44.0)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 7.0, 15.0, 30.0);
    backButton.backgroundColor=[UIColor clearColor];
    backButton.exclusiveTouch = YES;
    [view addSubview:backButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 0.0, 60.0, 44.0)];
    label.backgroundColor = [UIColor clearColor];
    label.text = NSLocalizedString(@"返回", nil);
    label.textColor = [UIColor colorWithRed:13/255.0 green:122/255.0 blue:1 alpha:1];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height);
    [clickBtn addTarget:self action:@selector(leftMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:clickBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem.tag = 100;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)leftMenuPressed:(id)sender;//左边按钮被点击，子类重载
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidCanceledPickingImagesNotification object:nil];
}

#pragma mark - HandleButtonEvent

- (void)handleCancelItem:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidCanceledPickingImagesNotification object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    ALAssetsGroup *groupForCell = self.groups[indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    cell.imageView.image = posterImage;
    cell.textLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [@(groupForCell.numberOfAssets) stringValue];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
//去掉多余的线
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ALAssetsGroup *groupForCell = self.groups[indexPath.row];
    //清空单例已选数据
    [[PageViewControllerData sharedInstance].selectedIndexPaths removeAllObjects];

    AlbumContentsViewController *VC = [[AlbumContentsViewController alloc] init];
    VC.assetsGroup = groupForCell;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:VC animated:YES];

}

@end