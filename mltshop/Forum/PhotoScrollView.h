//
//  PhotoScrollView.h
//  mltshop
//
//  Created by 小新 on 15/4/23.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIView


@property (nonatomic, weak) id<PassValueDelegate> passDelegate;
- (void)initData:(NSArray *)array;

@end
