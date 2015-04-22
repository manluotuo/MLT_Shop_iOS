//
//  NSString+TimeString.m
//  UIDay16_HomeWork
//
//  Created by 程祥贺 on 14-12-26.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "NSString+TimeString.h"

@implementation NSString (TimeString)

+ (NSString *)stringTimeDescribeFromTimeString:(NSString *)string {
    //计算上报时间差
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    //设置一个字符串的时间
    NSMutableString *datestring = [NSMutableString stringWithFormat:@"%@",string];
    //注意 如果20141202052740必须是数字，如果是UNIX时间，不需要下面的插入字符串。
//    [datestring insertString:@"-" atIndex:4];
//    [datestring insertString:@"-" atIndex:7];
//    [datestring insertString:@" " atIndex:10];
//    [datestring insertString:@":" atIndex:13];
//    [datestring insertString:@":" atIndex:16];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm dateFromString:datestring];
    CGFloat dd = [datenow timeIntervalSince1970] - [newdate timeIntervalSince1970];
    NSString *timeString = @"";
    if (dd/3600 < 1) {
        timeString = [NSString stringWithFormat:@"%d", (int)dd/60];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
        
    }
    
    if (dd/3600 > 1 && dd/86400 < 1) {
        timeString = [NSString stringWithFormat:@"%d", (int)dd/3600];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    
    if (dd/86400>1) {
        timeString = [NSString stringWithFormat:@"%d", (int)dd/86400];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    return timeString;
}

+ (NSString *)stringChangeToTimeDescribeFromTimeString:(NSString *)string
{
    
    NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval interval1 = [string doubleValue];

    NSTimeInterval interval  = interval2 - interval1;
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *endDate = [dateFormatter dateFromString:string];
//    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:endDate];
    
//    [dateFormatter release];
    
    if (interval<60) {
        return @"刚刚";
    } else {
        if ((interval = interval / 60) < 60) {
            return [NSString stringWithFormat:@"%d分钟前", (NSInteger)interval];
        } else if ((interval = interval / 60) < 24) {
            return [NSString stringWithFormat:@"%d小时前", (NSInteger)interval];
        } else if ((interval = interval / 24) < 30) {
            return [NSString stringWithFormat:@"%d天前", (NSInteger)interval];
        } else if ((interval = interval / 30) < 12) {
            return [NSString stringWithFormat:@"%d月前", (NSInteger)interval];
        } else {
            return [NSString stringWithFormat:@"%d年前", (NSInteger)interval/12];
        }
    }
}


@end
