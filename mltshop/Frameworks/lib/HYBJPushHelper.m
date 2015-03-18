//
//  HYBJPushHelper.m
//  mltshop
//
//  Created by 小新 on 15/3/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "HYBJPushHelper.h"
#import "APService.h"

@implementation HYBJPushHelper

+ (void)setupWithOptions:(NSDictionary *)launchOptions {
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // ios8之后可以自定义category
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // ios8之前 categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
    }
#else
    // categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    
    // Required
    [APService setupWithOption:launchOptions];
    return;
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
    return;
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    [APService handleRemoteNotification:userInfo];
    
    if (completion) {
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    return;  
}  

@end