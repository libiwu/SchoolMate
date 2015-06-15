//
//  SaySomethingReusableView.m
//  SecureCommunication
//
//  Created by 庞东明 on 8/12/14.
//  Copyright (c) 2014 andy_wu. All rights reserved.
//

#import "SaySomethingReusableView.h"

@interface SaySomethingReusableView ()<UITextViewDelegate>

@property (nonatomic) NSMutableAttributedString *attribString;

@end

@implementation SaySomethingReusableView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.textView];
    }
    return self;
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 150.0)];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor lightGrayColor];
        _textView.delegate = self;
    }
    return _textView;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:_attribString.string]) {
        textView.text = @"";
        _textView.textColor = [UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *trimString = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (trimString.length == 0) {
        _textView.attributedText = _attribString;
    }
}
- (void)setTextViewPlaceholder:(NSString *)textViewPlaceholder{
    if (_attribString == nil && textViewPlaceholder != nil) {
        _attribString = [[NSMutableAttributedString alloc] initWithString:textViewPlaceholder
                                                               attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                            NSFontAttributeName: [UIFont systemFontOfSize:16]}];
        _textView.attributedText = _attribString;
    }
}
@end
