//
//  OrderModel.h
//  mltshop
//
//  Created by mactive.meng on 3/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,OrderOps)
{
    OrderOpsList             = 0,
    OrderOpsCancel           = 1,
    OrderOpsPay              = 2,
    OrderOpsAffirmReceived   = 3
};

@interface OrderModel : NSObject

@property(nonatomic, strong)NSString *orderSn;
@property(nonatomic, strong)NSString *orderId;
@property(nonatomic, strong)NSDate *orderTime;
@property(nonatomic, strong)NSString *payCode;
@property(nonatomic, strong)NSString *subject;
@property(nonatomic, strong)NSString *desc;
@property(nonatomic, strong)NSString *type;
@property(nonatomic, strong)NSString *paymentType;
@property(nonatomic, strong)NSNumber *orderAmount;
@property(nonatomic, strong)NSNumber *totalFee;
@property(nonatomic, strong)NSMutableArray *cartList;
@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, strong)NSNumber *integralMoney;
@property(nonatomic, strong)NSNumber *bonus;
@property(nonatomic, strong)NSNumber *shippingFee;

@property (nonatomic, strong) NSMutableArray *goods_list;


- (id)initWithDict:(NSDictionary *)dict;

@end