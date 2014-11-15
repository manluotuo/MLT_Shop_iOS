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
#import "DistributionSite.h"
#import "AFURLSessionManager.h"
#import "VehicleModel.h"

static NSString * const kAppNetworkAPIBaseURLString = BASE_API;
static AppRequestManager *_sharedManager = nil;
static dispatch_once_t onceToken;

@implementation AppRequestManager

// 单例 HttpManager
+ (AppRequestManager *)sharedManager {
    dispatch_once(&onceToken, ^{
        if (_sharedManager == nil) {
            NSLog(@"kAppNetworkAPIBaseURLString %@",kAppNetworkAPIBaseURLString);
            _sharedManager = [[AppRequestManager alloc] initWithBaseURL:[NSURL URLWithString:kAppNetworkAPIBaseURLString]];
            _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
            // 设置网络超时时间
            _sharedManager.requestSerializer.timeoutInterval = 30;
            _sharedManager.securityPolicy.allowInvalidCertificates = YES;
            
            NSLog(@"ME %@",XAppDelegate.me);
            if (StringHasValue(XAppDelegate.me.userToken)) {
                [_sharedManager.requestSerializer setValue:XAppDelegate.me.userToken forHTTPHeaderField:@"X-AUTH-TOKEN"];
            }
            
            
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

+ (void)setSharedInstance:(AppRequestManager *)instance {
    if (instance == nil) onceToken = 0;
    _sharedManager = instance;
}

+ (AppRequestManager *)nodejsManager {
    static AppRequestManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedManager = [[AppRequestManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8877"]];
    });
    
    return _sharedManager;
}

-(void)networkRequestDidFinish: (NSNotification *) notification
{
    NSError *error = [notification.userInfo objectForKey:AFNetworkingTaskDidFinishErrorKey];
    
    id responseObject = [notification.userInfo objectForKey:AFNetworkingTaskDidFinishSerializedResponseKey];

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
    

    // 不用再判断状态了, 统一 以钟宇的message 为准
//    if (error.code == -1001) {
//        [DataTrans showWariningTitle:T(@"网络故障链接超时") andCheatsheet:nil andDuration:1.5f];
//    }else if (error.code == 3840){
//        [DataTrans showWariningTitle:T(@"服务器返回格式有误") andCheatsheet:nil andDuration:1.5f];
//    }else{
//        
//    }
//    
//    if (httpResponse.statusCode == 400){
//        NSLog(@"Error was 401");
//        if ([responseObject[@"code"] integerValue] == 4006) {
//            [DataTrans showWariningTitle:T(@"用户已存在") andCheatsheet:nil andDuration:1.5f];
//        }else if([responseObject[@"code"] integerValue] == 4101){
//            [DataTrans showWariningTitle:T(@"绑定用户名密码不对") andCheatsheet:nil andDuration:1.5f];
//        }else{
//            [DataTrans showWariningTitle:T(@"接口请求无效") andCheatsheet:nil andDuration:1.5f];
//        }
//    }else if (httpResponse.statusCode == 403){
//        if ([responseObject[@"code"] integerValue] == 6002) {
//            [DataTrans showWariningTitle:T(@"此收藏已存在") andCheatsheet:nil andDuration:1.f];
//        }else if ([responseObject[@"code"] integerValue] == 4002){
//            [DataTrans showWariningTitle:T(@"用户没有权限") andCheatsheet:nil andDuration:1.f];
//        }else if ([responseObject[@"code"] integerValue] == 6501){
//            SET_DEFAULT(NUM_BOOL(YES), @"DEVICE_TOKEN_BIND_SUCCESS");
//        }
//    }
//    else if(httpResponse.statusCode == 500){
////        [DataTrans showWariningTitle:responseObject[@"result"] andCheatsheet:nil andDuration:2.0f];
//    }
    
}

/**
 *  API/system
 *
 *  @param block return {version, imgserver, apiserver}
 */
- (void)getSystemNotificationWithBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SYSTEM_PATH;
    NSString *nowVersion = NOWVERSION;
    
    NSDictionary *postParamDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"ios", @"device",
//                                   [[UIDevice currentDevice] systemVersion], @"device_version",
                                   nowVersion, @"version",
                                   nil];
    
    NSDictionary *postDict = [DataTrans makePostDict:postParamDict];
    
    [[AppRequestManager sharedManager]GET:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject , nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        NSLog(@"%@ %@",postURL, error);
        
        if (error.code == -1004) {
            [DataTrans showWariningTitle:T(@"网络错误") andCheatsheet:ICON_TIMES];
        }
        if (block) {
            block(nil , error);
        }

    }];
}

/**
 *  API/guest/register
 *  用户打开是只请求一次
 *  @param block return {token, uid}
 */
- (void)signInWithUsername:(NSString *)username password:(NSString *)password andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SIGNIN_PATH;

    NSDictionary *postDict = @{@"mobile" :username,
                                @"password": password};
    
    postDict = [DataTrans makePostDict:postDict];

    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if(responseObject != nil) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject , nil);
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



