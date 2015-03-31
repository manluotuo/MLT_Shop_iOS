//
//  OrderFootTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/3/31.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFootTableViewCell : UITableViewCell

- (void)setNewData:(OrderModel *)_newData;

@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
