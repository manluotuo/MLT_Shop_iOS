//
//  OrderDetailViewController.h
//  mltshop
//
//  Created by 小新 on 15/3/14.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

/** order_id */
@property (nonatomic, strong) NSString *order_id;


@property (nonatomic, strong) NSMutableArray *goods_list;


@end
