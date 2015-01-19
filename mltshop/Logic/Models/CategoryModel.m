//
//  CategoryModel.m
//  mltshop
//
//  Created by mactive.meng on 5/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _catId = [dict objectForKey:@"catId"];
        _catName = [dict objectForKey:@"catName"];
        _subBrands = [[NSMutableArray alloc]init];
        if ([[dict objectForKey:@"subBrands"] isKindOfClass:[NSArray class]]) {
            BrandModel *allBrand = [[BrandModel alloc]init];
            allBrand.brandId = @"";
            allBrand.brandName = @"全部";
            [_subBrands addObject:allBrand];
            for (NSDictionary *item in [dict objectForKey:@"subBrands"]) {
                [_subBrands addObject:[[BrandModel alloc]initWithDict:item]];
            }
        }
        _isPicked = NO;
        _indexPath = [[NSIndexPath alloc]init];
    }
    
    return self;
}

@end


@implementation BrandModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _brandId = [DataTrans noNullStringObj:dict[@"brand_id"]];
        _brandName = [DataTrans noNullStringObj:dict[@"brand_name"]];
        _brandDesc = [DataTrans noNullStringObj:dict[@"brand_desc"]];
        _brandLogo = [NSString stringWithFormat:@"%@/%@",BASE_API,[dict objectForKey:@"url"]];
    }
    
    return self;
}

@end