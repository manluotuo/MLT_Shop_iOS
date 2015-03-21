//
//  HttpRequestManager.h
//  LimitFreeApp
//
//  Created by  mac on 14-8-27.
//  Copyright (c) 2014年  mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//用于管理和维护多个request对象的生命周期,是一个单例，保证manager不会被提前销毁
@interface HttpRequestManager : NSObject

+ (HttpRequestManager *)shareManager;

//添加request对象
- (void)addRequestObj:(id)obj forkey:(NSString *)key;
//移除request对象
- (void)removeRequestForKey:(NSString *)key;

//根据key值来取消request的请求
- (void)stopRequestWithKey:(NSString *)key;

@end
