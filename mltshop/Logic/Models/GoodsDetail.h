//
//  GoodsDetail.h
//  mltshop
//
//  Created by 小新 on 15/4/4.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetail : NSObject

/** 商品id */
@property (nonatomic, strong) NSString *goods_id;
/** 商品名 */
@property (nonatomic, strong) NSString *name;
/** 缩略图 */
@property (nonatomic, strong) NSString *small;

@end
