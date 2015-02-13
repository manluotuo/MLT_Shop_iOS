//
//  DataTrans.m
//  bitmedia
//
//  Created by meng qian on 13-12-30.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import "DataTrans.h"
#import "AppDelegate.h"
#import "NSDate+Utilities.h"
#import <HTProgressHUD/HTProgressHUD.h>
#import <HTProgressHUD/HTProgressHUDIndicatorView.h>

@interface DataTrans()

+ (NSString *)convertNumberToStringIfNumber:(id)obj;
+ (NSNumber *)convertStringToNumberIfString:(id)obj;


@end

@implementation DataTrans


#pragma mark - data

+ (NSDictionary *)getData:(id)jsonData
{
    return [DataTrans getDictionaryObj:jsonData byName:@"data"];
}

+ (NSArray *)getDataArray:(id)jsonData
{
    return [DataTrans getArrayObj:jsonData byName:@"data"];
}

+ (NSMutableArray *)getDataArrayWithExtendData:(id)jsonData
{
    NSArray *data = [DataTrans getArrayObj:jsonData byName:@"data"];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int i=0; i<[data count]; i++) {
        NSMutableDictionary *item = [[NSMutableDictionary alloc]initWithDictionary:[data objectAtIndex:i]];
        [item setObject:INT(VehicleModeUnreaded) forKey:@"vehicleMode"];
        [item setObject:NUM_BOOL(NO) forKey:@"collect_status"];
        [item setObject:INT(VehicleOpinionNone) forKey:@"updown_status"];
        [result addObject:item];
    }
    
    return result;
}


/////////////////////////////////////////////////////////
#pragma mark - goods delegate
/////////////////////////////////////////////////////////
//  category-([^-]+)-b([^.|-]+)  => 43,11
//  http://www.manluotuo.com/category-43-b11-min0-max0-attr0.html
//
//  brand-([^-]+)-c([^.|-]+) => 12,0
//  http://www.manluotuo.com/brand-12-c0.html
//
//  goods-([^.|-]+) => 372
//  http://www.manluotuo.com/goods-372.html

+ (id)parseDataFromURL:(NSString *)url
{
    NSString *cateRegex = @"category-([^-]+)-b([^.|-]+)";
    NSString *brandRegex = @"brand-([^-]+)-c([^.|-]+)";
    NSString *goodsRegex = @"goods-([^.|-]+)";
    
    SearchModel *theModel = [[SearchModel alloc]init];
    
    // 不支持 http://www.manluotuo.com/brand.php?id=10 传参
    if ([url rangeOfString:@"php"].location != NSNotFound) {
        return @{@"type":@"url", @"id": url};
    }
    
    if([url rangeOfString:@"category"].location != NSNotFound){
        
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:cateRegex
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSArray *matches = [regex matchesInString:url options:0 range:NSMakeRange(0, url.length)];
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        
        theModel.catId = [url substringWithRange:[match rangeAtIndex:1]];
        theModel.brandId = [url substringWithRange:[match rangeAtIndex:2]];
        return theModel;
    }else if([url rangeOfString:@"brand"].location != NSNotFound) {
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:brandRegex
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSArray *matches = [regex matchesInString:url options:0 range:NSMakeRange(0, url.length)];
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        
        theModel.brandId = [url substringWithRange:[match rangeAtIndex:1]];
        theModel.catId = [url substringWithRange:[match rangeAtIndex:2]];
        return theModel;

    }else if([url rangeOfString:@"goods"].location != NSNotFound) {
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:goodsRegex
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSArray *matches = [regex matchesInString:url options:0 range:NSMakeRange(0, url.length)];
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        
        NSString *goodsId= [url substringWithRange:[match rangeAtIndex:1]];
        return @{@"type":@"goods", @"id": goodsId};
    }else{
        return @{@"type":@"url", @"id": url};
    }
        
}


+ (CGRect)calcRect:(NSInteger)index preLine:(NSInteger)preLine withRect:(CGRect)rect
{
    CGFloat x = rect.origin.x * (index % preLine * 2 + 1) + rect.size.width * (index % preLine) ;
    CGFloat y = rect.origin.y * (floor(index / preLine) * 2 + 1) + rect.size.height * floor(index / preLine);
    return CGRectMake( x, y, rect.size.width, rect.size.height);
}

