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
        _subBrands = dict[@"subBrands"];
        _isPicked = NO;
        _indexPath = [[NSIndexPath alloc]init];
    }
    
    return self;
}

@end
