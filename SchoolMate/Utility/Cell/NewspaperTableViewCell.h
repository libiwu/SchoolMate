//
//  NewspaperTableViewCell.h
//  SchoolMate
//
//  Created by SuperDanny on 15/6/15.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackBoardModel : NSObject
/**
 boardBlogId":
 boardId":1,
 content":"我们
 blogType":2,
 photoDate":40
 photoLocation
 addLocation":
 addTime":1435
 addUserId":1,
 mobileNo":"13
 nickName":"同
 headImageUrl"
 isLike":0,
 commentCount"
 likeCount":0,
 images":[
 */
@property (nonatomic, copy  ) NSString *boardBlogId;
@property (nonatomic, copy  ) NSString *boardId;
@property (nonatomic, copy  ) NSString *content;
@property (nonatomic, copy  ) NSString *blogType;
@property (nonatomic, copy  ) NSString *photoDate;
@property (nonatomic, copy  ) NSString *photoLocation;
@property (nonatomic, copy  ) NSString *addLocation;
@property (nonatomic, copy  ) NSString *addTime;
@property (nonatomic, copy  ) NSString *addUserId;
@property (nonatomic, copy  ) NSString *mobileNo;
@property (nonatomic, copy  ) NSString *nickName;
@property (nonatomic, copy  ) NSString *headImageUrl;
@property (nonatomic, copy  ) NSString *isLike;
@property (nonatomic, copy  ) NSString *commentCount;
@property (nonatomic, copy  ) NSString *likeCount;
@property (nonatomic, strong) NSArray  *images;

@end

@interface NewspaperTableViewCell : UITableViewCell

@property (strong, nonatomic) BlackBoardModel *model;
+ (CGFloat)configureCellHeightWithModel:(BlackBoardModel *)model;
- (void)setContentWithModel:(BlackBoardModel *)model;

@end
