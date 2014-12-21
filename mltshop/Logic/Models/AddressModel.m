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
        
        _countryCode    = INT(1);
        _provinceCode   = dict[@"province"];
        _cityCode       = dict[@"city"];
        _districtCode   = dict[@"district"];
        
        _countryName = T(@"中国");
        _provinceName = dict[@"province_name"];
        _cityName = dict[@"city_name"];
        _districtName = dict[@"district_name"];

        _defaultAddress = dict[@"default_address"];
        
        _indexPath = [[NSIndexPath alloc]init];
    }
    
    return self;
}

- (NSDictionary *)postDict
{
    return @{@"id": [DataTrans noNullStringObj:_addressId],
             @"name": [DataTrans noNullStringObj:_consignee],
             @"email": [DataTrans noNullStringObj:_email],
             @"zipcode": [DataTrans noNullStringObj:_zipcode],
             @"tel": [DataTrans noNullStringObj:_tel],
             @"address":[DataTrans noNullStringObj:_address],
             @"country": @"1",
             @"privince": [DataTrans noNullStringObj:STR_INT([_provinceCode integerValue])],
             @"city": [DataTrans noNullStringObj:STR_INT([_cityCode integerValue])],
             @"district": [DataTrans noNullStringObj:STR_INT([_districtCode integerValue])]
            };
}


@end
