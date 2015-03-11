//
//  CommentModel.h
//  mltshop
//
//  Created by 小新 on 15/3/10.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

/** 用户id */
@property(nonatomic, strong) NSString *id;
/** 用户名 */
@property(nonatomic, strong) NSString *author;
/** 评论 */
@property(nonatomic, strong) NSString *content;
/** 时间 */
@property(nonatomic, strong) NSString *create;

- (id)initWithDict:(NSDictionary *)dict;

@end
