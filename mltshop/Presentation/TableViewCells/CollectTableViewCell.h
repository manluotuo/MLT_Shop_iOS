//
//  CollectTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/3/11.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CollectModel;
@interface CollectTableViewCell : UITableViewCell

- (void)setNewData:(CollectModel *)model;
- (CGFloat)setCellHeight;

@end
