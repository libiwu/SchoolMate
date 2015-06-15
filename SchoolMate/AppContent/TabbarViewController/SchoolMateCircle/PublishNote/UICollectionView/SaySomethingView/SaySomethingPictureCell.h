//
//  HeadImageCell.h
//  SecureCommunication
//
//  Created by 庞东明 on 8/12/14.
//  Copyright (c) 2014 andy_wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaySomethingPictureCellDelegate <NSObject>
@optional
- (void)SaySomethingPictureCellClickDeleteButton:(UIButton *)button AtPoint:(CGPoint)point;

@end

@interface SaySomethingPictureCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;

- (void)setPlusSymImage;//设置+头像

@property (nonatomic,assign) id<SaySomethingPictureCellDelegate> delegate;
@end
