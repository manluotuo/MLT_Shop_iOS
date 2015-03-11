//
//  CommentModel.m
//  mltshop
//
//  Created by 小新 on 15/3/10.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (id)initWithDict:(NSDictionary *)dict
{
    NSLog(@"%@", dict[@"data"]);
    
    for (NSDictionary *dict in dict[@"data"]) {
        _id = [dict objectForKey:@"id"];
        _author = [dict objectForKey:@"author"];
        _content = [dict objectForKey:@"content"];
        _create = [dict objectForKey:@"create"];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
