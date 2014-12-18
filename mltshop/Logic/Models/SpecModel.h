//
//  SpecModel.h
//  mltshop
//
//  Created by mactive.meng on 18/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecModel : NSObject

@property(nonatomic, strong)NSString *attr;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSMutableArray *values;
- (id)initWithDict:(NSDictionary *)dict;

@end


@interface SpecItemModel : NSObject

@property(nonatomic, strong)NSString *label;
@property(nonatomic, strong)NSNumber *price;
@property(nonatomic, strong)NSString *thumb;
@property(nonatomic, strong)NSString *itemId;
- (id)initItemWithDict:(NSDictionary *)dict;

@end

