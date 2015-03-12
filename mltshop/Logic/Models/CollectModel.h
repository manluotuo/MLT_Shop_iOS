//
//  CollectModel.h
//  mltshop
//
//  Created by 小新 on 15/3/11.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

@property(nonatomic, strong) NSString *goods_id;
@property(nonatomic, strong) NSString *goods_name;
@property(nonatomic, strong) NSString *goods_brief;
@property(nonatomic, strong) NSString *shop_price; // 现价
@property(nonatomic, strong) NSString *market_price; // 原价
@property(nonatomic, strong) NSString *original;
@property(nonatomic, strong) NSString *goods;
@property(nonatomic, strong) NSString *rec_id;
@property(nonatomic, strong) NSDictionary *img;

@end
