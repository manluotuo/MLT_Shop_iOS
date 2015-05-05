//
//  AppRequestManager.m
//  bitmedia
//
//  Created by meng qian on 13-12-25.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import "AppRequestManager.h"
#import "AppDelegate.h"
#import "Me.h"
#import "AFURLSessionManager.h"
#import <AFNetworking/AFNetworking.h>


static NSString * const kAppNetworkAPIBaseURLString = BASE_API;
static AppRequestManager *_sharedManager = nil;
static dispatch_once_t onceToken;

@implementation AppRequestManager  {
}

// 单例 HttpManager
+ (AppRequestManager *)sharedManager {
    dispatch_once(&onceToken, ^{
        if (_sharedManager == nil) {
            NSLog(@"kAppNetworkAPIBaseURLString %@",kAppNetworkAPIBaseURLString);
            _sharedManager = [[AppRequestManager alloc] initWithBaseURL:[NSURL URLWithString:kAppNetworkAPIBaseURLString]];
            _sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [_sharedManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
            
            // 设置网络超时时间
            _sharedManager.requestSerializer.timeoutInterval = 30;
            _sharedManager.securityPolicy.allowInvalidCertificates = YES;
            
            
            [[NSNotificationCenter defaultCenter] addObserver:_sharedManager selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
            
        }
    });
    
    [_sharedManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"ReachableViaWWAN");
                [DataTrans showWariningTitle:T(@"正通过3G访问!") andCheatsheet:nil andDuration:2.0];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"NotReachable");
                [DataTrans showWariningTitle:T(@"网络不给力!") andCheatsheet:nil andDuration:2.0];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            default:
                NSLog(@"ReachableViaWiFi");
                break;
        }
    }];
    
    return _sharedManager;
}

+ (void)updateSharedInstance{
    
    NSLog(@"ME %@",XAppDelegate.me);
    NSLog(@"%@",_sharedManager.requestSerializer.HTTPRequestHeaders);
    if (![_sharedManager.requestSerializer.HTTPRequestHeaders[@"X-AUTH-TOKEN"]
          isEqualToString:XAppDelegate.me.userToken] &&
        StringHasValue(XAppDelegate.me.userToken)) {
        [_sharedManager.requestSerializer setValue:XAppDelegate.me.userToken forHTTPHeaderField:@"X-AUTH-TOKEN"];
    }
}
+ (AppRequestManager *)nodejsManager {
    static AppRequestManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[AppRequestManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8899"]];
    });
    
    return _sharedManager;
}

-(void)networkRequestDidFinish: (NSNotification *) notification
{
    NSError *error = [notification.userInfo objectForKey:AFNetworkingTaskDidCompleteErrorKey];
    
    id responseObject = [notification.userInfo objectForKey:AFNetworkingTaskDidCompleteSerializedResponseKey];
    
    NSHTTPURLResponse *httpResponse = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    
    if ([responseObject isKindOfClass:[NSDictionary class]] && error != nil) {
        
        NSString *description =  error.userInfo[@"NSLocalizedDescription"];
        NSLog(@"error.code ====== %d",error.code);
        NSLog(@"description %@",description);
        NSLog(@"httpResponse %@",httpResponse);
        NSLog(@"===========");
        
        if (StringHasValue(responseObject[@"message"])) {
            [DataTrans showWariningTitle:responseObject[@"message"] andCheatsheet:nil andDuration:1.5f];
        }
    }
    
}

/**
 *  API/guest/register
 *  用户打开是只请求一次
 *  @param block return {token, uid}
 */
- (void)signInWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SIGNIN_PATH;
    
    NSDictionary *postDict = @{@"name" :username,
                               @"password": password};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                NSLog(@"%@",responseObject[@"data"]);
                block(responseObject[@"data"] , nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        NSLog(@"%@ %@",postURL, error);
        
        if (block) {
            block(nil , error);
        }
        
    }];
}



- (void)signUpWithMobile:(NSString *)mobile password:(NSString *)password email:(NSString *)email andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SIGNUP_PATH;
    
    NSDictionary *postDict = @{@"name" :mobile,
                               @"password": password,
                               @"email":email,
                               @"field":@"{SIGNUP_FIELD_VALUE}"};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            [DataTrans showWariningTitle:T(@"用户名或邮箱已使用") andCheatsheet:ICON_INFO andDuration:1.0f];
            block(nil , error);
        }
        
    }];
}



