//
//  FlowModel.m
//  mltshop
//
//  Created by mactive.meng on 30/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "FlowModel.h"

@implementation FlowDoneModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        
    }
    return self;
}
@end

@implementation FlowModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        
        _goodsList = [[NSMutableArray alloc]init];
        _paymentList = [[NSMutableArray alloc]init];
        _shippingList = [[NSMutableArray alloc]init];
        _bonusList = [[NSMutableArray alloc]init];
        
        if (ArrayHasValue( dict[@"goods_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"goods_list"]) {
                [_goodsList addObject:[[CartModel alloc]initWithDict:item]];
            }
        }
        
        _consignee = [[AddressModel alloc]initWithDict:dict[@"consignee"]];
        
        if (ArrayHasValue( dict[@"payment_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"payment_list"]) {
                
                /** 敏 - 微信支付，在这加判断 */
//                if ([item[@"pay_code"] isEqualToString:@"alipay"] || [item[@"pay_code"] isEqualToString:@"chinabank"])
                 if ([item[@"pay_code"] isEqualToString:@"alipay"]) {
                    NSLog(@"!!!!!!!!!!!!!!%@", item);
                    [_paymentList addObject:[[PayModel alloc]initWithDict:item]];
                }
            }
        }
        
        if (ArrayHasValue( dict[@"shipping_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"shipping_list"]) {
                [_shippingList addObject:[[ShippingModel alloc]initWithDict:item]];
            }
        }
        
        if (ArrayHasValue( dict[@"bonus_list"])) {
            for (NSDictionary *item in [dict objectForKey:@"bonus_list"]) {
                [_bonusList addObject:[[BonusModel alloc]initWithDict:item]];
            }
        }
        
        _yourIntegral   = [DataTrans noNullNumberObj:dict[@"your_integral"]];
        _orderMaxIntegral = dict[@"order_max_integral"];
        _payAmount = INT(0);
        
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
        _selected = NO;
    }
    
    return self;
}

@end


@implementation PayModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _payId = dict[@"pay_id"];
        NSLog(@"%@", _payId);
        _payCode = dict[@"pay_code"];
        _payName = dict[@"pay_name"];
        _payFee  = [DataTrans noNullBoolObj:dict[@"pay_fee"]];
        _selected = NO;
    }
    
    return self;
}
@end

@implementation BonusModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _bonusId = dict[@"bonus_id"];
        _bonusName = dict[@"type_name"];
        _bonusMoney = [DataTrans noNullNumberObj:dict[@"type_money"]];
        _selected = NO;
    }
    
    return self;
}

@end
