//
//  CommentItemView.m
//  SchoolMate
//
//  Created by SuperDanny on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "CommentItemView.h"

@implementation CommentItemView

- (void)awakeFromNib {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommentItemView" owner:self options:nil];
    if (array.count) {
        UIView *view = array[0];
        view.frame = self.bounds;
//        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:view];
//        [view setNeedsDisplay];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
