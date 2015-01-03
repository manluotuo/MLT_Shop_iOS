//
//  OrderModel.m
//  mltshop
//
//  Created by mactive.meng on 3/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _orderId = dict[@"order_id"];
        _orderSn = dict[@"order_sn"];
        _orderAmount = dict[@"order_amount"];
        _payCode = dict[@"pay_code"];
        _subject = dict[@"subject"];
        _desc = dict[@"desc"];
    }
    
    return self;
}

@end