+ (NSString *)getSepString:(NSString *)inputString
{
    NSArray *temp = [[NSArray alloc]init];
    if (([inputString rangeOfString:@"+"].location != NSNotFound)) {
        temp = [inputString componentsSeparatedByString:@"+"];
    }
    if (([inputString rangeOfString:@"-"].location != NSNotFound)) {
        temp = [inputString componentsSeparatedByString:@"-"];
    }
    
    return [temp firstObject];
}




/////////////////////////////////////////////////////////
#pragma mark - me delegate
/////////////////////////////////////////////////////////

//+ (Me *)meFromDict:(id)jsonData
//{
//    if ([jsonData isKindOfClass:[Me class]]) {
//        return jsonData;
//    }
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", XAppDelegate.me.userId];
//    Me *theMe = [Me MR_findFirstWithPredicate:predicate];
//
//    
//    //    theMe.mobile    = [DataTrans noNullStringObj:jsonData[@"mobile"]];
//    //    theMe.password    = [DataTrans noNullStringObj:jsonData[@"password"]];
////    theMe.username  = [DataTrans noNullStringObj:jsonData[@"username"]];
//    theMe.email     = [DataTrans noNullStringObj:jsonData[@"email"]];
//    theMe.nickname  = [DataTrans noNullStringObj:jsonData[@"name"]];
//    theMe.gender    = [DataTrans noNullStringObj:jsonData[@"gender"]];
//    theMe.avatarURL    = [DataTrans noNullStringObj:jsonData[@"avatar"]];
//    theMe.publicPhone = [DataTrans noNullStringObj:jsonData[@"publicPhone"]];
//    theMe.companyName = [DataTrans noNullStringObj:jsonData[@"companyName"]];
//    theMe.companyAddress = [DataTrans noNullStringObj:jsonData[@"companyAddress"]];
//    theMe.userType  = [DataTrans noNullStringObj:jsonData[@"userType"]];
//    theMe.address = [NSKeyedArchiver archivedDataWithRootObject:jsonData[@"address"]];
//    
//    MRSave();
//    return theMe;
//}

#pragma mark - vehicle info


+ (NSString *)getWebsiteString:(NSString *)website
{
    NSDictionary *websiteDict = @{@"58.com": @"58同城",
                                  @"51auto.com": @"51汽车",
                                  @"baixing.com": @"百姓网",
                                  @"iautos.cn": @"第一车网",
                                  @"ganji.com": @"赶集网",
                                  @"hx2car.com": @"华夏二手车",
                                  @"kanche.com": @"看车网",
                                  @"che168.com": @"二手车之家",
                                  @"taoche.com": @"淘车网"
                                  };
    return [websiteDict objectForKey:website];
}

/* gallery 排成扁平的了

+ (NSDictionary *)parseGalleryFromAPI:(NSDictionary *)gallery
{
    NSMutableDictionary *parsedGallery = [[NSMutableDictionary alloc]init];
    NSDictionary *external = gallery[@"external"];
    NSDictionary *internal = gallery[@"internal"];
    NSDictionary *highlight = gallery[@"highlight"];
    
    if ([DataTrans DictionaryHasValue:external]) {
        for (NSString *key in [external allKeys]) {
            [parsedGallery setObject:external[key] forKey:key];
        }
    }
    
    if ([DataTrans DictionaryHasValue:internal]) {
        for (NSString *key in [internal allKeys]) {
            [parsedGallery setObject:internal[key] forKey:key];
        }
    }
    
    if ([DataTrans DictionaryHasValue:highlight]) {
        for (NSString *key in [highlight allKeys]) {
            [parsedGallery setObject:highlight[key] forKey:key];
        }
    }
    
    return parsedGallery;
}
 
*/

+(BOOL)DictionaryHasValue:(NSDictionary *)dict
{
    NSArray * array = [dict allKeys];
    if ([array count]>0) {
        return YES;
    }else{
        return NO;
    }
}


