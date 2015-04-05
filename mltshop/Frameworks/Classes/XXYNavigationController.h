//
//  XXYNavigationController.h
//  TEST
//
//  Created by XiaoXueYuan on 14/12/3.
//  Copyright (c) 2014年 XiaoXueYuan. All rights reserved.
//  Weibo @我是叉叉歪
//

#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define startX -200;


@interface XXYNavigationController : UINavigationController
{
    CGFloat startBackViewX;
    BOOL firstTouch;
}

// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;
@property (nonatomic, assign) BOOL specialPop;

@end

