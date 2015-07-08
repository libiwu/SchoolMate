//
//  NewspaperTableViewCell.m
//  SchoolMate
//
//  Created by SuperDanny on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "NewspaperTableViewCell.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

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
                                           andSize:CGSizeMake(212.0, 10000.0)].height;
    CGFloat height = defaultHeight+contentHeight;
    return height;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self setContentWithModel:_model];
//}

- (void)setContentWithModel:(BBNPModel *)model {
    self.bbnpModel = model;
    if ([model.addUserId isEqualToString:[GlobalManager shareGlobalManager].userInfo.userId.stringValue]) {
        self.deleteButton.hidden = NO;
    } else {
        self.deleteButton.hidden = YES;
    }
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
//        sharePicImgV.clipsToBounds = YES;
        sharePicImgV.contentMode = UIViewContentModeScaleAspectFill;
        sharePicImgV.userInteractionEnabled = YES;
        sharePicImgV.tag = idx + 10000;
        [sharePicImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
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
    _commentView.frame = CGRectMake(CGRectGetMaxX(_likeView.frame) + 10,
                                    CGRectGetMinY(_likeView.frame),
                                    _likeView.frame.size.width,
                                    19);
    _deleteButton.frame = CGRectMake(CGRectGetMaxX(_commentView.frame) + 2,
                                     CGRectGetMinY(_likeView.frame) - 5.5,
                                     _likeView.frame.size.width,
                                     30);
    _leftBgView.frame = CGRectMake(0,
                                   0,
                                   _leftBgView.frame.size.width,
                                   contentHeight + defaultHeight);
    _rightBgView.frame = CGRectMake(CGRectGetMaxX(_leftBgView.frame),
                                    0,
                                    _rightBgView.frame.size.width,
                                    CGRectGetHeight(_leftBgView.frame));
    _lineImageV.frame = CGRectMake(67, 0, 3, CGRectGetHeight(_leftBgView.frame));
    _rightMainBgView.frame = CGRectMake(0, 20, _rightMainBgView.frame.size.width, CGRectGetHeight(_rightBgView.frame)-20);
}
#pragma mark -
#pragma mark 点击查看大图
- (void)tapImage:(UITapGestureRecognizer *)tap {
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.bbnpModel.images.count];
    for (int i = 0; i<self.bbnpModel.images.count; i++) {
        BBNPImageModel *model = self.bbnpModel.images[i];
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:model.imageUrl]; // 图片路径
        photo.srcImageView = (UIImageView *)[_sharePicScrollV viewWithTag:i + 10000]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 10000; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

#pragma mark  喜欢
- (IBAction)likeAction:(id)sender {
//    [SMMessageHUD showMessage:@"稀饭" afterDelay:1.0];
    if (self.supportBlock) {
        self.supportBlock(sender);
    }
}

#pragma mark 评论
- (IBAction)commentAction:(id)sender {
//    [SMMessageHUD showMessage:@"评论" afterDelay:1.0];
    if (self.commentBlock) {
        self.commentBlock(sender);
    }
}
- (IBAction)deleteBtn:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(sender);
    }
}
- (void)setCommentAction:(CommentClick)comment {
    self.commentBlock = comment;
}
- (void)setSupportAction:(SupportClick)support {
    self.supportBlock = support;
}
- (void)setDeleteAction:(DeleteClick)deleteAction {
    self.deleteBlock = deleteAction;
}
@end

