//
//  AlbumContentsViewCell.h
//  AssetsLibraryPra1
//
//  Created by 庞东明 on 10/10/14.
//  Copyright (c) 2014 ZhongAo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumContentsViewCell;
@protocol AlbumContentsViewCellDelegate <NSObject>
///是否允许按钮点击选中状态
- (BOOL)albumContentsViewCell:(AlbumContentsViewCell *)cell shouldSelectButton:(UIButton *)button;
- (void)albumContentsViewCell:(AlbumContentsViewCell *)cell DidSelectButton:(UIButton *)button;

@end

@interface AlbumContentsViewCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIView *selectedView;
@property (nonatomic) UIButton *selectedButton;//选中的打勾

@property (nonatomic,assign) id <AlbumContentsViewCellDelegate> delegate;

@end

