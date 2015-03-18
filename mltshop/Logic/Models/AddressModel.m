//
//  AddressModel.m
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "AddressModel.h"



@implementation AddressModel

@synthesize postDict;

- (id)initWithDict:(NSDictionary *)dict
{
    if (DictionaryHasValue(dict)) {
        _addressId  = [dict objectForKey:@"id"];
        _consignee  = [dict objectForKey:@"consignee"];
        _address    = dict[@"address"];
        _email      = dict[@"email"];
        _tel      = dict[@"tel"];
        _zipcode      = dict[@"zipcode"];
        
        _provinceCode   = dict[@"province"];
        _cityCode       = dict[@"city"];
        _districtCode   = dict[@"district"];
        
        _provinceName = dict[@"province_name"];
        _cityName = dict[@"city_name"];
        _districtName = dict[@"district_name"];

        _defaultAddress = dict[@"default_address"];
        
        _indexPath = [[NSIndexPath alloc]init];
        NSLog(@"%@", _consignee);
    }
    
    // 默认中国
    _countryCode    = @"1";
    _countryName    = @"中国";

    
    return self;
}

- (NSDictionary *)postDict
{
    return @{@"id": [DataTrans noNullStringObj:_addressId],
             @"consignee": [DataTrans noNullStringObj:_consignee],
             @"email": [DataTrans noNullStringObj:_email],
             @"zipcode": [DataTrans noNullStringObj:_zipcode],
             @"tel": [DataTrans noNullStringObj:_tel],
             @"mobile": [DataTrans noNullStringObj:_tel],
             @"address":[DataTrans noNullStringObj:_address],
             @"country": @"1",
             @"province": [DataTrans noNullStringObj:_provinceCode],
             @"city": [DataTrans noNullStringObj:_cityCode],
             @"district": [DataTrans noNullStringObj:_districtCode]
            };
}


@end