/**
 *  API/guest/register
 *  用户打开是只请求一次
 *  @param block return {token, uid}
 * {"filter":{"keywords":"","category_id":"4","price_range":"{PRICE_RANGE}","brand_id":"1","sort_by":"id_desc"},"pagination":{"page":"1","count":"100"}}
 */

- (void)setLimitDataBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SEARCH_PATH;
    NSDictionary *filter = @{@"filter": @{@"keywords":@"",
                                          @"price_range" :@"",
                                          @"category_id": @"",
                                          @"brand_id": @"",
                                          @"sort_by":@""},
                             @"pagination": @{@"page": @"1",
                                              @"count": @"100"
                                     },
                             @"intro": @"promotion"
                             };
    [[AppRequestManager sharedManager]POST:postURL parameters:filter success:^(NSURLSessionDataTask *task, id responseObject) {
       
        if([DataTrans isCorrectResponseObject:responseObject]) {
            
            if (block) {
                block(responseObject, nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
    
}

- (void)searchWithKeywords:(NSString *)keywords
                    cateId:(NSString *)cateId
                   brandId:(NSString *)brandId
                     intro:(NSString *)intro
                      page:(NSInteger)page
                      size:(NSInteger)size
                  andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SEARCH_PATH;
    
    NSDictionary *filter = @{@"keywords":[DataTrans noNullStringObj:keywords],
                             @"price_range" :@"{PRICE_RANGE}",
                             @"category_id": [DataTrans noNullStringObj:cateId],
                             @"brand_id": [DataTrans noNullStringObj:brandId],
                             @"sort_by":@"id_desc"};
    
    NSString *pageString = STR_INT(page);
    NSString *sizeString = @"20";
    NSString *introString = [DataTrans noNullStringObj:intro];
    
    if (size > 0) {
        sizeString = STR_INT(size);
    }
    
    NSDictionary *pagination = @{@"page":pageString,@"count":sizeString};
    
    NSDictionary *postDict = @{@"filter" : filter,
                               @"pagination": pagination,
                               @"intro": introString};
    
    postDict = [DataTrans makePostDict:postDict];
    
    NSLog(@"%@", postDict);
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        NSLog(@"%@ %@",postURL, error);
        
        if (block) {
            block(nil , error);
        }
        
    }];
}


- (void)getHomeDataWithBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_HOME_DATA_PATH;
    
    NSDictionary* postDict = nil;
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject[@"data"] , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

/** 收藏列表 */
- (void)getCollectListWithBlock:(void (^)(id responseObject, NSError *error))block {
    
    NSString *postURL = API_COLLECT_PATH;
    NSDictionary *postDict = @{@"session": @{@"uid": [DataTrans
                                                      noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                             },
                               @"pagination": @{@"page":@"1",
                                                @"count":@"1000"
                                                }};
    postDict = [DataTrans makePostDict:postDict];
    [[AppRequestManager sharedManager] POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([DataTrans isCorrectResponseObject:responseObject]) {
            if (block) {
                block(responseObject, nil);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

/** 订单详情 */
- (void)getOrderDetailOrderId:(NSString *)orderId andBlock:(void (^)(id responseObject, NSError *error))block {
    
    NSString *postUrl = API_ORDER_INFO;
    
    NSLog(@"%@", orderId);
    NSDictionary *postDict = @{@"order_id": orderId,
                               @"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                             }};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager] POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"!!!!!!!!!!!\n%@", responseObject);
        if ([DataTrans isCorrectResponseObject:responseObject]) {
            //            NSLog(@"################\n%@", responseObject);
            if (block) {
                block(responseObject, nil);
            }
            
        } else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (block) {
            block(nil , error);
        }
        
    }];
}

/** 获取评论 */
- (void)getCommentWithGoodsId:(NSString *)goodsId andBlock:(void (^)(id responseObject, NSError *error))block {
    
    NSString *postUrl = API_COMMENT_PATH;
    
    NSDictionary *postDict = @{@"goods_id": goodsId,
                               @"pagination": @{@"page": @"1",
                                                @"count": @"1000"
                                                }
                               };
    postDict = [DataTrans makePostDict:postDict];
    
//    NSLog(@"%@", goodsId);
    [[AppRequestManager sharedManager] POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([DataTrans isCorrectResponseObject:responseObject]) {
            
            if (block) {
                block(responseObject, nil);
            }
            
        } else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);        }
        //        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (block) {
            block(nil , error);
        }
        
    }];
}


/** 增加评论 */
- (void)getCommentAddWithDict:(NSDictionary *)dict andBlock:(void (^)(id responseObject, NSError *error))block {
    NSString *postUrl = API_COMMENT_ADD;
    
    NSDictionary *postDict = @{@"goods_id": dict[@"goods_id"],
                               @"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                             },
                               @"comment_rank": dict[@"comment_rank"],
                               @"content": dict[@"content"]
                               };

    [[AppRequestManager sharedManager] POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {

        if ([DataTrans isCorrectResponseObject:responseObject]) {
            
            if (block) {
                block([NSString stringWithFormat:@"YES"], nil);
            }
        }else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if (block) {
            block(nil , error);
        }
    }];
    
    
    
}

/** 收藏 */
- (void)getCollectAddWithGoodsId:(NSString *)goodsId andBlock:(void (^)(id responseObject, NSError *error))block {
    
    NSString *postURL = API_COLLECT_ADD;
    NSDictionary *postDict = @{@"goods_id" :goodsId,
                               @"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                             }};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (block) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (block) {
            block(nil , error);
        }
        
    }];
    
    
}