+ (NSString *)stringFromVehicleStatus:(NSString *)statusType code:(NSInteger)code
{
    NSString *result = @"";
    if ([statusType isEqualToString:@"cloudStatus"]) {
        switch (code) {
            case VehicleCloudOnline:
                // TODO: change back to false
                result = @"false";
                break;
            case VehicleCloudOffline:
                result = @"true";
                break;
                
            default:
                break;
        }
    }
    
    return result;
}

+(NSMutableDictionary *)dictFromDocumentsData:(NSData *)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSArray *list = (NSArray*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    for (NSDictionary *item in list) {
        dict[item[@"key"]] = item[@"value"];
    }
    
    return dict;
}

#pragma mark - user info

+ (NSString *)getUserToken:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"token"];
}


+ (NSString *)getUserId:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"uid"];
}

+ (NSString *)getUserInvitationCode:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"invitation"];
}

+ (NSString *)getUserNickname:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"nickname"];
}

+ (NSString *)getUserAvatarURL:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"avatar"];
}

+ (NSInteger )getUserGroup:(id)jsonData
{
    NSString * group = [DataTrans noNullStringObj:jsonData byName:@"group"];
    
    if ([group isEqualToString:STR_INT(UserGroupGuest)]) {
        return UserGroupGuest;
    }else if([group isEqualToString:STR_INT(UserGroupWeibo)]){
        return UserGroupWeibo;
    }else if([group isEqualToString:STR_INT(UserGroupQQ)]){
        return UserGroupQQ;
    }else{
        return UserGroupGuest;
    }
}


#pragma mark - status

+ (NSString *)getStatus:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"status"];
}

+ (NSInteger)getIntStatus:(id)jsonData
{
    NSNumber *status = [DataTrans getNumberObj:jsonData byName:@"status"];
    return status.integerValue;
}

#pragma mark - weibo userinfo

+ (NSString *)getWeiboUid:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"uid"];
}

+ (NSString *)getWeiboExpires:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"expires_in"];
}

#pragma mark - qq userinfo

+ (NSString *)getQQUid:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"id"];
}
+ (NSString *)getQQOpenID:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"open_id"];
}

#pragma mark - vehicle




+ (NSString *)getString:(NSString *)str byMax:(NSInteger)max
{
    if (str.length < max) {
        return str;
    }
    NSString *result = [str substringToIndex:str.length-(str.length-max)];
    return result;
}

+ (NSInteger)getCountFromString:(NSString *)source useSubString:(NSString *)subString
{
    NSScanner *mainScanner = [NSScanner scannerWithString:source];
    NSString *temp;
    NSInteger numberOfChar = 0;
    while(![mainScanner isAtEnd])
    {
        [mainScanner scanUpToString:subString intoString:&temp];
        if(![mainScanner isAtEnd]) {
            numberOfChar++;
            [mainScanner scanString:subString intoString:nil];
        }
    }
    //
//    NSInteger count = [[source componentsSeparatedByString:subString] count];
//    return count;
    return numberOfChar;
}


// datebase generate date
+ (NSDate *)getgDate:(id)jsonData
{
    NSString *dataString = [DataTrans noNullStringObj:jsonData byName:@"date"];
    return [DataTrans dateFromUnixTimeStr:dataString];
}

+(NSMutableDictionary *)makePostUserInfo
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", XAppDelegate.me.userId];
    Me *theMe = [Me MR_findFirstWithPredicate:predicate];
    
    result[@"id"] = XAppDelegate.me.userId;
//    result[@"username"] = [DataTrans noNullStringObj:theMe.username];
    result[@"name"] = [DataTrans noNullStringObj:theMe.username];
//    result[@"gender"] = [DataTrans noNullStringObj:theMe.gender];
    result[@"avatarUrl"] = [DataTrans noNullStringObj:theMe.avatarURL];
    return result;
}



#pragma mark - get id
+ (NSString *)getID:(id)jsonData
{
    return [DataTrans noNullStringObj:jsonData byName:@"id"];
}

#pragma mark - make data

+ (NSDictionary *)makePostDict:(NSDictionary *)params
{
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc]init];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    postParams[@"json"] = jsonString;
    
    // 统一增加userID
    
    return postParams;
}

