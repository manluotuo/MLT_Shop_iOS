//
//  HYBJPushHelper.h
//  mltshop
//
//  Created by 小新 on 15/3/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 * @brief 极光推送相关API封装
 * @author huangyibiao
 */
@interface HYBJPushHelper : NSObject

// 在应用启动的时候调用
+ (void)setupWithOptions:(NSDictionary *)launchOptions;

// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

// ios7以后，才有completion，否则传nil
+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;

// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

@end