/** 红包 */
- (void)getBonusListWithBlock:(void (^)(id responseObject, NSError *error))block {
    
    NSString *postURL = API_BONUS_LIST;
    NSDictionary *postDict = @{@"session": @{@"uid": [DataTrans
                                                      noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                             }};
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                NSLog(@"%@", responseObject);
                block(responseObject, nil);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
    }];
    
}

/** 取消收藏 */
- (void)getDeleteCollectRecId:(NSString *)recId andBlcok:(void (^)(id responseObject, NSError *error))block {

    NSString *postURL = API_COLLECT_DELETE;
    NSDictionary *postDict = @{@"session": @{@"uid": [DataTrans
                                                      noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans
                                                      noNullStringObj:XAppDelegate.me.sessionId]},
                               @"rec_id": recId};
    [[AppRequestManager sharedManager] POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            NSLog(@"%@", responseObject);
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject, nil);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (void)getGoodsDetailWithGoodsId:(NSString *)goodsId andBlcok:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_GOODS_DETAILS_PATH;
    
    NSDictionary *postDict = @{@"goods_id" :goodsId,
                               @"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                             }};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:200
                                             userInfo:responseObject[@"status"]];
            block(nil,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
    }];
    
}


/**
 *  我的地址列表
 *
 *  @param block <#block description#>
 */
- (void)getAddressListWithBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_ADDRESS_LIST_PATH;
    
    NSDictionary *postDict = @{@"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                             @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                             }};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
    }];
}


- (void)operateAddressWithAddress:(AddressModel *)theAddress
                        operation:(NSUInteger)operation
                         andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = @"";
    NSMutableDictionary *baseDict = [[NSMutableDictionary alloc]initWithDictionary:
                                     @{@"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                                     @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                                     }}];
    
    
    switch (operation) {
        case AddressOpsGet:
            postURL = API_ADDRESS_GET_PATH;
            baseDict[@"address_id"] = theAddress.addressId;
            break;
        case AddressOpsCreate:
            postURL = API_ADDRESS_CREATE_PATH;
            NSLog(@"%@", theAddress.postDict);
            baseDict[@"address"] = theAddress.postDict;
            break;
        case AddressOpsUpdate:
            postURL = API_ADDRESS_UPDATE_PATH;
            baseDict[@"address_id"] = theAddress.addressId;
            baseDict[@"address"] = theAddress.postDict;
            break;
        case AddressOpsDelete:
            postURL = API_ADDRESS_DELETE_PATH;
            baseDict[@"address_id"] = theAddress.addressId;
            break;
        case AddressOpsDefault:
            postURL = API_ADDRESS_DEFAULT_PATH;
            baseDict[@"address_id"] = theAddress.addressId;
            break;
        default:
            break;
    }
    
    
    NSDictionary * postDict = [DataTrans makePostDict:baseDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
    }];
}

/**
 *  购物车操作
 *
 *  @param theCart   <#theCart description#>
 *  @param operation <#operation description#>
 *  @param block     <#block description#>
 */
