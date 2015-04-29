//
//  ForumTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/3/30.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumModel.h"
@class ForumTableViewCell;
@protocol forumTableViewCellDelegate <NSObject>
-(void) forumTableViewCellClickIcon:(NSString *)nameString iconView:(UIImage *)iconView id:(NSString *)userId;
@end
@interface ForumTableViewCell : UITableViewCell

- (void)setData:(ForumModel *)model;
@property (nonatomic, assign) id<forumTableViewCellDelegate> delegate;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;
@end
