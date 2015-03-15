//
//  BonusListModel.h
//  mltshop
//
//  Created by 小新 on 15/3/15.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BonusListModel : NSObject

@property (nonatomic, strong) NSString *bonus_id;
@property (nonatomic, strong) NSString *bonus_name;
@property (nonatomic, strong) NSString *bonus_money;
@property (nonatomic, strong) NSString *bonus_money_order;
@property (nonatomic, strong) NSString *bonus_date;
@property (nonatomic, strong) NSString *bonus_state;
@property (nonatomic, strong) NSDictionary *info;

@end