- (void)operateCartWithCartModel:(CartModel *)theCart
                       operation:(NSUInteger)operation
                        andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = @"";
    NSMutableDictionary *baseDict = [[NSMutableDictionary alloc]initWithDictionary:
                                     @{@"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                                     @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                                     }}];
    
    
    switch (operation) {
        case CartOpsList:
            postURL = API_CART_LIST_PATH;
            break;
        case CartOpsCreate:
            postURL = API_CART_CREATE_PATH;
            baseDict[@"goods_id"] = theCart.goodsId;
            baseDict[@"number"] = STR_INT([theCart.goodsCount integerValue]);
            baseDict[@"spec"] = theCart.goodsAttrId;
            break;
        case CartOpsUpdate:
            postURL = API_CART_UPDATE_PATH;
            baseDict[@"rec_id"] = theCart.recId;
            baseDict[@"new_number"] = STR_INT([theCart.goodsCount integerValue]);
            break;
        case CartOpsDelete:
            postURL = API_CART_DELETE_PATH;
            baseDict[@"rec_id"] = theCart.recId;
            break;
        default:
            break;
    }
    
    
    NSDictionary * postDict = [DataTrans makePostDict:baseDict];
    //    NSLog(@"!!!!%@", baseDict);
    //    NSLog(@"####%@", postDict);
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {

        NSLog(@"%@", responseObject);
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
    }];
}

/**
 *  购物车操作
 *
 *  @param theCart   <#theCart description#>
 *  @param operation <#operation description#>
 *  @param block     <#block description#>
 */
- (void)operateOrderWithOrderModel:(OrderModel *)theOrder
                         operation:(NSUInteger)operation andPage:(NSInteger)page
                          andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = @"";
    NSMutableDictionary *baseDict = [[NSMutableDictionary alloc]initWithDictionary:
                                     @{@"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                                     @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                                     }}];
    
    
    switch (operation) {
        case OrderOpsList:
            postURL = API_ORDER_LIST_PATH;
            baseDict[@"pagination"]= @{@"page":[NSString stringWithFormat:@"%d", page], @"count":@"10"};
            NSLog(@"%@", theOrder.type);
            baseDict[@"type"] = theOrder.type;
            break;
        case OrderOpsCancel:
            postURL = API_ORDER_CANCEL_PATH;
            baseDict[@"order_id"] = theOrder.orderId;
            break;
        case OrderOpsPay:
            postURL = API_ORDER_PAY_PATH;
            baseDict[@"order_id"] = theOrder.orderId;
            break;
        case OrderOpsAffirmReceived:
            postURL = API_ORDER_AFFIRM_RECEIVED_PATH;
            baseDict[@"order_id"] = theOrder.orderId;
            break;
        default:
            break;
    }
    
    
    NSDictionary * postDict = [DataTrans makePostDict:baseDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            NSNumber *i = responseObject[@"paginated"][@"total"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Page" object:i userInfo:nil];
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
    }];
}




/**
 *  根据parentId 获取区域
 *
 *  @param parentCode <#parentCode description#>
 *  @param block      <#block description#>
 */
- (void)getAreaWithParentID:(NSString *)parentId andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_REGION_PATH;
    
    NSDictionary *postDict = @{@"parent_id" :parentId};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"][@"regions"] , nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
        
    }];
}


- (void)flowCheckOrderWithBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_FLOW_CHECKORDER_PATH;
    
    NSMutableDictionary *baseDict = [[NSMutableDictionary alloc]initWithDictionary:
                                     @{@"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                                     @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                                     }}];
    
    NSLog(@"%@", baseDict);
    //    NSDictionary * postDict = [DataTrans makePostDict:baseDict];
    [[AppRequestManager sharedManager]POST:postURL parameters:baseDict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
            
        }else{
            NSError *error = [NSError errorWithDomain:@"" code:500 userInfo:responseObject[@"status"]];
            block(nil, error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
        
    }];
    
}


- (void)flowDoneWithFlowDoneModel:(FlowDoneModel *)flowModel andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_FLOW_DONE_PATH;
    
    NSMutableDictionary *baseDict = [[NSMutableDictionary alloc]initWithDictionary:
                                     @{@"session": @{@"uid": [DataTrans noNullStringObj: XAppDelegate.me.userId],
                                                     @"sid": [DataTrans noNullStringObj:XAppDelegate.me.sessionId]
                                                     }}];
    
    
    baseDict[@"pay_id"] = [DataTrans noNullStringObj:flowModel.payId];
    baseDict[@"shipping_id"] = [DataTrans noNullStringObj:flowModel.shippingId];
    baseDict[@"bonus"] = [DataTrans noNullStringObj:flowModel.bounsId];
    baseDict[@"integral"] = [DataTrans noNullStringObj:[flowModel.usedIntegral stringValue]];
    baseDict[@"inv_type"] = @"0";
    baseDict[@"inv_content"] = @"";
    baseDict[@"inv_payee"] = @"";
    
    
    NSDictionary * postDict = [DataTrans makePostDict:baseDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject[@"data"] , nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }
        
    }];
}


