//
//  HttpRequestManager.m
//  LimitFreeApp
//
//  Created by  mac on 14-8-27.
//  Copyright (c) 2014年  mac. All rights reserved.
//

#import "HttpRequestManager.h"
#import "HttpRequest.h"

@implementation HttpRequestManager{
    //用来维护多个request对象，因为一个request对象对应一个唯一的请求地址,所以可以用请求地址作为key值
    NSMutableDictionary *_requestDic;
}
- (id)init{
    self = [super init];
    if (self) {
        _requestDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
static HttpRequestManager *manager = nil;
+ (HttpRequestManager *)shareManager{
    if (manager == nil) {
        manager = [[HttpRequestManager alloc] init];
    }
    return manager;
}
//添加request对象
- (void)addRequestObj:(id)obj forkey:(NSString *)key{
    [_requestDic setObject:obj forKey:key];
}
//移除request对象
- (void)removeRequestForKey:(NSString *)key{
    [_requestDic removeObjectForKey:key];
}

- (void)stopRequestWithKey:(NSString *)key{
    HttpRequest *request = [_requestDic objectForKey:key];
    if (request) {
        [request stopRequest];//取消请求
        //将delegate 设置为nil
        request.delegate = nil;
        //从任务中移除
        [self removeRequestForKey:key];
    }
}

@end