+ (void)showErrorWithUrl:(NSString *)url data:(NSDictionary *)responseObject andBlock:(void (^)(id, NSError *))block
{
    NSError *error = [[NSError alloc]initWithDomain:url
                                               code:[DataTrans getIntStatus:responseObject]
                                           userInfo:nil];
//    block(nil , error);
    
    HTProgressHUD *HUD = [[HTProgressHUD alloc]init];
    HUD.text = [NSString stringWithFormat:@"%@: %@",T(@"错误代码"), [DataTrans getStatus:responseObject]];
    
    UILabel *indicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.backgroundColor = [UIColor clearColor];
    indicator.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    indicator.text = ICON_TIMES_CIRCLE;
    indicator.font = FONT_AWESOME_30;
    
    HUD.indicatorView = (HTProgressHUDIndicatorView *)indicator;
    [HUD showInView:XAppDelegate.window animated:YES];
    [HUD hideAfterDelay:1];
    
    NSLog(@"%@",error);
}

+ (void)showWariningTitle:(NSString *)title andCheatsheet:(NSString *)Cheatsheet
{
    [DataTrans showWariningTitle:(NSString *)title andCheatsheet:(NSString *)Cheatsheet andDuration:1.0];
}

+ (void)showWariningTitle:(NSString *)title andCheatsheet:(NSString *)Cheatsheet andDuration:(CGFloat)second
{
    UILabel *indicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    indicator.backgroundColor = [UIColor clearColor];
    indicator.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    indicator.text = Cheatsheet;
    indicator.font = FONT_AWESOME_30;

    HTProgressHUD *HUD = [[HTProgressHUD alloc]init];
    
    
    if (Cheatsheet == nil) {
        HUD.indicatorView = nil;
    }else{
        HUD.indicatorView = (HTProgressHUDIndicatorView *)indicator;
    }
    
    HUD.textLabel.numberOfLines = 0;
    HUD.text = title;
    
    if ([[[UIApplication sharedApplication] windows] count] > 1) {
        [HUD showInView:[[[UIApplication sharedApplication] windows] objectAtIndex:1] animated:YES];
    }else{
        [HUD showInView:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
    }

    [HUD hideAfterDelay:second];
}



#pragma mark comment function

+ (NSNumber *)numBoolFromString:(NSString *)string
{
    if ([string isEqualToString:T(@"是")]) {
        return NUM_BOOL(YES);
    }else{
        return NUM_BOOL(NO);
    }
}

+ (NSString *)stringFromNumBool:(NSNumber *)number
{
    if ([number boolValue]) {
        return T(@"是");
    }else{
        return T(@"否");
    }
}

+(NSNumber *)getNumberObj:(id)jsonData byName:(id)name
{
    id obj = [jsonData valueForKey:name];
    if (obj == nil) {
        return [[NSNumber alloc] initWithInteger:[ERROR_PARAM integerValue]];
    }
    return obj;
}


+(NSString *)noNullStringObj:(id)jsonData byName:(id)name
{
    id obj = [jsonData valueForKey:name];
//    if ([obj isKindOfClass:[NSNull class]]) {
//        return @"";
//    }
    if (obj == nil) return @"";
    
    return [self convertNumberToStringIfNumber:obj];
}


/////////////////////////////////////////////////////////
#pragma mark - no null
/////////////////////////////////////////////////////////

+ (NSString *)noNullStringObj:(id)jsonData
{
    if (jsonData == nil){
        return @"";
    }else{
        if ([jsonData isKindOfClass:[NSString class]]) {
            return jsonData;
        }else{
            return @"";
        }
    }
}

+ (NSString *)noNullDataObj:(id)jsonData
{
    if (jsonData == nil){
        return [NSData data];
    }else{
        return jsonData;
    }
}


+ (NSNumber *)noNullBoolObj:(id)jsonData
{
    if ([jsonData boolValue] == NO){
        return [NSNumber numberWithBool:NO];
    }else{
        return [NSNumber numberWithBool:YES];
    }
}
+ (NSNumber *)noNullNumberObj:(id)jsonData
{
    if (jsonData == nil){
        return [NSNumber numberWithInteger:0];
    }else{
        return [self convertStringToNumberIfString:jsonData];
    }
}

+ (NSDate *)noNullDateObj:(id)jsonData
{
    if (jsonData == nil){
        return [NSDate dateWithTimeIntervalSince1970:0];
    }else{
        return jsonData;
    }
}

+ (NSDate *)dateAutomatic:(NSDate *)sourceDate
{
    NSDate *resultDate;
    NSDate *nowDate     = [[NSDate alloc]init];
//    NSDate *theDate     = [DataTrans dateFromNSDateStr:@"2010-09"];
    
    // 时间比现在早了多少天
    NSInteger daysPass = [sourceDate daysBeforeDate:nowDate];
    NSInteger years = floor(daysPass / 365.0f);
    
    if (years >= 6) {
        if (sourceDate.month <= nowDate.month) {
            resultDate = [sourceDate dateByAddingYears:years + 1];
        } else {
            resultDate = [sourceDate dateByAddingYears:years + 2];
        }
    }else {
        if (years >= 4 && years < 6) {
            resultDate = [sourceDate dateByAddingYears:6];
        } else if (years >= 2 && years < 4) {
            resultDate = [sourceDate dateByAddingYears:4];
        } else if (years < 2) {
            resultDate = [sourceDate dateByAddingYears:2];
        }
//        if (sourceDate.month <= nowDate.month) {
//            resultDate = [sourceDate dateByAddingYears:years + 2];
//        } else {
//            resultDate = [sourceDate dateByAddingYears:years + 3];
//        }
    }
    
//    if ([sourceDate isLaterThanDate:theDate]) {
//        //
//        
//        if (sourceDate.month <= nowDate.month) {
//            resultDate = [sourceDate dateByAddingYears:years + 2];
//        } else {
//            resultDate = [sourceDate dateByAddingYears:years + 3]; //今年的这一天
//        }

//        if ([sourceDate isLaterThanDate:[theDate dateByAddingYears:6]]) {
//            resultDate = [sourceDate dateByAddingYears:1];
//        }else{
//            resultDate = [sourceDate dateByAddingYears:6];
//        }
//    }else{
//        
//        if (years >= 6) {
//            if (sourceDate.month <= nowDate.month) {
//                resultDate = [sourceDate dateByAddingYears:years + 1];
//            } else {
//                resultDate = [sourceDate dateByAddingYears:years + 2]; //今年的这一天
//            }
//        }else if(years >= 4 && years < 6){
//            resultDate = [sourceDate dateByAddingYears:6];
//        }else{
//            resultDate = [sourceDate dateByAddingYears:4];
//        }
//    }
    
    return resultDate;
}


+ (NSString *)getStringPrice:(id)jsonData
{
    if (jsonData == nil) {
        return @"";
    }else{
        CGFloat num = [(NSNumber *)jsonData floatValue] ;
        NSString *string = [NSString stringWithFormat:@"%.2f", num /10000 ];
        return string;
    }
}


+(NSDictionary *)getDictionaryObj:(id)jsonData byName:(id)name
{
    id obj = [jsonData valueForKey:name];
    if ([obj isKindOfClass:[NSNull class]]) {
        return [[NSDictionary alloc]initWithObjectsAndKeys: nil];
    }
    
    return obj;
}

+(NSArray *)getArrayObj:(id)jsonData byName:(id)name
{
    id obj = [jsonData valueForKey:name];
    if ([obj isKindOfClass:[NSNull class]]) {
        return [[NSArray alloc]initWithObjects:nil];
    }
    
    return obj;
}


+ (NSString *)convertNumberToStringIfNumber:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj stringValue];
    }
    return obj;
}