- (void)uploadPicture:(NSURL *)url resize:(CGSize)resize andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString* tmpFilename = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
    NSURL* tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFilename]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_API, API_UPLOAD_PICTURE];
    // Create a multipart form request.
    NSMutableURLRequest *multipartRequest =
    [[AFHTTPRequestSerializer serializer]
     multipartFormRequestWithMethod:@"POST"
     URLString:urlString
     parameters:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if (url.path) {
             // 如果有resize 那么 按照 size 来
             if (!CGSizeEqualToSize(CGSizeZero, resize)) {
                 NSDictionary *dict= [[NSDictionary alloc]initWithObjectsAndKeys:
                                      @(resize.height), @"height", @(resize.width), @"width", nil];
                 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
                 [formData appendPartWithFormData:jsonData name:@"resize"];
             }else{
                 NSData *originData = [@"origin" dataUsingEncoding:NSUTF8StringEncoding];
                 [formData appendPartWithFormData:originData name:@"resize"];
                 
             }
             
             [formData appendPartWithFileURL:url name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg" error:nil];
         }
         
     } error:nil];
    
    
    [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:multipartRequest writingStreamContentsToFile:tmpFileUrl completionHandler:^(NSError *error) {
        // Create default session manager.
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        // Show progress.
        NSProgress *progress = nil;
        // Here note that we are submitting the initial multipart request. We are, however,
        // forcing the body stream to be read from the temporary file.
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:multipartRequest
                                                                   fromFile:tmpFileUrl
                                                                   progress:&progress
                                                          completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                              {
                                                  // Cleanup: remove temporary file.
                                                  [[NSFileManager defaultManager] removeItemAtURL:tmpFileUrl error:nil];
                                                  
                                                  if(responseObject != nil && block != nil) {
                                                      block(responseObject , nil);
                                                  }
                                                  if (error) {
                                                      block(nil , error);
                                                  }
                                              }];
        
        // Start the file upload.
        [uploadTask resume];
    }];
    
    //    [[AppRequestManager sharedManager] POST:API_UPLOAD_PICTURE parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //        NSLog(@"url.path %@", url.path);
    //        if (url.path) {
    //            // 如果有resize 那么 按照 size 来
    //            if (!CGSizeEqualToSize(CGSizeZero, resize)) {
    //                NSDictionary *dict= [[NSDictionary alloc]initWithObjectsAndKeys:
    //                                     @(resize.height), @"height", @(resize.width), @"width", nil];
    //                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    //                [formData appendPartWithFormData:jsonData name:@"resize"];
    //            }else{
    //                NSData *originData = [@"origin" dataUsingEncoding:NSUTF8StringEncoding];
    //                [formData appendPartWithFormData:originData name:@"resize"];
    //
    //            }
    //
    //            [formData appendPartWithFileURL:url name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg" error:nil];
    //        }
    //    } success:^(NSURLSessionDataTask *task, id responseObject) {
    //        if(responseObject != nil && block != nil) {
    //            block(responseObject , nil);
    //        }
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        if (block) {
    //            block(nil , error);
    //        }
    //    }];
}


- (void)getBrandAllWithBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_BRAND_PATH;
    
    NSDictionary* postDict = @{@"category_id":@"0"};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            block(responseObject[@"data"] , nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}


