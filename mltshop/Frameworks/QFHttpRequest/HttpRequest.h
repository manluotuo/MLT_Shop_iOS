//
//  HttpRequest.h
//  LimitFreeApp
//
//  Created by  mac on 14-8-27.
//  Copyright (c) 2014年  mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HttpRequest;
@protocol HttpRequestDelegate <NSObject>
//数据请求成功
- (void)httpRequestFinished:(HttpRequest *)request;
//数据请求失败
- (void)httpRequestFailed:(HttpRequest *)request;
@end

//封装客户端与服务端的请求
@interface HttpRequest : NSObject<NSURLConnectionDataDelegate>
//收集下载数据
@property (nonatomic,readonly) NSMutableData *respondsData;
//请求地址
@property (nonatomic,copy) NSString *requestString;

@property (nonatomic,assign) id <HttpRequestDelegate>delegate;
//请求对象的类型
@property (nonatomic,copy) NSString *requestType;
//因为不需要外界来维护request对象，也考虑到外部调用起来更加方便.暴露类方法
//根据请求地址请求数据，并设置代理

+ (HttpRequest *)requestWithString:(NSString *)requestString andTarget:(id<HttpRequestDelegate>)delegate;
//对原有方法进行扩展，添加一个新的参数requestType 用于标识request对象的类型
+ (HttpRequest *)requestWithString:(NSString *)requestString andTarget:(id<HttpRequestDelegate>)delegate andRequestType:(NSString *)requestType;
/*适配器的设计模式:主要解决软件快速迭代开发的版本兼容问题
 *1、为了保证原有的功能能够正常工作，原有方法保留。
 *2、为了能够满足新的需求，需要对原有的方法进行扩展
 *3、为了避免代码冗余，旧方法中直接调用新的方法，扩展的参数传空
 *目的: 为了保证旧类(调用旧方法实现的类)和新类(调用新方法实现的类)能同时正常工作
 */

- (void)stopRequest;


@end
