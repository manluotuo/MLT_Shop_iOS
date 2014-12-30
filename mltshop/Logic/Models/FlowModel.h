//
//  FlowModel.h
//  mltshop
//
//  Created by mactive.meng on 30/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowModel : NSObject

//@property(nonatomic, strong)NSString *payId;
//@property(nonatomic, strong)NSString *shippingId;
//@property(nonatomic, strong)NSString *bonus;
//@property(nonatomic, strong)NSString *integral;

@property(nonatomic, strong)NSMutableArray *paymentList;
@property(nonatomic, strong)NSMutableArray *goodsList;
@property(nonatomic, strong)AddressModel *consignee;
@property(nonatomic, strong)NSMutableArray *shippingList;
@property(nonatomic, strong)NSMutableArray *bonusList;

@property(nonatomic, strong)NSNumber *yourIntegral;
@property(nonatomic, strong)NSNumber *orderMaxIntegral;



- (id)initWithDict:(NSDictionary *)dict;

@end


/**
 *  ShippingModel 运费模板
 */

@interface ShippingModel : NSObject

@property(nonatomic, strong)NSString *shippingId;
@property(nonatomic, strong)NSString *shippingCode;
@property(nonatomic, strong)NSString *shippingName;
@property(nonatomic, strong)NSNumber *shippingFee;
@property(nonatomic, strong)NSNumber *freeMoney;
@property(nonatomic, strong)NSNumber *insure;

- (id)initWithDict:(NSDictionary *)dict;

@end

/**
 *  payModel 支付模板
 */
@interface PayModel : NSObject

@property(nonatomic, strong)NSString *payId;
@property(nonatomic, strong)NSString *payCode;
@property(nonatomic, strong)NSString *payName;
@property(nonatomic, strong)NSNumber *payFee;

- (id)initWithDict:(NSDictionary *)dict;

@end

/**
 *  bonusModel 支付模板
 */
@interface BonusModel : NSObject

@property(nonatomic, strong)NSString *bonusId;
@property(nonatomic, strong)NSString *bonusCode;
@property(nonatomic, strong)NSString *bonusName;
@property(nonatomic, strong)NSNumber *bonusSN;

- (id)initWithDict:(NSDictionary *)dict;

@end
