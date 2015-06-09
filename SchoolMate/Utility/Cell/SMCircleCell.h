//
//  SMCircleCell.h
//  SchoolMate
//
//  Created by libiwu on 15/6/8.
//  Copyright (c) 2015年 libiwu. All rights reserved.
//
//  同学圈 cell

#import <UIKit/UIKit.h>

@interface SMCircleCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSMCircleModel:(id)object indexPath:(NSIndexPath *)indexPath;

@end


//@interface SMCircleModel : NSObject
//@property (nonatomic, strong) NSString *url;
//@property (nonatomic, strong) nss
//@end