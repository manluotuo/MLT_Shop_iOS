//
//  PassValueDelegate.h
//  tyresize
//
//  Created by mac on 13-3-24.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PassValueDelegate <NSObject>

@optional
-(void)passStringValue:(NSString *)value andIndex:(NSUInteger )index;
-(void)passSignalValue:(NSString *)value andString:(NSString* )string;
-(void)passSignalValue:(NSString *)value andDict:(NSDictionary *)dict;
-(void)passSignalValue:(NSString *)value andData:(id)data;
-(void)passSignalValue:(NSString *)value andDict:(NSDictionary *)dict andBlock:(void (^)(BOOL status))block;
- (void)selectedTabBarViewController:(NSInteger)index;

@end
