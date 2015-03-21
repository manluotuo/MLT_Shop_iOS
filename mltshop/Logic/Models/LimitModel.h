//
//  LimitModel.h
//  mltshop
//
//  Created by 小新 on 15/3/21.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LimitModel : NSObject

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *goods_brief;
@property (nonatomic, strong) NSString *market_price;
@property (nonatomic, strong) NSString *promote_price;
@property (nonatomic, strong) NSString *promote_start_date;
@property (nonatomic, strong) NSString *promote_end_date;
@property (nonatomic, strong) NSDictionary *img;

@end
