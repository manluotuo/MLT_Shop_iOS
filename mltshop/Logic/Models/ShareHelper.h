//
//  ShareHelper.h
//  bitmedia
//
//  Created by meng qian on 14-3-7.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "PassValueDelegate.h"

@interface ShareHelper : NSObject

@property(nonatomic, assign)NSObject<PassValueDelegate> *shareDelegateForAppDelegate;

@property(nonatomic, strong)UIViewController *baseViewController;

+ (ShareHelper *)sharedHelper;

// wechat
- (void)shareByWechatWithContent:(NSString *)content
                           scene:(enum WXScene)scene;

- (void)shareByWechatWithTitle:(NSString *)title
                   description:(NSString *)description
                     thumbnail:(UIImage *)thumbnail
                     urlString:(NSString *)urlString
                         scene:(enum WXScene)scene;

// qq
- (void)shareByQQWithTitle:(NSString *)title
                  description:(NSString *)description
                    thumbnail:(UIImage *)thumbnail
                    urlString:(NSString *)urlString
                        scene:(QQShareType)scene;
// weibo
- (void)shareByWeiboWithContent:(NSString *)content
                      thumbnail:(UIImage *)thumbnail;
// email
- (void)shareByEmailWithTitle:(NSString *)title
                      content:(NSString *)Content;
// link
- (void)shareByLinkWithContent:(NSString *)content;

// make content
- (NSString *)makeShareContentWithTitle:(NSString *)title
                            description:(NSString *)description
                              urlString:(NSString *)urlString;

- (void)showShareView:(GoodsModel *)_goods;

// share url
- (void)showShareViewWithTitle:(NSString *)title
                   description:(NSString *)description
                     thumbnail:(UIImage *)thumbnail
                     urlString:(NSString *)urlString
                      andIndex:(NSInteger)index;

@end
