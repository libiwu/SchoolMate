//
//  SMCircleCell.m
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import "SMCircleCell.h"
#import "SMCircleDetailViewController.h"

@interface SMCircleCell ()
@property (nonatomic, strong) UIImageView  *backView;
@property (nonatomic, strong) UIImageView  *avatarView;
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *timeLabel;
@property (nonatomic, strong) UILabel      *addressLabel;
@property (nonatomic, strong) UILabel      *contentLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView       *supportAndCommentView;
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
    self.scrollView.pagingEnabled = YES;
    
    self.supportAndCommentView = [[UIView alloc]init];
    self.supportAndCommentView.backgroundColor = [UIColor clearColor];
    
    [self.backView addSubview:self.avatarView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.addressLabel];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.scrollView];
    [self.backView addSubview:self.supportAndCommentView];
    [self.contentView addSubview:self.backView];
}
- (void)setSMCircleModel:(id)object indexPath:(NSIndexPath *)indexPath {
    
    [self.avatarView setImage:[UIImage imageNamed:@"headImage.png"]];
    
    self.nameLabel.text = @"呆萌萌";
    
    self.timeLabel.text = @"昨天 22:33";
    
    self.addressLabel.text = @"九州城 . 摄影 . 文艺 . 下午茶";
    
    self.contentLabel.text = @"悬着这样的环境拍着,就是喜欢这种色调,自然拍摄出来就暖暖的了 .";
    
    CGSize size = [self.contentLabel.text newSizeWithFont:self.contentLabel.font
                                        constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 2000.0)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    [self.contentLabel setFrame:CGRectMake(self.contentLabel.frame.origin.x,
                                           self.contentLabel.frame.origin.y,
                                           self.contentLabel.frame.size.width,
                                           size.height)];
    
    [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x,
                                         CGRectGetMaxY(self.contentLabel.frame) + 5.0,
                                         self.scrollView.frame.size.width,
                                         self.scrollView.frame.size.height)];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    UIImage *image = [UIImage imageNamed:@"contentImage.png"];
    for (int i = 0; i < 3; i ++) {
        UIImageView *iv = [[UIImageView alloc]initWithImage:image];
        [iv setFrame:CGRectMake(self.scrollView.frame.size.width * i,
                                0.0,
                                self.scrollView.frame.size.width,
                                self.scrollView.frame.size.height)];
        [self.scrollView addSubview:iv];
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 3,
                                               self.scrollView.frame.size.height)];
    
    [self setUpSupport:@"26" comment:@"310" broadcast:@"733"];
    
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
    [supportView setBackgroundColor:[UIColor redColor]];
    [supportView setFrame:CGRectMake(20.0, 10.0, 30.0, 20.0)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, supportView.frame.size.width, supportView.frame.size.height)];
    [label setText:support];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    
    [supportView addSubview:label];
    
    UILabel *ss = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(supportView.frame) + 5.0,
                                                           supportView.frame.origin.y,
                                                           40.0,
                                                           supportView.frame.size.height)];
    [ss setText:@"稀饭"];
    [ss setTextColor:[UIColor redColor]];
    
    UIButton *supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [supportBtn setFrame:CGRectMake(CGRectGetMaxX(ss.frame) + 10.0,
                                    supportView.frame.origin.y,
                                    CGRectGetMaxX(ss.frame) - CGRectGetMinX(supportView.frame),
                                    ss.frame.size.height)];
    [supportBtn setBackgroundColor:[UIColor clearColor]];
    [supportBtn bk_addEventHandler:^(id sender) {
        NSLog(@"稀饭");
        SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        [CurrentViewController.navigationController pushViewController:view animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.supportAndCommentView addSubview:supportView];
    [self.supportAndCommentView addSubview:ss];
    [self.supportAndCommentView addSubview:supportBtn];
    
    //评论
    UIImageView *commentView = [[UIImageView alloc]init];
    [commentView setBackgroundColor:[UIColor blueColor]];
    [commentView setFrame:CGRectMake(CGRectGetMaxX(ss.frame) + 10.0,
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
                                                           40.0,
                                                           commentView.frame.size.height)];
    [cc setText:@"评论"];
    [cc setTextColor:[UIColor blueColor]];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setFrame:CGRectMake(CGRectGetMaxX(ss.frame) + 10.0,
                                    commentView.frame.origin.y,
                                    CGRectGetMaxX(cc.frame) - CGRectGetMinX(commentView.frame),
                                    cc.frame.size.height)];
    [commentBtn setBackgroundColor:[UIColor clearColor]];
    [commentBtn bk_addEventHandler:^(id sender) {
        NSLog(@"点击评论");
        SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        [CurrentViewController.navigationController pushViewController:view animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.supportAndCommentView addSubview:commentView];
    [self.supportAndCommentView addSubview:cc];
    [self.supportAndCommentView addSubview:commentBtn];
    
    //广播
    UIImageView *broadcastView = [[UIImageView alloc]init];
    [broadcastView setBackgroundColor:[UIColor greenColor]];
    [broadcastView setFrame:CGRectMake(CGRectGetMaxX(cc.frame) + 10.0,
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
                                                           40.0,
                                                           broadcastView.frame.size.height)];
    [dd setText:@"广播"];
    [dd setTextColor:[UIColor greenColor]];
    
    UIButton *broadcastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [broadcastBtn setFrame:CGRectMake(CGRectGetMaxX(ss.frame) + 10.0,
                                    broadcastView.frame.origin.y,
                                    CGRectGetMaxX(dd.frame) - CGRectGetMinX(broadcastView.frame),
                                    dd.frame.size.height)];
    [broadcastBtn setBackgroundColor:[UIColor clearColor]];
    [broadcastBtn bk_addEventHandler:^(id sender) {
        NSLog(@"点击广播");
        SMCircleDetailViewController *view = [[SMCircleDetailViewController alloc]initWithHiddenTabBar:YES hiddenBackButton:NO];
        [CurrentViewController.navigationController pushViewController:view animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.supportAndCommentView addSubview:broadcastView];
    [self.supportAndCommentView addSubview:dd];
    [self.supportAndCommentView addSubview:broadcastBtn];
    
    self.supportAndCommentView.frame = CGRectMake(self.scrollView.frame.origin.x,
                                                  CGRectGetMaxY(self.scrollView.frame),
                                                  self.scrollView.frame.size.width,
                                                  CGRectGetMaxY(dd.frame) + 10.0);
    
    
}
@end
