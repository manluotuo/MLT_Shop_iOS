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
        _orderId = [DataTrans noNullStringObj:dict[@"order_id"]];
        _orderSn = [DataTrans noNullStringObj:dict[@"order_sn"]];
        _orderAmount = [DataTrans noNullNumberObj:dict[@"order_amount"]] ;
        _payCode = [DataTrans noNullStringObj:dict[@"pay_code"]];
        _subject = [DataTrans noNullStringObj:dict[@"order_info"][@"subject"]];
        _desc = [DataTrans noNullStringObj:dict[@"order_info"][@"desc"]];
    }
    
    return self;
}

@end
