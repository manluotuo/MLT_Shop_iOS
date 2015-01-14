//
//  SearchModel.h
//  mltshop
//
//  Created by mactive.meng on 12/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property(nonatomic, strong)NSString *catId;
@property(nonatomic, strong)NSString *brandId;
@property(nonatomic, strong)NSString *keywords;
@property(nonatomic, strong)NSString *intro;

- (id)initWithDict:(NSDictionary *)dict;

@end
