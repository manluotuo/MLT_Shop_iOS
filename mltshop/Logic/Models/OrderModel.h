//
//  OrderModel.h
//  mltshop
//
//  Created by mactive.meng on 3/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


@property(nonatomic, strong)NSString *orderSn;
@property(nonatomic, strong)NSString *orderId;
@property(nonatomic, strong)NSString *payCode;
@property(nonatomic, strong)NSString *subject;
@property(nonatomic, strong)NSString *desc;
@property(nonatomic, strong)NSNumber *orderAmount;

- (id)initWithDict:(NSDictionary *)dict;

@end
