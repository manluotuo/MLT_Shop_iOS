//
//  CategoryModel.h
//  mltshop
//
//  Created by mactive.meng on 5/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property(nonatomic, strong)NSString *catId;
@property(nonatomic, strong)NSString *catName;
@property(nonatomic, assign)BOOL isPicked;
@property(nonatomic, strong)NSMutableArray *subBrands;
@property(nonatomic, strong)NSIndexPath *indexPath;

- (id)initWithDict:(NSDictionary *)dict;

@end

@interface BrandModel : NSObject
@property(nonatomic, strong)NSString *brandId;
@property(nonatomic, strong)NSString *brandName;
@property(nonatomic, strong)NSString *brandLogo;

- (id)initWithDict:(NSDictionary *)dict;

@end
