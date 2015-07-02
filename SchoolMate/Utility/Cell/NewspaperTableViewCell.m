//
//  NewspaperTableViewCell.m
//  SchoolMate
//
//  Created by SuperDanny on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "NewspaperTableViewCell.h"

@interface NewspaperTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView       *leftBgView;
@property (weak, nonatomic) IBOutlet UIView       *rightBgView;
@property (weak, nonatomic) IBOutlet UIView       *likeView;
@property (weak, nonatomic) IBOutlet UIView       *commentView;
///喜欢总数
@property (weak, nonatomic) IBOutlet UILabel      *likeCountLab;
///评论总数
@property (weak, nonatomic) IBOutlet UILabel      *commentCountLab;
///用户头像
@property (weak, nonatomic) IBOutlet UIImageView  *userHeaderImgV;
///用户名称
@property (weak, nonatomic) IBOutlet UILabel      *userNameLab;
///用户生日
@property (weak, nonatomic) IBOutlet UILabel      *userBornLab;
///用户标签
@property (weak, nonatomic) IBOutlet UILabel      *userTagLab;
///分享的图片
@property (weak, nonatomic) IBOutlet UIScrollView *sharePicScrollV;
///文本
@property (weak, nonatomic) IBOutlet UILabel      *contentLab;

@end

@implementation NewspaperTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)configureCellHeightWithModel:(BBNPModel *)model {
    
    CGFloat defaultHeight = 195;
    
    CGFloat contentHeight = [Tools getSizeOfString:model.content
                                           andFont:[UIFont boldSystemFontOfSize:15]
                                           andSize:CGSizeMake(197, 10000)].height;
    CGFloat height = defaultHeight+contentHeight;
    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setContentWithModel:_model];
}

- (void)setContentWithModel:(BBNPModel *)model {
    _likeCountLab.text    = model.likeCount;
    _commentCountLab.text = model.commentCount;
    _userNameLab.text     = model.nickName;
    _userBornLab.text     = @"";
    _userTagLab.text      = @"旅游";
    [_userHeaderImgV sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]
                       placeholderImage:[UIImage imageNamed:@"contentImage"]];
    
    _sharePicScrollV.contentSize = CGSizeMake(199*[model.images count], 105);
    WEAKSELF
    [model.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BBNPImageModel *model = obj;
        UIImageView *sharePicImgV = [[UIImageView alloc] initWithFrame:CGRectMake(idx*199, 0, 199, 105)];
        [sharePicImgV sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]
                        placeholderImage:[UIImage imageNamed:@"contentImage"]];
        [weakSelf.sharePicScrollV addSubview:sharePicImgV];
    }];
    
    CGFloat defaultHeight = 195;
    
    _contentLab.text = model.content;
    CGFloat contentHeight = [Tools getSizeOfString:model.content
                                           andFont:[UIFont boldSystemFontOfSize:15]
                                           andSize:CGSizeMake(197, 10000)].height;
    _contentLab.frame = CGRectMake(CGRectGetMinX(_sharePicScrollV.frame),
                                   CGRectGetMaxY(_sharePicScrollV.frame)+8,
                                   197,
                                   contentHeight);
    _likeView.frame = CGRectMake(CGRectGetMinX(_contentLab.frame),
                                 CGRectGetMaxY(_contentLab.frame)+8,
                                 60,
                                 19);
    _commentView.frame = CGRectMake(CGRectGetMaxX(_likeView.frame)+17,
                                    CGRectGetMinY(_likeView.frame),
                                    60,
                                    19);
    _leftBgView.frame = CGRectMake(0,
                                   0,
                                   81,
                                   contentHeight+defaultHeight);
    _rightBgView.frame = CGRectMake(CGRectGetMaxX(_leftBgView.frame),
                                    0,
                                    239,
                                    CGRectGetHeight(_leftBgView.frame));
}

#pragma mark - 喜欢
- (IBAction)likeAction:(id)sender {
    [SMMessageHUD showMessage:@"稀饭" afterDelay:1.0];
}

#pragma mark - 评论
- (IBAction)commentAction:(id)sender {
    [SMMessageHUD showMessage:@"评论" afterDelay:1.0];
}

@end

