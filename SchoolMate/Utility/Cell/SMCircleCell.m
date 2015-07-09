//
//  SMCircleCell.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMCircleCell.h"
#import "SMCircleDetailViewController.h"
#import "CCBlogModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface SMCircleCell ()
@property (nonatomic, strong) UIImageView  *backView;
@property (nonatomic, strong) UIImageView  *avatarView;
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *timeLabel;
@property (nonatomic, strong) UILabel      *addressLabel;
@property (nonatomic, strong) UILabel      *contentLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *supportAndCommentView;
@property (nonatomic, strong) CCBlogModel *blogModel;
@end

@implementation SMCircleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp {
    
    self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 10.0, KScreenWidth - 20.0, 0.0)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.backView setUserInteractionEnabled:YES];
    
    self.avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(10.0, 10.0, 50.0, 50.0)];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 5.0,
                                                              self.avatarView.frame.origin.y,
                                                              self.backView.frame.size.width - (CGRectGetMaxY(self.avatarView.frame) + 5.0) - 50.0, 20.0)];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x,
                                                              CGRectGetMaxY(self.nameLabel.frame),
                                                              self.nameLabel.frame.size.width,
                                                              self.nameLabel.frame.size.height)];
    self.timeLabel.font = [UIFont systemFontOfSize:15.0];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.timeLabel.frame.origin.x,
                                                                 CGRectGetMaxY(self.timeLabel.frame),
                                                                 self.timeLabel.frame.size.width,
                                                                 10.0)];
    self.addressLabel.font = [UIFont systemFontOfSize:13.0];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarView.frame.origin.x,
                                                                 CGRectGetMaxY(self.addressLabel.frame) + 5.0,
                                                                 self.backView.frame.size.width - self.avatarView.frame.origin.x * 2,
                                                                 0.0)];
    self.contentLabel.font = [UIFont systemFontOfSize:16.0];
    self.contentLabel.numberOfLines = 0;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0,
                                                                    0.0,
                                                                    self.backView.frame.size.width,
                                                                    235.0)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    
    self.supportAndCommentView = [[UIView alloc]init];
    self.supportAndCommentView.backgroundColor = [UIColor clearColor];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.hidden = YES;
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [self.backView addSubview:self.avatarView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.timeLabel];
//    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.scrollView];
    [self.backView addSubview:self.supportAndCommentView];
    [self.backView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.backView];
}
- (void)setSMCircleModel:(id)object indexPath:(NSIndexPath *)indexPath {
    self.blogModel = object;
    CCBlogModel *model = object;
    if ([model.userId.stringValue isEqualToString:[GlobalManager shareGlobalManager].userInfo.userId.stringValue]) {
        self.deleteBtn.hidden = NO;
    } else {
        self.deleteBtn.hidden = YES;
    }
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:nil];
    
    self.nameLabel.text = model.nickName;
    
    self.timeLabel.text = [SMTimeTool stringFrom_SM_DBTimeInterval:model.createTime.doubleValue dateFormat:@"MM-dd hh:mm"];
    
