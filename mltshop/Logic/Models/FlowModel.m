//
//  FlowModel.m
//  mltshop
//
//  Created by mactive.meng on 30/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "FlowModel.h"

@implementation FlowModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        
        _goodsList = [[NSMutableArray alloc]init];
        if (ArrayHasValue( dict[@"goods_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"goods_list"]) {
                [_goodsList addObject:[[CartModel alloc]initWithDict:item]];
            }
        }
        
        _consignee      = [[AddressModel alloc]initWithDict:dict[@"consignee"]];
        
        if (ArrayHasValue( dict[@"payment_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"payment_list"]) {
                [_paymentList addObject:[[PayModel alloc]initWithDict:item]];
            }
        }
        
        if (ArrayHasValue( dict[@"shipping_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"shipping_list"]) {
                [_shippingList addObject:[[PayModel alloc]initWithDict:item]];
            }
        }
        
        if (ArrayHasValue( dict[@"bonus_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"bonus_list"]) {
                [_bonusList addObject:[[PayModel alloc]initWithDict:item]];
            }
        }
        
        _yourIntegral   = dict[@"your_integral"];
        _orderMaxIntegral = dict[@"order_max_integral"];
        
    }
    
    return self;
}


@end


@implementation ShippingModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _shippingId     = dict[@"shipping_id"];
        _shippingCode   = dict[@"shipping_code"];
        _shippingName   = dict[@"shipping_name"];
        _shippingFee    = [DataTrans noNullNumberObj:dict[@"shipping_fee"]];
        _freeMoney      = [DataTrans noNullNumberObj:dict[@"free_money"]];
        _insure         = [DataTrans noNullBoolObj:dict[@"insure"]];        
    }
    
    return self;
}

@end


@implementation PayModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _payId = dict[@"pay_id"];
        _payCode = dict[@"pay_code"];
        _payName = dict[@"pay_name"];
        _payFee  = [DataTrans noNullBoolObj:dict[@"pay_fee"]];
    }
    
    return self;
}
@end

@implementation BonusModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _bonusId = dict[@"pay_id"];
        _bonusName = dict[@"pay_code"];
        _bonusCode = dict[@"pay_name"];
        _bonusSN  = [DataTrans noNullBoolObj:dict[@"pay_fee"]];
    }
    
    return self;
}

@end
