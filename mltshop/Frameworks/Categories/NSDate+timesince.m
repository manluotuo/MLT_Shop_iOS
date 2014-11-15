//
//  NSDate+timesince.m
//  youpinapp
//
//  Created by Zhicheng Wei on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// code is borrow from 
// http://objectivesnippets.com/snippet/timesince-category-for-nsdate/


//#define keys [NSArray arrayWithObjects:@"year", @"month", @"week", @"day", @"hour", @"min", @"sec", nil]
//#define values [NSArray arrayWithObjects:[NSNumber numberWithInt:31556926],[NSNumber numberWithInt:2629744],[NSNumber numberWithInt:604800],[NSNumber numberWithInt:86400],[NSNumber numberWithInt:3600],[NSNumber numberWithInt:60],[NSNumber numberWithInt:1],nil]
#define kDepth 1

#import "NSDate+timesince.h"
#import "AppDefs.h"

@implementation NSDate (timesince)

-(NSString *)timesince 
{
    return [self timesinceWithHuman];
}

-(NSString *)timesinceAgo
{
    return [self timesinceWithDepth:kDepth];
}
#define A_DAY 86400
#define A_WEEK 604800
#define SIX_DAYS 518400

-(NSString *)timesinceWithHuman
{
    NSString *result = [[NSString alloc]init];
    int delta = -(int)[self timeIntervalSinceNow];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    
    if (delta <= A_DAY) {
        //22:10
        if (self.isToday) {
            [dateFormatter setDateFormat:@"HH:mm"];
            result = [dateFormatter stringFromDate:self];
        }else{
            result = T(@"昨天");
        }
		
    }else if( delta > A_DAY &&  delta <= A_DAY *2 ){
        //昨天
        result = T(@"昨天");
    }else if( delta > A_DAY *2 && delta <= SIX_DAYS){        
        if (self.isThisWeek) {
            //星期X
            NSArray *weekdayAry = [NSArray arrayWithObjects:T(@"星期天"),T(@"星期一"),T(@"星期二"),T(@"星期三"),T(@"星期四"),T(@"星期五"),T(@"星期六"),nil];
            [dateFormatter setDateFormat:T(@"eee")];
            // 此处更改显示的大写字母的星期几
            [dateFormatter setShortWeekdaySymbols:weekdayAry];
            result = [dateFormatter stringFromDate:self];
        }else{
            [dateFormatter setDateFormat:@"MM-dd"];
            result = [dateFormatter stringFromDate:self];
        }

    }else if( delta > SIX_DAYS ){
        // mm:dd
		[dateFormatter setDateFormat:@"MM-dd"];
        result = [dateFormatter stringFromDate:self];
    }
    
    return result;
}


- (NSString *)horoscope
{
    NSString * cConstellation = @"";
    NSArray * Constellation = [[NSArray alloc] initWithObjects:
                               T(@"白羊座"),T(@"金牛座"),T(@"双子座"),T(@"巨蟹座"),T(@"狮子座"),
                               T(@"处女座"),T(@"天秤座"),T(@"天蝎座"),T(@"射手座"),T(@"魔羯座"),
                               T(@"水瓶座"),T(@"双鱼座"),T(@"不明"), nil];
    int mCnt = 0;
    mCnt = self.month * 100 + self.day;
    
    if (mCnt > 320 && mCnt < 421)
    {
        cConstellation = [Constellation objectAtIndex:0];
    }
    else if (mCnt > 420 && mCnt < 522)
    {
        cConstellation = [Constellation objectAtIndex:1];
    }
    else if (mCnt > 521 && mCnt < 622)
    {
        cConstellation = [Constellation objectAtIndex:2];
    }
    else if (mCnt > 621 && mCnt < 724)
    {
        cConstellation = [Constellation objectAtIndex:3];
    }
    else if (mCnt > 723 && mCnt < 824)
    {
        cConstellation = [Constellation objectAtIndex:4];
    }
    else if (mCnt > 823 && mCnt < 924)
    {
        cConstellation = [Constellation objectAtIndex:5];
    }
    else if (mCnt > 923 && mCnt < 1024)
    {
        cConstellation = [Constellation objectAtIndex:6];
    }
    else if (mCnt > 1023 && mCnt < 1123)
    {
        cConstellation = [Constellation objectAtIndex:7];
    }
    else if (mCnt > 1122 && mCnt < 1223)
    {
        cConstellation = [Constellation objectAtIndex:8];
    }
    else if (mCnt > 1222 || mCnt < 121)
    {
        cConstellation = [Constellation objectAtIndex:9];
    }
    else if (mCnt > 120 && mCnt < 220)
    {
        cConstellation = [Constellation objectAtIndex:10];
    }
    else if (mCnt > 219 && mCnt < 321)
    {
        cConstellation = [Constellation objectAtIndex:11];
    }
    else
    {
        cConstellation = [Constellation objectAtIndex:12];
    }
    
    return cConstellation;
}


-(NSString *)timesinceWithDepth:(int)depth 
{
	NSArray *timeUnits = [NSArray arrayWithObjects:
//						  [NSArray arrayWithObjects:T(@"年"),
//						   [NSNumber numberWithInt:31556926], nil],
//						  [NSArray arrayWithObjects:T(@"月"),
//						   [NSNumber numberWithInt:2629744], nil],
						  [NSArray arrayWithObjects:T(@"周"),
						   [NSNumber numberWithInt:604800], nil],
						  [NSArray arrayWithObjects:T(@"天"),
						   [NSNumber numberWithInt:86400], nil],
						  [NSArray arrayWithObjects:T(@"小时"),
						   [NSNumber numberWithInt:3600], nil],
						  [NSArray arrayWithObjects:T(@"分钟"),
						   [NSNumber numberWithInt:60], nil],
//						  [NSArray arrayWithObjects:T(@"秒"), // 精确到秒 取消
//						   [NSNumber numberWithInt:1], nil],
						  nil];
	NSString *delimiter = T(@", ");
	NSString *combination = T(@"%@%i%@");
	NSString *plural_combination = T(@"%@%i%@");
	NSString *justNow = T(@"刚刚");

	int delta = -(int)[self timeIntervalSinceNow];
	
	NSString *s = [NSString string];
	
	for(NSArray *timeUnit in timeUnits) {
		NSString *key = [timeUnit objectAtIndex:0];
		int unit = [[timeUnit objectAtIndex:1] intValue];
		int v = (int)(delta/unit);
		
		delta = delta % unit;
		
		if ( (v == 0) || (depth == 0) ) {
			// do nothing
		} else if (v==1) {
			s = [s length] ? [NSString stringWithFormat:@"%@%@", s, delimiter] : s;
			s = [NSString stringWithFormat:combination, s, v, key];
			depth--;
		} else {
			s = [s length] ? [NSString stringWithFormat:@"%@%@", s, delimiter] : s;
			s = [NSString stringWithFormat:plural_combination, s, v, key]; 
			depth--;
            if (unit == 604800) {
                //MMDD
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM-dd"];
                s = [dateFormatter stringFromDate:self];
                return s;
            }
		}
        

	}
	
	if ([s length] == 0) {
		s = justNow;
	}else if([s length] == 1){
        // 超过一周 显示 时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd"];
        s = [dateFormatter stringFromDate:self];
    }else {
        s = [NSString stringWithFormat:@"%@%@", s, T(@"前")];
    }
	
	return s;
}

@end