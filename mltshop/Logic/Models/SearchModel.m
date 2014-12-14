//
//  SearchModel.m
//  mltshop
//
//  Created by mactive.meng on 12/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _catId = [dict objectForKey:@"catId"];
        _brandId = [dict objectForKey:@"brandId"];
        _keywords = [dict objectForKey:@"keywords"];
    }

    return self;
}

@end
