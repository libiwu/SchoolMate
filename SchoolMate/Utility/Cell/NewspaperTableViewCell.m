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
    
    CGFloat defaultHeight = 172;
    
    CGFloat contentHeight = [Tools getSizeOfString:model.content
                                           andFont:[UIFont systemFontOfSize:15]
                                           andSize:CGSizeMake(197, 10000)].height;
    CGFloat height = defaultHeight+contentHeight;
    return height;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self setContentWithModel:_model];
//}

- (void)setContentWithModel:(BBNPModel *)model {
    _likeCountLab.text    = model.likeCount;
    _commentCountLab.text = model.commentCount;
    _userNameLab.text     = model.nickName;
    _userBornLab.text     = [SMTimeTool stringFrom_SM_DBTimeInterval:model.addTime.doubleValue dateFormat:@"yyyy/mm/dd"];
    _userTagLab.text      = [model.blogType isEqualToString:@"1"] ? @"现状" : @"怀旧";
    _userTagLab.backgroundColor = [model.blogType isEqualToString:@"1"] ? RGBCOLOR(107, 195, 242) : [UIColor redColor];
    [_userHeaderImgV sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]
                       placeholderImage:nil];
    
    _sharePicScrollV.contentSize = CGSizeMake(_sharePicScrollV.frame.size.width*[model.images count], 105);
    WEAKSELF
    [model.images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BBNPImageModel *model = obj;
        UIImageView *sharePicImgV = [[UIImageView alloc] initWithFrame:CGRectMake(idx*_sharePicScrollV.frame.size.width, 0, _sharePicScrollV.frame.size.width, _sharePicScrollV.frame.size.height)];
        [sharePicImgV sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]
                        placeholderImage:nil];
        [weakSelf.sharePicScrollV addSubview:sharePicImgV];
    }];
    
    CGFloat defaultHeight = 172;
    
    _contentLab.text = model.content;
    CGFloat contentHeight = [Tools getSizeOfString:model.content
                                           andFont:[UIFont systemFontOfSize:15]
                                           andSize:CGSizeMake(_contentLab.frame.size.width, 10000)].height;
    _contentLab.frame = CGRectMake(CGRectGetMinX(_sharePicScrollV.frame),
                                   CGRectGetMaxY(_sharePicScrollV.frame)+8,
                                   _contentLab.frame.size.width,
                                   contentHeight);
    _likeView.frame = CGRectMake(CGRectGetMinX(_contentLab.frame),
                                 CGRectGetMaxY(_contentLab.frame)+8,
                                 _likeView.frame.size.width,
                                 19);
    _commentView.frame = CGRectMake(CGRectGetMaxX(_likeView.frame)+17,
                                    CGRectGetMinY(_likeView.frame),
                                    _leftBgView.frame.size.width,
                                    19);
    _leftBgView.frame = CGRectMake(0,
                                   0,
                                   _leftBgView.frame.size.width,
                                   contentHeight+defaultHeight);
    _rightBgView.frame = CGRectMake(CGRectGetMaxX(_leftBgView.frame),
                                    0,
                                    _rightBgView.frame.size.width,
                                    CGRectGetHeight(_leftBgView.frame));
    _lineImageV.frame = CGRectMake(67, 0, 3, CGRectGetHeight(_leftBgView.frame));
    _rightMainBgView.frame = CGRectMake(0, 20, _rightMainBgView.frame.size.width, CGRectGetHeight(_rightBgView.frame)-20);
}

#pragma mark - 喜欢
- (IBAction)likeAction:(id)sender {
//    [SMMessageHUD showMessage:@"稀饭" afterDelay:1.0];
    if (self.supportBlock) {
        self.supportBlock(sender);
    }
}

#pragma mark - 评论
- (IBAction)commentAction:(id)sender {
//    [SMMessageHUD showMessage:@"评论" afterDelay:1.0];
    if (self.commentBlock) {
        self.commentBlock(sender);
    }
}

- (void)setCommentAction:(CommentClick)comment {
    self.commentBlock = comment;
}
- (void)setSupportAction:(SupportClick)support {
    self.supportBlock = support;
}
@end

