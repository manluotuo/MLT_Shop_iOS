//
//  GoodsModel.h
//  mltshop
//
//  Created by mactive.meng on 8/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoModel.h"

@interface GoodsModel : NSObject

@property(nonatomic, strong)NSString *goodsId;
@property(nonatomic, strong)NSString *goodsName;
@property(nonatomic, strong)NSNumber *marketPrice;
@property(nonatomic, strong)NSNumber *shopPrice;
@property(nonatomic, strong)NSNumber *promotePrice;
@property(nonatomic, strong)PhotoModel *cover;
@property(nonatomic, strong)NSArray *gallery;


@property(nonatomic, assign)BOOL isPicked;
@property(nonatomic, strong)NSIndexPath *indexPath;

- (id)initWithDict:(NSDictionary *)dict;

@end
