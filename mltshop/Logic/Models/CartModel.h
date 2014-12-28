//
//  CartModel.h
//  mltshop
//
//  Created by mactive.meng on 28/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"

typedef NS_ENUM(NSUInteger,CartOps)
{
    CartOpsList      = 0,
    CartOpsCreate    = 1,
    CartOpsUpdate    = 2,
    CartOpsDelete    = 3
};

// 购物车单独项目列表
@interface CartModel : GoodsModel

@property(nonatomic, strong)NSString *recId;
@property(nonatomic, strong)NSString *parentId;
@property(nonatomic, strong)NSString *goodsAttrId;
@property(nonatomic, strong)NSNumber *subtotal;
@property(nonatomic, strong)NSNumber *goodsCount;
@property(nonatomic, strong)NSString *goodsAttr;

@property(nonatomic, strong)NSString *extensionCode;
@property(nonatomic, strong)NSNumber *isReal;
@property(nonatomic, strong)NSNumber *isGift;
@property(nonatomic, strong)NSNumber *isShipping;
@property(nonatomic, strong)NSNumber *canHandsel;
@property(nonatomic, strong)NSNumber *goodsIsPosted;

//goods initWithdict
//goods.infos all
//
//- (id)initWithDict:(NSDictionary *)dict;

@end
