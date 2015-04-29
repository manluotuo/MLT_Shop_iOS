//
//  ContentModel.h
//  mltshop
//
//  Created by 小新 on 15/4/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property (nonatomic, strong) NSString *repostid;
@property (nonatomic, strong) NSString *postid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headerimg;
@property (nonatomic, strong) NSArray *reply;

@end
