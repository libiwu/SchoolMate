//
//  AlbumContentsViewCell.m
//  AssetsLibraryPra1
//
//  Created by 庞东明 on 10/10/14.
//  Copyright (c) 2014 ZhongAo. All rights reserved.
//

#import "AlbumContentsViewCell.h"

@implementation AlbumContentsViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createContentView];

    }
    return self;
}

- (void)createContentView{

    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    
    //选择蒙板
    _selectedView = [[UIView alloc] initWithFrame:self.bounds];
    _selectedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _selectedView.userInteractionEnabled = YES;
    _selectedView.hidden = YES;
    [self.contentView addSubview:_selectedView];
    
    //选择
    _selectedButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-30.0, 0, 30.0, 30.0)];
    _selectedButton.layer.cornerRadius = _selectedButton.frame.size.width/2.0;
    [_selectedButton setImage:[UIImage imageNamed:@"CellNotSelected"] forState:UIControlStateNormal];
    [_selectedButton setImage:[UIImage imageNamed:@"CellBlueSelected"] forState:UIControlStateSelected];
    [_selectedButton addTarget:self action:@selector(handleSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    _selectedButton.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_selectedButton];
    
}

- (void)handleSelectedButton:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(albumContentsViewCell:shouldSelectButton:)]) {
        BOOL enable = [self.delegate albumContentsViewCell:self shouldSelectButton:btn];
        
            if (btn.selected) {
                btn.selected = NO;
                _selectedView.hidden = YES;
                if ([self.delegate respondsToSelector:@selector(albumContentsViewCell:DidSelectButton:)]) {
                    [self.delegate albumContentsViewCell:self DidSelectButton:btn];
                }
            }else if(enable){
                btn.selected = YES;
                _selectedView.hidden = NO;
                if ([self.delegate respondsToSelector:@selector(albumContentsViewCell:DidSelectButton:)]) {
                    [self.delegate albumContentsViewCell:self DidSelectButton:btn];
                }
            }
    }
}



@end
