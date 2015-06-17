//
//  HeadImageCell.m
//  SecureCommunication
//
//  Created by 庞东明 on 8/12/14.
//  Copyright (c) 2014 andy_wu. All rights reserved.
//

#import "SaySomethingPictureCell.h"
@implementation SaySomethingPictureCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.tag = 800;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
        
    }
    return self;
}
- (void)setPlusSymImage{
    _imageView.image = [UIImage imageNamed:@"22"];
    self.selectedBackgroundView = nil;
}
@end
