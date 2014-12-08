//
//  PhotoModel.m
//  mltshop
//
//  Created by mactive.meng on 8/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _goods = [DataTrans noNullStringObj:[dict objectForKey:@"goods"]];
        _thumb = [DataTrans noNullStringObj:[dict objectForKey:@"thumb"] ];
        _original = [DataTrans noNullStringObj:[dict objectForKey:@"original"] ];
    }
    return self;
    
}


@end