- (void)getCategoryAllWithBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_CATEGORY_ALL;
    
    NSDictionary* postDict = nil;
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if([DataTrans isCorrectResponseObject:responseObject]) {
            block(responseObject[@"data"] , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}



- (void)createVehicleGalleryWithDict:(NSMutableDictionary *)dict andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_CREATE_VEHICLE_GALLERY;
    
    NSDictionary* postDict = [DataTrans makePostDict:dict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

//
- (void)createVehicleWithDict:(NSMutableDictionary *)dict andBlock:(void (^)(id, NSError *))block
{
    NSString *postURL = API_CREATE_VEHICLE;
    
    NSDictionary* postDict = [DataTrans makePostDict:dict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

// 上传并分享
- (void)createAndShareVehicle:(NSMutableDictionary *)dict andShareAccountList:(NSArray *)shareAccountList andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_CREATE_SHARE_VEHICLE;
    
    NSDictionary* postDict = @{@"vehicle":dict,
                               @"shareAccountList":shareAccountList};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}


// 代运营并分发
- (void)createSubstituteVehicleWithDict:(NSMutableDictionary *)dict andBlock:(void (^)(id, NSError *))block
{
    NSString *postURL = API_CREATE_SUBSTITUTE_VEHICLE;
    
    NSDictionary* postDict = [DataTrans makePostDict:dict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}


- (void)updateVehicleWithDict:(NSMutableDictionary *)dict andBlock:(void (^)(id, NSError *))block
{
    NSString *postURL = API_UPDATE_VEHICLE;
    NSDictionary* postDict = [DataTrans makePostDict:dict];
    
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}


- (void)listVehicleWithMerchantId:(NSString *)merchantId
                      substituted:(BOOL)substituted
                          andPage:(NSInteger)page
                          andSize:(NSInteger)size
                        andStatus:(NSString *)cloudStatus
                         andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_LIST_VEHICLE;
    NSString *postString = STR_INT(page);
    NSString *sizeString = @"20";
    
    if (size > 0) {
        sizeString = STR_INT(size);
    }
    
    NSDictionary *postDict = @{@"page": postString,
                               @"size":sizeString,
                               @"id":XAppDelegate.me.userId,
                               @"substituted":NUM_BOOL(substituted),
                               @"offline":cloudStatus};
    
    postDict = [DataTrans makePostDict:postDict];
    
    // TODO: cloudStatus
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject[@"items"] , nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}


- (void)checkVehicleVin:(NSString *)vinCode andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_CHECK_VEHICLE_VIN;
    NSDictionary *postDict = @{@"vin":vinCode};
    
    // TODO: cloudStatus
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}


- (void)deleteVehicleWithVehicleId:(NSString *)vehicleId
                          andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_DELETE_VEHICLE;
    NSDictionary *postDict = @{@"id":vehicleId};
    
    // TODO: cloudStatus
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}


/**
 *  请求已经绑定的账号
 *
 *  @param block
 */
- (void)listDistributionSiteWithAccountType:(NSString *)accountType andBlock:(void (^)(id responseObject, NSError *error))block;
{
    NSString *postURL = API_LIST_SHARE_ACCOUNT;
    
    NSDictionary *postDict = @{@"page":@"0",
                               @"size":@"100"
                               };
    
    postDict = [DataTrans makePostDict:postDict];
    
    
    if (StringHasValue(accountType)) {
        [postDict setValue:accountType forKey:@"accountType"];
    }
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject[@"items"], nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

/**
 *  请求那些网站不能访问
 *
 *  @param block
 */
- (void)getAvailabilitySiteWithBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_GET_SHARE_AVAILABILITY;
    
    NSDictionary *postDict = [[NSDictionary alloc]init];
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject[@"result"], nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}


- (void)sendShareWithDict:(NSDictionary *)dict andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_MERCHANT_SHARE;
    NSDictionary* postDict = [DataTrans makePostDict:dict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

-(void)userExistWithInviteMobile:(NSString *)inviteMobile andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_USER_EXIST;
    NSDictionary *postDict = @{@"name":@"mobile",
                               @"content":inviteMobile};
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

-(void)updatePasswordWithUserId:(NSString *)userId
                    oldPassowrd:(NSString *)oldPassword
                       password:(NSString *)password
                       andBlock:(void (^)(id responseObject, NSError *error))block;
{
    NSString *postURL = API_UPDATE_PASSWORD;
    NSDictionary *postDict = @{@"id":userId,
                               @"oldPassword":oldPassword,
                               @"password":password};
    
    //    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

-(void)forgotPasswordWithMyMobile:(NSString *)myMobile andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_FORGOT_PASSWORD;
    NSDictionary *postDict = @{@"mobile":myMobile};
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}



-(void)resetPasswordWithMyMobile:(NSString *)myMobile code:(NSString *)code passowrd:(NSString *)password andBlock:(void (^)(id responseObject, NSError *error))block;
{
    NSString *postURL = API_RESET_PASSWORD;
    NSDictionary *postDict = @{@"mobile":myMobile,
                               @"verificationCode":code,
                               @"newPassword":password};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}




- (void)sendSMSWithInviteMobile:(NSString *)inviteMobile andMobile:(NSString *)mobile andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_VERIFICATION_SENDSMS;
    NSDictionary *postDict = @{@"mobile": mobile,
                               @"inviteMobile":inviteMobile};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}


- (void)checkSMSWithMobile:(NSString *)mobile andCode:(NSString *)code andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_VERIFICATION_CHECKSMS;
    NSDictionary *postDict = @{@"mobile": mobile,
                               @"code":code};
    postDict = [DataTrans makePostDict:postDict];
    
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}


