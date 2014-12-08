//
//  PhotoModel.h
//  mltshop
//
//  Created by mactive.meng on 8/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property(nonatomic, strong)NSString *thumb;
@property(nonatomic, strong)NSString *goods;
@property(nonatomic, strong)NSString *original;

- (id)initWithDict:(NSDictionary *)dict;

@end
