//
//  SpecModel.m
//  mltshop
//
//  Created by mactive.meng on 18/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "SpecModel.h"

@implementation SpecModel


- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _attr = dict[@"attr_type"];
        _name = dict[@"name"];
        _values = [[NSMutableArray alloc]init];
        for (NSDictionary *item in dict[@"value"]) {
            [_values addObject:[[SpecItemModel alloc] initItemWithDict:item]];
        }
        
    }
    
    return self;
    
}


@end

@implementation SpecItemModel
- (id)initItemWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _label = dict[@"label"];
        _price = [DataTrans noNullNumberObj:dict[@"pirce"]];
        _thumb = dict[@"thumb_url"];
        _itemId = dict[@"id"];
    }
    return self;
}


@end


