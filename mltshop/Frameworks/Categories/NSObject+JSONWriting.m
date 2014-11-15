//
//  NSObject+JSONWriting.m
//  bitmedia
//
//  Created by meng qian on 14-2-8.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "NSObject+JSONWriting.h"

@implementation NSObject (JSONWriting)

- (NSString *)JSONRepresentation
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
