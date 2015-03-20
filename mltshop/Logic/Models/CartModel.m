//
//  CartModel.m
//  mltshop
//
//  Created by mactive.meng on 28/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel


- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        self = [super initWithDict:dict];
        
        _recId          = dict[@"rec_id"];
        _parentId       = dict[@"parent_id"];
        _goodsAttrId    = dict[@"goods_attr_id"];
        _goods_id       = dict[@"goods_id"];
        _subtotal       = [DataTrans noNullNumberObj:[dict objectForKey:@"subtotal"]];
        _extensionCode  = dict[@"extension_code"];
        if (ArrayHasValue(dict[@"goods_attr"])) {
            _goodsAttr  = dict[@"goods_attr"][0][@"value"];
        }
        
        _goodsCount    = [DataTrans noNullNumberObj:[dict objectForKey:@"goods_number"]];
        _isReal         = [DataTrans noNullNumberObj:[dict objectForKey:@"is_real"]];
        _isGift         = [DataTrans noNullNumberObj:[dict objectForKey:@"is_gift"]];
        _isShipping     = [DataTrans noNullNumberObj:[dict objectForKey:@"is_shipping"]];
        _canHandsel     = [DataTrans noNullNumberObj:[dict objectForKey:@"can_handsel"]];
        _goodsIsPosted  = [DataTrans noNullNumberObj:[dict objectForKey:@"goods_is_posted"]];

    }
    
    return self;
}

@end
