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

@interface BonusInfoModel : NSObject

/** 红包id */

@property (nonatomic, strong) NSString *bonus_date;
@property (nonatomic, strong) NSString *bonus_id;
@property (nonatomic, strong) NSString *bonus_type_id;
@property (nonatomic, strong) NSString *bonus_sn;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *used_time;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *emailed;
@property (nonatomic, strong) NSString *type_id;
/** 红包名称 */
@property (nonatomic, strong) NSString *type_name;
/** 红包金额 */
@property (nonatomic, strong) NSString *type_money;
@property (nonatomic, strong) NSString *send_type;

@property (nonatomic, strong) NSString *min_amount;
@property (nonatomic, strong) NSString *max_amount;
@property (nonatomic, strong) NSString *send_start_date;
@property (nonatomic, strong) NSString *send_end_date;
@property (nonatomic, strong) NSString *use_start_date;
@property (nonatomic, strong) NSString *use_end_date;
/** 使用最低要求 */
@property (nonatomic, strong) NSString *min_goods_amount;

@end