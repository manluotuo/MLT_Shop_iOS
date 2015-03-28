//
//  OrderDetailModel.h
//  mltshop
//
//  Created by 小新 on 15/3/14.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_sn;
/** 用户id */
@property (nonatomic, strong) NSString *user_id;
/** 收货人 */
@property (nonatomic, strong) NSString *consignee;
/** 地址 */
@property (nonatomic, strong) NSString *address;
/** 电话号码 */
@property (nonatomic, strong) NSString *tel;
/** 快递方式 */
@property (nonatomic, strong) NSString *shipping_name;
@property (nonatomic, strong) NSString *pay_id;
/** 支付方式 */
@property (nonatomic, strong) NSString *pay_name;
/** 用户名 */
@property (nonatomic, strong) NSString *user_name;
/** 下单时间 */
@property (nonatomic, strong) NSString *formated_add_time;

/** 订单金额 */
@property (nonatomic, strong) NSString *formated_order_amount;
/** 邮费金额 */
@property (nonatomic, strong) NSString *formated_shipping_fee;
/** 应付总额 */
@property (nonatomic, strong) NSString *order_amount;
/** 订单编号 */
@property (nonatomic, strong) NSString *invoice_no;

@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSString *shipping_status;
@property (nonatomic, strong) NSString *pay_status;


@end




