- (void)getUserInfoWithUserId:(NSString *)userId andBlock:(void (^)(id responseObject, NSError *error))block;
{
    NSString *postURL = API_USER_SUMMARY;
    
    NSDictionary *postDict = [[NSDictionary alloc]init];
    if (StringHasValue(userId)) {
        postDict = @{@"id": userId};
    }
    
    postDict = [DataTrans makePostDict:postDict];
    
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

//获取代运营用户的数据
- (void)getSubstituteUserWithUserId:(NSString *)userId andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SUBSTITUTE_USER_GET;
    
    NSDictionary *postDict = [[NSDictionary alloc]init];
    if (StringHasValue(userId)) {
        postDict = @{@"userId": userId};
    }
    
    //    postDict = [DataTrans makePostDict:postDict];
    
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];}



- (void)updateUserInfoWithData:(NSDictionary *)userData andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_USER_UPDATE_PATH;
    NSDictionary* postDict = [DataTrans makePostDict:userData];
    
    
    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}


- (void)listHistoryWithSite:(NSString *)site
                  vehicleId:(NSString *)vehicleId
                  andStatus:(NSString *)status
                    andPage:(NSInteger)page
                    andSize:(NSInteger)size
                   andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_HISTORY_LIST;
    NSString *postString = STR_INT(page);
    NSString *sizeString = @"20";
    
    if (size > 0) {
        sizeString = STR_INT(size);
    }
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                     @"userId":XAppDelegate.me.userId,
                                                                                     @"page":postString,
                                                                                     @"size":sizeString}];
    
    if (StringHasValue(vehicleId)) {
        [postDict setObject:vehicleId forKey:@"vehicleId"];
    }
    
    if (StringHasValue(site)) {
        [postDict setObject:site forKey:@"website"];
    }
    if (StringHasValue(status)) {
        [postDict setObject:status forKey:@"status"];
    }
    
    
    
    NSLog(@"listHistoryWithSite %@",postDict);
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

- (void)listHistoryLogWithHistoryId:(NSString *)historyId
                            andPage:(NSInteger)page
                            andSize:(NSInteger)size
                           andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_HISTORY_LOG_LIST;
    NSString *postString = STR_INT(page);
    NSString *sizeString = @"20";
    
    if (size > 0) {
        sizeString = STR_INT(size);
    }
    
    NSDictionary *postDict = @{@"page":postString,
                               @"size":sizeString,
                               @"shareJobId":historyId};
    
    postDict = [DataTrans makePostDict:postDict];
    
    // TODO: cloudStatus
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

