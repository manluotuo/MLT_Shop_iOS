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
        _type = [DataTrans noNullStringObj:dict[@"type"]];
        _paymentType = [DataTrans noNullStringObj:dict[@"payment_type"]];
        _orderTime = [DataTrans dateFromNSDatetimeStr:dict[@"order_time"]];
        NSLog(@"_orderTime %@",_orderTime);
        _totalFee = [DataTrans noNullNumberObj:dict[@"total_fee"]];
        
        if (DictionaryHasValue(dict[@"order_info"])) {
            _orderAmount = [DataTrans noNullNumberObj:dict[@"order_info"][@"order_amount"]] ;
            _payCode = [DataTrans noNullStringObj:dict[@"order_info"][@"pay_code"]];
            _subject = [DataTrans noNullStringObj:dict[@"order_info"][@"subject"]];
            _desc = [DataTrans noNullStringObj:dict[@"order_info"][@"desc"]];
        }
        
        _integralMoney = [DataTrans noNullNumberObj:dict[@"formated_integral_money"]];
        _bonus = [DataTrans noNullNumberObj:dict[@"formated_bonus"]];
        _shippingFee = [DataTrans noNullNumberObj:dict[@"formated_shipping_fee"]];
        
        _cartList = [[NSMutableArray alloc]init];
        if (ArrayHasValue( dict[@"goods_list"])) {
            for (NSDictionary *item in dict[@"goods_list"]) {
                [_cartList addObject:[[CartModel alloc]initWithDict:item]];
            }
        }

    }
    
    return self;
}

@end
