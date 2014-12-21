//
//  AddressModel.h
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,AddressOps)
{
    AddressOpsGet       = 0,
    AddressOpsCreate    = 1,
    AddressOpsUpdate    = 2,
    AddressOpsDelete    = 3,
    AddressOpsDefault   = 4
};

@interface AddressModel : NSObject

@property(nonatomic, strong)NSString *addressId;
@property(nonatomic, strong)NSString *consignee;
@property(nonatomic, strong)NSString* address;
@property(nonatomic, strong)NSString* email;
@property(nonatomic, strong)NSString* zipcode;
@property(nonatomic, strong)NSString* tel;

@property(nonatomic, strong)NSNumber* countryCode;
@property(nonatomic, strong)NSNumber* provinceCode;
@property(nonatomic, strong)NSNumber* cityCode;
@property(nonatomic, strong)NSNumber* districtCode;

@property(nonatomic, strong)NSString *countryName;
@property(nonatomic, strong)NSString *provinceName;
@property(nonatomic, strong)NSString *cityName;
@property(nonatomic, strong)NSString *districtName;

@property(nonatomic, strong)NSNumber *defaultAddress;
@property(nonatomic, strong)NSDictionary *postDict;

@property(nonatomic, strong)NSIndexPath *indexPath;

- (id)initWithDict:(NSDictionary *)dict;


@end
