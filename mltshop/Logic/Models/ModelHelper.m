 //
//  ModelHelper.m
//  bitmedia
//
//  Created by meng qian on 13-12-31.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import "ModelHelper.h"
#import "AppRequestManager.h"
#import "Me.h"
#import "AppDelegate.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation ModelHelper

@synthesize modelHelperDelegateForLeftMenuVC;
@synthesize modelHelperDelegateForHostVC;
@synthesize modelHelperDelegateForSNSLoginVC;

+ (ModelHelper *)sharedHelper {
    static ModelHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ModelHelper alloc] init];
    });
    
    return _sharedClient;
}

- (Me *)findOnlyMe
{
    NSArray *meArray = [Me MR_findAll];
    if ([meArray count] > 0) {
        return [meArray firstObject];
    }else{
        return nil;
    }
}


- (void)updateMeWithJsonData:(id)json
{
    Me *onlyMe = [[ModelHelper sharedHelper]findOnlyMe];
    
    if (onlyMe == nil) {
        onlyMe = [Me MR_createEntity];
    }
    
    if (StringHasValue(json[@"session"][@"sid"])) {
        onlyMe.sessionId = json[@"session"][@"sid"];
    }

    if (DictionaryHasValue(json[@"user"])) {
        NSDictionary *user = json[@"user"];
        if (StringHasValue(json[@"password"])) {
            onlyMe.password = json[@"password"];
        }
        if (!StringHasValue(onlyMe.avatarURL)) {
            onlyMe.avatarURL = @"logo_luotuo";
        }
        onlyMe.userId = [DataTrans noNullStringObj:user[@"id"]];
        onlyMe.username = [DataTrans noNullStringObj:user[@"name"]];
        onlyMe.rankName = [DataTrans noNullStringObj:user[@"rank_name"]];
        onlyMe.rankLevel = [DataTrans noNullNumberObj:user[@"rank_level"]];
        onlyMe.collectionNum = [DataTrans noNullNumberObj:user[@"collection_num"]];
        onlyMe.email = [DataTrans noNullStringObj:user[@"email"]];
        onlyMe.orderNum = [NSKeyedArchiver archivedDataWithRootObject:user[@"order_num"]];
    }


    MRSave();
    XAppDelegate.me = onlyMe;
    [AppRequestManager updateSharedInstance];

}

- (void)meLogoutWithBlock:(void (^)(BOOL exeStatus))block
{
    
    [Me MR_truncateAll];
    
    // TODO can't wait the data save
    XAppDelegate.me = nil;
    
    MRSave();
    
    block(YES);
    
}



@end
