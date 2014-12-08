//
//  DataTrans.h
//  bitmedia
//
//  Created by meng qian on 13-12-30.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Me.h"
//#import "YWDictionary.h"

@interface DataTrans : NSObject

// system info
+ (NSString *)getUserToken:(id)jsonData;
+ (NSString *)getStatus:(id)jsonData;
+ (NSDictionary *)getData:(id)jsonData;
+ (NSArray *)getDataArray:(id)jsonData;
+ (NSMutableArray *)getDataArray:(id)jsonData withVehicleMode:(NSInteger)VehicleMode;
+ (NSMutableArray *)getDataArrayWithExtendData:(id)jsonData;

// Goods Info
// nain info
+ (NSDictionary *)parseDataFromURL:(NSString *)url;

//// Vehilce Info
//+ (NSNumber *)getVehicleAccident:(id)jsonData;
//+ (NSNumber *)getVehicleMaintenance:(id)jsonData;
////+ (Vehicle *)updateVehicleForEditingFromVehicle:(Vehicle *)vehicle;
//+ (NSMutableDictionary *)makePostVehicle:(Vehicle *)theVehicle;
//+ (NSString *)stringFromRowData:(InputModel *)dict;
//+ (NSString *)stringFromVehicleStatus:(NSString *)statusType code:(NSInteger)code;

//+ (Vehicle *)vehicleFromDict:(id)jsonData;
//+ (Gallery *)galleryFromDict:(id)jsonData;
//+ (BOOL)isMyVehicle:(Vehicle *)vehicle;
//+ (BOOL)shouldAddShareJobListView:(Vehicle *)vehicle;
//+ (NSString *)getWebsiteString:(NSString *)website;

// user info
+ (NSString *)getUserId:(id)jsonData;
+ (NSString *)getUserInvitationCode:(id)jsonData;
+ (NSString *)getUserNickname:(id)jsonData;
+ (NSInteger )getUserGroup:(id)jsonData;
+ (NSString *)getUserAvatarURL:(id)jsonData;

// 获取gallery photo列表
+ (NSMutableArray *)getGalleryArrayWithId:(NSString *)galleryId;
+ (NSMutableArray *)getGalleryArrayWithId:(NSString *)galleryId andStatus:(NSInteger)status;

//// 获取车辆信息
//+ (Vehicle *)getVehicleWithId:(NSString *)vehicleId;
//
//// 检查线上图片是否存在
//+ (Gallery *)getGalleryWithPhotoURL:(NSString *)photoURL;
//// 检查线下图片是否存在
//+ (Gallery *)getGalleryWithId:(NSString *)galleryId andFilePath:(NSString *)filePath;
//+ (Gallery *)getGalleryWithId:(NSString *)galleryId andPhotoURL:(NSString *)photoURL;

// 获取车辆封面图
+ (NSString *)getVehicleCover:(id)jsonData;
+ (NSDate *)getVehicleDate:(id)jsonData;

////weibo parse
//+ (NSString *)getWeiboUid:(id)jsonData;
//+ (NSString *)getWeiboExpires:(id)jsonData;
//
//// qq connect
//+ (NSString *)getQQUid:(id)jsonData;
//+ (NSString *)getQQOpenID:(id)jsonData;

// 解析ID
+ (NSString *)getID:(id)jsonData;


// comment postData and NSError

// 为上传车辆重构信息
+ (NSDictionary *)makePostDict:(NSDictionary *)params;
+ (NSMutableDictionary *)makePostUserInfo;
//+ (NSMutableDictionary *)makeAddressObjFromAreaModel:(AreaModel *)model;

+(NSMutableDictionary *)dictFromDocumentsData:(NSData *)data;

// 时间日期格式转换
+ (NSDate *)dateFromNSDatetimeStr:(NSString *)dateStr;
+ (NSDate *)dateFromNSDateStr:(NSString *)dateStr;
+ (NSDate *)dateFromUnixTimeStr:(NSString *)unixTimeStr;
+ (NSString *)dateStringFromDate:(NSDate *)date;
+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;
+ (NSNumber *)dateNumberFromNSDate:(NSDate *)date;
+ (NSString *)dateTimeStringFromDate:(NSDate *)dateTime;


// ISO8601格式的时间转换
+ (NSString *)strFromISO8601:(NSDate *) date;
+ (NSDate *)dateFromISO8601:(NSString *) str;

// 非空类型
+ (NSString *)noNullStringObj:(id)jsonData byName:(NSString *)name;
+ (NSString *)noNullStringObj:(id)jsonData;
+ (NSString *)noNullDataObj:(id)jsonData;
+ (NSNumber *)noNullBoolObj:(id)jsonData;
+ (NSNumber *)noNullNumberObj:(id)jsonData;
+ (NSDate *)noNullDateObj:(id)jsonData;

// 根据初登日期自动计算年检时间
+ (NSDate *)dateAutomatic:(NSDate *)sourceDate;

// 价格的string类型 除10000 精确到.2f
+ (NSString *)getStringPrice:(id)jsonData;
+ (NSNumber *)numBoolFromString:(NSString *)string;
+ (NSString *)stringFromNumBool:(NSNumber *)number;

+ (Me *)meFromDict:(id)jsonData;

//// 颜色列表
//+ (YWDictionary *)colorDict;
//+ (NSDictionary *)interiorColorDict;
////+ (NSString *)colorKeyWithValue:(NSString *)value;
//+ (NSDictionary *)purposeDict;
////+ (NSString *)purposeKeyWithValue:(NSString *)value;
//+ (NSDictionary *)genderDict;
////+ (NSString *)genderKeyWithValue:(NSString *)value;
//+ (YWDictionary *)photoAngleDict;
////+ (NSString *)photoAngleKeyWithValue:(NSString *)value;
//+ (YWDictionary *)tradeTimesDict;
////+ (NSString *)tradeTimesKeyWithValue:(NSString *)value;
//+ (YWDictionary *)historyDict;


//
+ (NSInteger)getIntStatus:(id)jsonData;
+ (NSString *)getString:(NSString *)str byMax:(NSInteger)max;
+ (NSInteger)getCountFromString:(NSString *)source useSubString:(NSString *)subString;

// make fake data
+ (NSArray *)makeFakeData:(NSInteger)count;

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length;
+ (NSString *)localDocumentPath;
+ (NSString *)localLibraryPath;
// 各种验证
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateMobile:(NSString *)mobileString;
+ (BOOL)isValidateLicenseNumber:(NSString*)licenseNumber;
+ (BOOL)isValidatePassword:(NSString*)password;

+ (BOOL)isValidateLevelId:(NSString *)LevelId;
+ (BOOL)isValidateVinCode:(NSString *)vinCode;


// 显示错误信息
+ (void)showErrorWithUrl:(NSString *)url data:(NSDictionary *)responseObject andBlock:(void (^)(id, NSError *))block;
+ (void)showWariningTitle:(NSString *)title andCheatsheet:(NSString *)Cheatsheet;
+ (void)showWariningTitle:(NSString *)title andCheatsheet:(NSString *)Cheatsheet andDuration:(CGFloat)second;

// 转换七牛
+ (NSString *)transSevenNiu:(NSString *)aliyunUrl
                      width:(NSInteger)width
                     height:(NSInteger)height
                    quality:(NSInteger)quality;

// 从color 生成image
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius;
+ (BOOL)isCorrectResponseObject:(NSDictionary *)responseObject;



@end
