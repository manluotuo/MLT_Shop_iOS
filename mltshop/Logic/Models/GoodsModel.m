//
//  GoodsModel.m
//  mltshop
//
//  Created by mactive.meng on 8/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "GoodsModel.h"
@implementation GoodsModel


- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _goodsId = [dict objectForKey:@"goods_id"];
        _goodsName = [dict objectForKey:@"goods_name"];
        _marketPrice = [DataTrans noNullNumberObj:[dict objectForKey:@"market_price"]];
        _shopPrice = [DataTrans noNullNumberObj:[dict objectForKey:@"shop_price"]];
        _promotePrice = [DataTrans noNullNumberObj:[dict objectForKey:@"market_price"]];
        
        _cover = [[PhotoModel alloc]initWithDict:[dict objectForKey:@"img"]];
        
        _gallery = [[NSArray alloc]init];
        
        
        _isPicked = NO;
        _indexPath = [[NSIndexPath alloc]init];
    }
    
    return self;

}


@end