- (void)signUpWithMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_SIGNUP_PATH;
    
    NSDictionary *postDict = @{@"mobile" :mobile,
                               @"password": password,
                               @"verificationCode":code};
    postDict = [DataTrans makePostDict:postDict];

    [[AppRequestManager sharedManager]POST:postURL parameters:postDict success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil) {
            // 刷新本地数据 需要写入数据库
            if (block) {
                block(responseObject , nil);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@ %@",postURL, error);
        if (block) {
            block(nil , error);
        }

    }];
}


- (void)getMerchantMeWithToken:(NSString *)token andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_MERCHANT_ME_PATH;
    if (token) {
        [[AppRequestManager sharedManager].requestSerializer setValue:token forHTTPHeaderField:@"X-AUTH-TOKEN"];
    }
    
    [[AppRequestManager sharedManager]GET:postURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(responseObject != nil && block != nil) {
            block(responseObject , nil);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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



- (void)updateVehicleGalleryWithDict:(NSMutableDictionary *)dict andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_UPDATE_VEHICLE_GALLERY;
    
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

- (void)createDistributionSiteWithAccount:(DistributionAccount *)account
                                       block:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_CREATE_SHARE_ACCOUNT;

    NSLog(@"ME %@",XAppDelegate.me);
    
    NSDictionary *postDict = [[NSDictionary alloc]init];
    if (account.type == DistributionAccountBig) {
        postDict = @{@"userId":XAppDelegate.me.userId,
                                   @"website":account.website,
                                   @"accountType":[DistributionAccount stringWithAccountType:account.type]
                                   };

    }else{
        postDict = @{@"userId":XAppDelegate.me.userId,
                                   @"website":account.website,
                                   @"username":account.username,
                                   @"password":account.password,
                                   @"accountType":[DistributionAccount stringWithAccountType:account.type]
                                   };
    }
    
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

- (void)deleteDistributionSiteWithAccount:(DistributionAccount *)account
                                       block:(void (^)(id responseObject, NSError *error))block
{
    NSString *postURL = API_DELETE_SHARE_ACCOUNT;
    
    NSDictionary *postDict = @{@"id":account.accountId};
    
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

#pragma mark 获取第三方车型ID

//  第一步返回brand
- (void)getThirdModelStepOneWithSite:(NSString *)site
                          andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postUrl = API_GET_THIRD_MODELID;
    NSDictionary *postDict = @{@"step": @"1",
                               @"site": site};
    
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

//  第二步返回供应商和车系
- (void)getThirdModelStepTwoWithSite:(NSString *)site
                           andModel:(VehicleModel *)model
                           andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postUrl = API_GET_THIRD_MODELID;
    NSDictionary *postDict = @{@"step": @"2",
                               @"site": site,
                               @"brand": model.brand};
    
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

//  第三步返回name和ID
- (void)getThirdModelStepThreeWithSite:(NSString *)site
                       andModel:(VehicleModel *)model
                       andBlock:(void (^)(id responseObject, NSError *error))block
{
    NSString *postUrl = API_GET_THIRD_MODELID;
    NSDictionary *postDict = @{@"step": @"3",
                               @"site": site,
                               @"brand": model.brand,
                               @"vendor": model.maker,
                               @"series": model.series};
    
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
