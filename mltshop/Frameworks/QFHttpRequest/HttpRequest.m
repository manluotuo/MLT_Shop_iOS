//
//  HttpRequest.m
//  LimitFreeApp
//
//  Created by  mac on 14-8-27.
//  Copyright (c) 2014年  mac. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpRequestManager.h"

@implementation HttpRequest{
    NSURLConnection *_urlConnection;
}

- (id)init{
    self = [super init];
    if (self) {
        _respondsData =[[NSMutableData alloc] init];
    }
    return self;
}
//请求数据
- (void)startRequest{
    if (![_requestString hasPrefix:@"/"]) {
        //是网络的URL，发起HTTP请求
        NSURL *url = [NSURL URLWithString:_requestString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        _urlConnection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else {
        //是本地文件,直接读文件
        NSData *data = [NSData dataWithContentsOfFile:_requestString];
        [_respondsData appendData:data];
        NSLog(@"data = %s", _respondsData.bytes);
        
        if ([_delegate respondsToSelector:@selector(httpRequestFinished:)]) {
            [_delegate httpRequestFinished:self];
        }
    }
}

+ (HttpRequest *)requestWithString:(NSString *)requestString andTarget:(id<HttpRequestDelegate>)delegate{
    return [HttpRequest requestWithString:requestString andTarget:delegate andRequestType:nil];
}

+ (HttpRequest *)requestWithString:(NSString *)requestString andTarget:(id<HttpRequestDelegate>)delegate andRequestType:(NSString *)requestType{
    HttpRequest *request = [[HttpRequest alloc] init];
    request.requestString = requestString;
    request.delegate = delegate;
    request.requestType = requestType;

    //请求数据
    [request startRequest];
    //request对象，要放入manager中来维护
    [[HttpRequestManager shareManager] addRequestObj:request forkey:requestString];
    return [request autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_respondsData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_respondsData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if ([_delegate respondsToSelector:@selector(httpRequestFinished:)]) {
        [_delegate httpRequestFinished:self];
    }
    [[HttpRequestManager shareManager] removeRequestForKey:_requestString];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if ([_delegate respondsToSelector:@selector(httpRequestFailed:)]) {
        [_delegate httpRequestFailed:self];
    }
    [[HttpRequestManager shareManager] removeRequestForKey:_requestString];
}

- (void)stopRequest{
    if (_urlConnection) {
        //取消请求
        [_urlConnection cancel];
        _urlConnection = nil;
        [[HttpRequestManager shareManager] removeRequestForKey:_requestString];
    }
}

- (void)dealloc{
    NSLog(@"http dealloc!");
    [_respondsData release];
    _respondsData = nil;
    [super dealloc];
}

@end