#pragma mark 选择第三方车型后重新发车
- (void)shareHistoryRestartWithShareJobId:(NSString *)shareJobId
                andExternalVehicleModelId:(NSString *)modelId
                                 andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postUrl = API_HISTORY_SHARE_RESTART;
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if (StringHasValue(modelId)) {
        dict = @{@"shareJobId": shareJobId,
                 @"externalVehicleModelId": modelId};
    }else{
        dict = @{@"shareJobId": shareJobId};
    }
    
    NSLog(@"shareHistoryRestartWithShareJobId %@",dict);
    [[AppRequestManager sharedManager] POST:postUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

#pragma mark 获得vehicle
- (void)getVehicleWithVehicleId:(NSString *)vehicleId
                       andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postUrl = API_GET_VEHICLE;
    NSDictionary *dict = @{@"id": vehicleId};
    
    [[AppRequestManager sharedManager] GET:postUrl parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

#pragma mark 看车网车源搜索
// API/es/vehicle/search

- (void)getSearchVehicleWithDict:(NSMutableDictionary *)searchDict
                    andOrderDict:(NSMutableDictionary *)orderDict
                         andPage:(NSInteger)page
                         andSize:(NSInteger)size
                        andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postUrl = API_ES_SEARCH;
    
    NSString *postString = STR_INT(page);
    NSString *sizeString = @"20";
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":postString,@"size":sizeString}];
    
    // merge searchDict and orderDict -> postDict
    [postDict addEntriesFromDictionary:searchDict];
    [postDict addEntriesFromDictionary:orderDict];
    
    // clean all empty key
    NSMutableArray *keysToDelete = [NSMutableArray array];
    
    for (NSString* key in [postDict keyEnumerator]) {
        NSString * value = [postDict objectForKey:key];
        if(!StringHasValue(value)){
            [keysToDelete addObject:key];
        }
    }
    
    [postDict removeObjectsForKeys:keysToDelete];
    
    [[AppRequestManager sharedManager]GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject[@"result"][@"hits"][@"hits"], nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

#pragma mark 客户管理
- (void)getContactsListWithUserId:(NSString *)userId andPage:(NSInteger)page andSize:(NSInteger)size andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_CONTACTS_LIST;
    NSString *pageString = STR_INT(page);
    NSString *sizeString = @"20";
    
    NSDictionary *postDict = @{@"userId": userId,
                               @"page": pageString,
                               @"size": sizeString};
    
    [[AppRequestManager sharedManager]GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

- (void)getOneContactWithUserId:(NSString *)userId customerId:(NSString *)customerId andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_CONTACTS_GET;
    NSDictionary *postDict = @{@"userId": userId,
                               @"customerId": customerId};
    [[AppRequestManager sharedManager]GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

- (void)searchContactWithUserId:(NSString *)userId searchString:(NSString *)searchString andPage:(NSInteger)page andSize:(NSInteger)size andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_CONTACTS_SEARCH;
    NSString *pageString = STR_INT(page);
    NSString *sizeString = @"20";
    
    NSDictionary *postDict = @{@"userId": userId,
                               @"searchString": searchString,
                               @"page": pageString,
                               @"size": sizeString};
    [[AppRequestManager sharedManager]GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

#pragma mark 修改价格
- (void)updatePriceWithVehicleId:(NSString *)vehicleId andNewQuotedPrice:(NSNumber *)newQuotedPrice andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_CREATE_ADJUST_PRICE;
    NSDictionary *postDict = @{@"vehicleId": vehicleId,
                               @"newQuotedPrice": newQuotedPrice};
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager] POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

#pragma mark 下架或停止代运营
- (void)offlineVehicleWithVehicleId:(NSString *)vehicleId andBidPrice:(NSNumber *)bidPrice andOfferPrice:(NSNumber *)offerPrice andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_OFFLINE_VEHICLE;
    NSDictionary *postDict = @{@"vehicleId": vehicleId,
                               @"bidPrice": bidPrice,
                               @"offerPrice": offerPrice};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager] POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

/**
 *  bind push
 *
 *  @param device      ios
 *  @param deviceToken deviceToken description
 *  @param block
 */
- (void)pushBindWidthDevice:(NSString *)device
             andDeviceToken:(NSString *)deviceToken
                   andBlock:(void (^)(id responseObject, NSError *error))block{
    
    NSString *postUrl = API_PUSH_BIND;
    
    NSDictionary *postDict = @{@"device": device,
                               @"deviceToken": deviceToken};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager] POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
    
}

#pragma mark 收藏
- (void)createFavoriteWithResourceType:(NSString *)resourceType andResourceId:(NSString *)resourceId andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_FAVORITE_CREATE;
    NSDictionary *postDict = @{@"resourceType": resourceType,
                               @"resourceId": resourceId};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager] POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

- (void)getFavoriteListWithUserId:(NSString *)userId andPage:(NSInteger)page andSize:(NSInteger)size andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_FAVORITE_LIST;
    NSString *pageString = STR_INT(page);
    NSString *sizeString = @"20";
    
    NSDictionary *postDict = @{@"userId": userId,
                               @"page": pageString,
                               @"size": sizeString};
    [[AppRequestManager sharedManager]GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
            NSLog(@"%@", task);
        }
    }];
    
}

- (void)checkFavoriteIsExistedWithResourceType:(NSString *)resourceType andResourceId:(NSString *)resourceId andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_FAVORITE_CHECK;
    NSDictionary *postDict = @{@"resourceType": resourceType,
                               @"resourceId": resourceId};
    
    postDict = [DataTrans makePostDict:postDict];
    
    [[AppRequestManager sharedManager] GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

- (void)deleteFavoriteWithResourceType:(NSString *)resourceType andResourceId:(NSString *)resourceId andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_FAVORITE_DELETE;
    
    NSDictionary *postDict = @{@"resourceType": resourceType,
                               @"resourceId": resourceId};
    
    postDict = [DataTrans makePostDict:postDict];
    [[AppRequestManager sharedManager]POST:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

- (void)getMessageListWithUserId:(NSString *)userId andPage:(NSInteger)page andSize:(NSInteger)size andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_NOTIFICATION_LIST;
    NSString *pageString = STR_INT(page);
    NSString *sizeString = @"20";
    
    NSDictionary *postDict = @{@"userId": userId,
                               @"page": pageString,
                               @"size": sizeString};
    [[AppRequestManager sharedManager]GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

- (void)getUserCompanyAddressWithCityCode:(NSString *)cityCode andBlock:(void (^)(id, NSError *))block
{
    NSString *postUrl = API_AREA_SELECT_MARKET;
    NSDictionary *postDict = @{@"cityCode": cityCode};
    [[AppRequestManager sharedManager]GET:postUrl parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil , error);
        }
    }];
}

@end
