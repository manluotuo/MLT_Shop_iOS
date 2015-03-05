//
//  GoodsModel.m
//  mltshop
//
//  Created by mactive.meng on 8/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "GoodsModel.h"
#import "SpecModel.h"

@implementation GoodsModel


- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _goodsId = [dict objectForKey:@"goods_id"];
        _brandId = [dict objectForKey:@"brand_id"];
        _brandName = [dict objectForKey:@"brand_name"];
        _catId = [dict objectForKey:@"cat_id"];
        _goodsName = [dict objectForKey:@"goods_name"];
        _goodsSN = [dict objectForKey:@"goods_sn"];
        _goodsBrief = [dict objectForKey:@"goods_brief"];
        _goodsDesc = [dict objectForKey:@"goods_desc"];
        _goodsInvertory = [DataTrans noNullNumberObj:dict[@"goods_number"]];
        _marketPrice = [DataTrans noNullNumberObj:[dict objectForKey:@"market_price"]];
        if ([dict objectForKey:@"shop_price"] != nil) {
            _shopPrice = [DataTrans noNullNumberObj:[dict objectForKey:@"shop_price"]];
        }else{
            _shopPrice = [DataTrans noNullNumberObj:[dict objectForKey:@"goods_price"]];
        }
        _promotePrice = [DataTrans noNullNumberObj:[dict objectForKey:@"promote_price"]];
        _promoteStartDate = [DataTrans dateFromNSDatetimeStr:[dict objectForKey:@"promote_start_date"]];
        
        _cover = [[PhotoModel alloc]initWithDict:[dict objectForKey:@"img"]];
        
        _gallery = [[NSMutableArray alloc]init];
        if ([[dict objectForKey:@"pictures"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *pic in [dict objectForKey:@"pictures"]) {
                [_gallery addObject:[[PhotoModel alloc]initWithDict:pic]];
            }
        }
        
        NSDictionary *firstSpec = [(NSArray *)dict[@"specification"] firstObject];
        _spec = [[SpecModel alloc]initWithDict:firstSpec];
        
        _isPicked = NO;
        _indexPath = [[NSIndexPath alloc]init];
    }
    
    return self;

}


@end
