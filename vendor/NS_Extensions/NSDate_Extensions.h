//
//  NSDate+Extension.h
//  Airailways
//
//  Created by tgq on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_Extensions) 

//从时间间隔值获取当前日期
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeinterval format:(NSString*)formatString;
//从时间格式化字符串获取当前日期
+ (NSDate *)ToNSDate:(NSString *)dateString format:(NSString*)formatString;
//从时间格式化字符串获取当前日期 时区为原子协调时
+ (NSDate *)ToNSDate:(NSString *)dateString format:(NSString *)formatString locale:(NSLocale *)locale;
//当前日期转化为时间字符串
+ (NSString *)ToNSString:(NSDate *)date format:(NSString*)formatString;
//当前日期转化为时间字符串
+ (NSString *)ToNSString:(NSDate *)date format:(NSString *)formatString locale:(NSLocale *)locale;

//当前日期
+ (NSDate *)now;

//根据时间戳计算剩余天数，小时分钟数
+ (NSDateComponents *)dateFromTimeInterval:(NSTimeInterval)timeinterval;

//单独获取某个时间的YMD 星期。。。
- (NSDateComponents *)dateComponents;
//单独获取某个时间的YMD 星期。。。
- (NSDateComponents *)dateComponentsBylocaleIdentifier:(NSString *)localeIdentifier;

//转换为本地时间
- (NSDate *)toLocalDate;
//转换为本地时间
- (NSDate *)toGMTDate;
//转换成UTC时间
- (NSDate *)toUTCDate;

//取整,取掉日期后面的时间
- (NSDate *)getDate;
//字符串转换时间
+(NSString *)ToString:(NSString *)dateString withDateFormatter:(NSString *)formatter ;

@end
