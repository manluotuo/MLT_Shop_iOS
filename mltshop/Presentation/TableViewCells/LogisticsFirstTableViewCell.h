//
//  LogisticsFirstTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/3/28.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogisticsModel;
@interface LogisticsFirstTableViewCell : UITableViewCell

- (void)setNewData:(LogisticsModel *)_newData andType:(BOOL)type;
@end