+ (NSNumber *)convertStringToNumberIfString:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithFloat:[obj floatValue]];
    }
    return obj;
}


/////////////////////////////////////////////////////////
#pragma mark - NSDate
/////////////////////////////////////////////////////////

+ (NSDate *)dateFromNSDatetimeStr:(NSString *)dateStr
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:DATETIME_FORMATE];
    });
    
    return [dateFormatter dateFromString:dateStr];
}
+ (NSDate *)dateFromNSDateStr:(NSString *)dateStr
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:DATE_FORMATE];
    });
    
    return [dateFormatter dateFromString:dateStr];
}

+ (NSDate *)dateFromUnixTimeStr:(NSString *)unixTimeStr
{
    NSDate *result = [[NSDate alloc]init];
    long long unixTime = [unixTimeStr longLongValue];
    result = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)unixTime];
    return  result;
}

+ (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_YMD_FORMATE];
    if (date != nil) {
        if ([date isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
            return @"";
        }else{
            return [formatter stringFromDate:date];
        }
    }else{
        return @"";
    }
}

+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    if (date != nil) {
        if ([date isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
            return @"";
        }else{
            return [formatter stringFromDate:date];
        }
    }else{
        return @"";
    }}


+ (NSNumber *)dateNumberFromNSDate:(NSDate *)date
{
    if (date != nil) {
        NSTimeInterval result = [date timeIntervalSince1970];
        return [NSNumber numberWithDouble:result];
    }else{
        return [NSNumber numberWithInteger:0];
    }
}

