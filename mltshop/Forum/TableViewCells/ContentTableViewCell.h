//
//  ContentTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/4/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ForumDetailModel;
@class ContentTableViewCell;
@protocol contentTableViewCellDelegate <NSObject>

@optional
-(void)contentTableViewCellIconDidClick:(ContentTableViewCell *)cell;
@end


@interface ContentTableViewCell : UITableViewCell
/** 头像 */
@property (nonatomic, strong) UIButton *userBtn;
/** 用户名 */
@property (nonatomic, strong) UILabel *userLable;

@property (nonatomic, copy) NSString *userId;
- (void)setNewData:(ForumDetailModel *)data;
@property (nonatomic, weak) id<contentTableViewCellDelegate> delegate;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
