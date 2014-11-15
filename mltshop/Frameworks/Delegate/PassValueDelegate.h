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
-(void)passNumberValue:(NSNumber *)value andIndex:(NSUInteger )index;
-(void)passNSDateValue:(NSDate *)value andIndex:(NSUInteger)index;
-(void)passNSArrayValue:(NSArray *)value andSignal:(NSString *)signal;

-(void)addAvatar;

-(void)sendSMSWithIndex:(NSInteger)index;
-(void)callWithIndex:(NSInteger)index;

@end