+ (NSString *)dateTimeStringFromDate:(NSDate *)dateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATETIME_FORMATE];
    return [formatter stringFromDate:dateTime];
}

/////////////////////////////////////////////////////////
#pragma mark - ISO8601 <-> NSDate
// 1994-11-05T08:15:30.333-05:00 corresponds to November 5, 1994, 8:15:30 am, US Eastern Standard Time.

// 1994-11-05T13:15:30Z corresponds to the same instant.
/////////////////////////////////////////////////////////


+ (NSString *) strFromISO8601:(NSDate *) date {
    static NSDateFormatter* sISO8601 = nil;
    if ([date isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]]) {
        return @"";
    }
    
    if (!sISO8601) {
        sISO8601 = [[NSDateFormatter alloc] init];
        
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        int offset = [timeZone secondsFromGMT];
        
        NSMutableString *strFormat = [NSMutableString stringWithString:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        offset /= 60; //bring down to minutes
        if (offset == 0)
            [strFormat appendString:ISO_TIMEZONE_UTC_FORMAT];
        else
            [strFormat appendFormat:ISO_TIMEZONE_OFFSET_FORMAT, offset / 60, offset % 60];
        
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:strFormat];
    }
    return [sISO8601 stringFromDate:date];
}

+ (NSDate *) dateFromISO8601:(NSString *) str {
    static NSDateFormatter* sISO8601 = nil;
    if (!StringHasValue(str)) {
        return [NSDate dateWithTimeIntervalSince1970:0];
    }

    if (!sISO8601) {
        sISO8601 = [[NSDateFormatter alloc] init];
        
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        int offset = [timeZone secondsFromGMT];
        
        NSMutableString *strFormat = [NSMutableString stringWithString:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        offset /= 60; //bring down to minutes
        if (offset == 0)
            [strFormat appendString:ISO_TIMEZONE_UTC_FORMAT];
        else
            [strFormat appendFormat:ISO_TIMEZONE_OFFSET_FORMAT, offset / 60, offset % 60];
        
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:strFormat];
    }
    if ([str hasSuffix:@"Z"]) {
        str = [str substringToIndex:(str.length-1)];
    }
    
    NSDate *d = [sISO8601 dateFromString:str];
    return d;
    
}

+ (BOOL)isCorrectResponseObject:(NSDictionary *)responseObject
{
    if ([responseObject[@"status"][@"succeed"] isEqualToNumber:INT(1)]
        && DictionaryHasValue(responseObject)
        && responseObject != nil) {
        return YES;
    }else{
        return NO;
    }
}

//+ (NSString *)colorKeyWithValue:(NSString *)value
//{
//    NSDictionary *colorDict = [DataTrans colorDict];
//    NSArray *keyList = [colorDict allKeysForObject:value];
//    return [keyList firstObject];
//}