//    self.addressLabel.text = @"九州城 . 摄影 . 文艺 . 下午茶";
    
    self.contentLabel.text = model.content;
    
    CGSize size = [self.contentLabel.text newSizeWithFont:self.contentLabel.font
                                        constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 2000.0)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x,
                                           self.contentLabel.frame.origin.y,
                                           self.contentLabel.frame.size.width,
                                           size.height)];
    if (model.images.count > 0) {
        [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x,
                                             CGRectGetMaxY(self.contentLabel.frame) + 5.0,
                                             self.scrollView.frame.size.width,
                                             self.scrollView.frame.size.height)];
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        for (int i = 0; i < model.images.count; i ++) {
            CCBlogImageModel *mm = model.images[i];
            UIImageView *iv = [[UIImageView alloc]init];
            [iv sd_setImageWithURL:[NSURL URLWithString:mm.imageUrl] placeholderImage:nil];
            [iv setFrame:CGRectMake(self.scrollView.frame.size.width * i,
                                    0.0,
                                    self.scrollView.frame.size.width,
                                    self.scrollView.frame.size.height)];
            iv.clipsToBounds = YES;
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.userInteractionEnabled = YES;
            iv.tag = i + 10000;
            [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [self.scrollView addSubview:iv];
        }
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * model.images.count,
                                                   self.scrollView.frame.size.height)];
    } else {
        [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x,
                                             CGRectGetMaxY(self.contentLabel.frame) + 5.0,
                                             self.scrollView.frame.size.width,
                                             0.0)];
    }
    
    [self setUpSupport:model.likeCount.stringValue comment:model.commentCount.stringValue broadcast:@"0"];
    
    self.deleteBtn.frame = CGRectMake(CGRectGetMaxX(self.supportAndCommentView.frame),
                                      self.supportAndCommentView.frame.origin.y,
                                      50.0,
                                      self.supportAndCommentView.frame.size.height);
    
    self.backView.frame = CGRectMake(self.backView.frame.origin.x,
                                     self.backView.frame.origin.y,
                                     self.backView.frame.size.width,
                                     CGRectGetMaxY(self.supportAndCommentView.frame));
    
    self.frame = CGRectMake(0.0, 0.0, KScreenWidth, CGRectGetMaxY(self.backView.frame));
}
- (void)setUpSupport:(NSString *)support comment:(NSString *)comment broadcast:(NSString *)broadcast{
    
    [self.supportAndCommentView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    //稀饭,点赞
    UIImageView *supportView = [[UIImageView alloc]init];
//    [supportView setBackgroundColor:[UIColor redColor]];
    [supportView setImage:[UIImage imageNamed:@"2"]];
    [supportView setFrame:CGRectMake(5.0, 10.0, 30.0, 22.0)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, supportView.frame.size.width, supportView.frame.size.height)];
    [label setText:support];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    
    [supportView addSubview:label];
    
    UILabel *ss = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(supportView.frame) + 5.0,
                                                           supportView.frame.origin.y,
                                                           35.0,
                                                           supportView.frame.size.height)];
    [ss setText:@"稀饭"];
    [ss setFont:[UIFont systemFontOfSize:12]];
    [ss setTextColor:[UIColor redColor]];
    
    UIButton *supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [supportBtn setFrame:CGRectMake(CGRectGetMinX(supportView.frame),
                                    supportView.frame.origin.y,
                                    CGRectGetMaxX(ss.frame) - CGRectGetMinX(supportView.frame),
                                    ss.frame.size.height)];
    [supportBtn setBackgroundColor:[UIColor clearColor]];
    [supportBtn bk_addEventHandler:^(id sender) {
        NSLog(@"点击稀饭");
        SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        view.blogModel = self.blogModel;
        [CurrentViewController.navigationController pushViewController:view animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.supportAndCommentView addSubview:supportView];
    [self.supportAndCommentView addSubview:ss];
    [self.supportAndCommentView addSubview:supportBtn];
    
    //评论
    UIImageView *commentView = [[UIImageView alloc]init];
//    [commentView setBackgroundColor:[UIColor blueColor]];
    [commentView setImage:[UIImage imageNamed:@"4"]];
    [commentView setFrame:CGRectMake(CGRectGetMaxX(ss.frame) + 5.0,
                                     supportView.frame.origin.y,
                                     supportView.frame.size.width,
                                     supportView.frame.size.height)];
    
    UILabel *clabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, commentView.frame.size.width, commentView.frame.size.height)];
    [clabel setText:comment];
    [clabel setFont:[UIFont systemFontOfSize:12.0]];
    [clabel setTextAlignment:NSTextAlignmentCenter];
    [clabel setTextColor:[UIColor whiteColor]];
    
    [commentView addSubview:clabel];
    
    UILabel *cc = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentView.frame) + 5.0,
                                                           commentView.frame.origin.y,
                                                           35.0,
                                                           commentView.frame.size.height)];
    [cc setText:@"评论"];
    [cc setFont:[UIFont systemFontOfSize:12]];
    [cc setTextColor:[UIColor blueColor]];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setFrame:CGRectMake(CGRectGetMinX(commentView.frame),
                                    commentView.frame.origin.y,
                                    CGRectGetMaxX(cc.frame) - CGRectGetMinX(commentView.frame),
                                    cc.frame.size.height)];
    [commentBtn setBackgroundColor:[UIColor clearColor]];
    [commentBtn bk_addEventHandler:^(id sender) {
        NSLog(@"点击评论");
        SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        view.blogModel = self.blogModel;
        [CurrentViewController.navigationController pushViewController:view animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.supportAndCommentView addSubview:commentView];
    [self.supportAndCommentView addSubview:cc];
    [self.supportAndCommentView addSubview:commentBtn];
    
    //广播
    UIImageView *broadcastView = [[UIImageView alloc]init];
//    [broadcastView setBackgroundColor:[UIColor greenColor]];
    [broadcastView setImage:[UIImage imageNamed:@"5"]];
    [broadcastView setFrame:CGRectMake(CGRectGetMaxX(cc.frame) + 5.0,
                                     supportView.frame.origin.y,
                                     supportView.frame.size.width,
                                     supportView.frame.size.height)];
    
    UILabel *broadcastlabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, broadcastView.frame.size.width, broadcastView.frame.size.height)];
    [broadcastlabel setText:broadcast];
    [broadcastlabel setFont:[UIFont systemFontOfSize:12.0]];
    [broadcastlabel setTextAlignment:NSTextAlignmentCenter];
    [broadcastlabel setTextColor:[UIColor whiteColor]];
    
    [broadcastView addSubview:broadcastlabel];
    
    UILabel *dd = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(broadcastView.frame) + 5.0,
                                                           broadcastView.frame.origin.y,
                                                           35.0,
                                                           broadcastView.frame.size.height)];
    [dd setText:@"广播"];
    [dd setFont:[UIFont systemFontOfSize:12]];
    [dd setTextColor:[UIColor greenColor]];
    
    UIButton *broadcastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [broadcastBtn setFrame:CGRectMake(CGRectGetMinX(broadcastView.frame),
                                    broadcastView.frame.origin.y,
                                    CGRectGetMaxX(dd.frame) - CGRectGetMinX(broadcastView.frame),
                                    dd.frame.size.height)];
    [broadcastBtn setBackgroundColor:[UIColor clearColor]];
    [broadcastBtn bk_addEventHandler:^(id sender) {
        NSLog(@"点击广播");
        SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        view.blogModel = self.blogModel;
        [CurrentViewController.navigationController pushViewController:view animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.supportAndCommentView addSubview:broadcastView];
    [self.supportAndCommentView addSubview:dd];
    [self.supportAndCommentView addSubview:broadcastBtn];
    
    self.supportAndCommentView.frame = CGRectMake(self.scrollView.frame.origin.x,
                                                  CGRectGetMaxY(self.scrollView.frame),
                                                  CGRectGetMaxX(dd.frame) + 5.0,
                                                  CGRectGetMaxY(dd.frame) + 10.0);
    
    
}

#pragma mark - 点击查看大图
- (void)tapImage:(UITapGestureRecognizer *)tap {
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.blogModel.images.count];
    for (int i = 0; i<self.blogModel.images.count; i++) {
        CCBlogImageModel *model = self.blogModel.images[i];
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:model.imageUrl]; // 图片路径
        photo.srcImageView = (UIImageView *)[self.scrollView viewWithTag:self.scrollView.contentOffset.x/self.scrollView.frame.size.width + 10000]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 10000; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
