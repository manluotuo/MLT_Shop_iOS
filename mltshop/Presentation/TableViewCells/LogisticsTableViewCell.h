//
//  LogisticsTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/3/27.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LogisticsModel;

@interface LogisticsTableViewCell : UITableViewCell

- (void)setNewData:(LogisticsModel *)_newData andType:(BOOL)type;

@end