//+ (NSString *)purposeKeyWithValue:(NSString *)value
//{
//    NSDictionary *purposeDict = [DataTrans purposeDict];
//    NSArray *keyList = [purposeDict allKeysForObject:value];
//    return [keyList firstObject];
//}
//+ (NSString *)genderKeyWithValue:(NSString *)value
//{
//    NSDictionary *purposeDict = [DataTrans genderDict];
//    NSArray *keyList = [purposeDict allKeysForObject:value];
//    return [keyList firstObject];
//}
//+ (NSString *)photoAngleKeyWithValue:(NSString *)value
//{
//    NSDictionary *purposeDict = [DataTrans photoAngleDict];
//    NSArray *keyList = [purposeDict allKeysForObject:value];
//    return [keyList firstObject];
//}
//+ (NSString *)tradeTimesKeyWithValue:(NSString *)value
//{
//    NSDictionary *purposeDict = [DataTrans tradeTimesDict];
//    NSArray *keyList = [purposeDict allKeysForObject:value];
//    return [keyList firstObject];
//}


#pragma mark - fake data
+ (NSArray *)makeFakeData:(NSInteger)count
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"推荐",@"热点", @"理财", nil];
    
    for (int i = 0; i< count; i++) {
        
        NSDictionary *itemData = @{@"id":STR_INT(i+1), @"name": titleArray[i] , @"type": @"list"};

        [result insertObject:itemData atIndex:i];
    }
    return [[NSArray alloc]initWithArray:result];
}


+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}

/**
 *  本地document directory 路径
 *
 *  @return string
 */
+ (NSString *)localLibraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)localDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobileString
{
//    // 正则判断手机号码地址格式
//    
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//    
//    if (([regextestmobile evaluateWithObject:mobileString] == YES)
//        || ([regextestcm evaluateWithObject:mobileString] == YES)
//        || ([regextestct evaluateWithObject:mobileString] == YES)
//        || ([regextestcu evaluateWithObject:mobileString] == YES)
//        || ([regextestphs evaluateWithObject:mobileString] == YES))
//    {
//        return YES;
//    }
//    else 
//    {
//        return NO;
//    }
    
    //手机号以13,14,15,18,17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(145)|(147)|(15[0-9])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobileString];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidatePassword:(NSString*)password
{
    NSString *carRegex = @"^[A-Za-z_0-9]{6,16}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:password];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateLicenseNumber:(NSString*)licenseNumber
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
//    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:licenseNumber];
}

+ (BOOL)isValidateLevelId:(NSString *)LevelId
{
    NSString *regex = @"^[A-Z][A-Z][A-Z]\\d{14}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    NSLog(@"phoneTest is %@",test);
    return [test evaluateWithObject:LevelId];
}

+ (BOOL)isValidateVinCode:(NSString *)vinCode
{
    NSString *regex = @"^[A-Za-z_0-9]{17}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    NSLog(@"phoneTest is %@",test);
    return [test evaluateWithObject:vinCode];
}

// 转换七牛
// http://pic.kanche.com/0000c2aa-9987-4eb6-b582-a540f8c8eec9.jpg?@800w_600_h_90q
// to
// http://kanche-pic.qiniudn.com/0000c2aa-9987-4eb6-b582-a540f8c8eec9.jpg?imageView2/1/w/800/h/600/q/90

+ (NSString *)transSevenNiu:(NSString *)aliyunUrl
                      width:(NSInteger)width
                     height:(NSInteger)height
                    quality:(NSInteger)quality
{
    NSString *sevenNiuUrl = @"";
    if ([aliyunUrl hasPrefix:@"http://pic.kanche"]) {
        sevenNiuUrl =  [aliyunUrl stringByReplacingOccurrencesOfString:@"http://pic.kanche.com"
                                                            withString:@"http://kanche-pic.qiniudn.com"];

        if (width >0 || height > 0 || quality > 0) {
            sevenNiuUrl = [sevenNiuUrl stringByAppendingString:@"?imageView2/1"];
        }
        if (width > 0) {
            sevenNiuUrl = [NSString stringWithFormat:@"%@/w/%d",sevenNiuUrl,width];
        }
        if (height > 0) {
            sevenNiuUrl = [NSString stringWithFormat:@"%@/h/%d",sevenNiuUrl,height];
        }
        if (quality > 0) {
            sevenNiuUrl = [NSString stringWithFormat:@"%@/q/%d",sevenNiuUrl,quality];
        }
        
        return sevenNiuUrl;
    }else{
        return aliyunUrl;
    }

}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){.size = size});
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }
        
        [view.layer setCornerRadius:0];
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        return roundedView;
    } else {
        return view;
    }
    
}



@end
