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
    
    if (StringHasValue(json[@"userId"])) {
        onlyMe.userId = json[@"userId"];
    }
    // 有的时候返回值是 属性是id 不是userId
    else if(StringHasValue(json[@"id"])){
        onlyMe.userId = json[@"id"];
    }else{
        [DataTrans showWariningTitle:T(@"用户信息返回有误") andCheatsheet:ICON_TIMES andDuration:2.0f];
        return;
    }
    
    if (StringHasValue(json[@"token"])) {
        onlyMe.userToken = json[@"token"];
    }
    
    if (DictionaryHasValue(json[@"user"])) {
        onlyMe.avatarURL = json[@"user"][@"avatar"];
    }else{
        if (StringHasValue(json[@"avatar"])) {
            onlyMe.avatarURL = json[@"avatar"];
        }
    }
    
    if (StringHasValue(json[@"mobile"])) {
        onlyMe.mobile = json[@"mobile"];
    }
    
    if (StringHasValue(json[@"name"])) {
        onlyMe.nickname = json[@"name"];
    }
    
    MRSave();
    XAppDelegate.me = onlyMe;
    [AppRequestManager setSharedInstance:nil];

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
