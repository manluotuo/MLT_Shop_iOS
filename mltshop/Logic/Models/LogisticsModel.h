//
//  LogisticsModel.h
//  mltshop
//
//  Created by 小新 on 15/3/27.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogisticsModel : NSObject

/** 物流信息 */
@property (nonatomic, strong) NSString *remark;
/** 日期 */
@property (nonatomic, strong) NSString *datetime;
/** 区域 */
@property (nonatomic, strong) NSString *zone;

@end
