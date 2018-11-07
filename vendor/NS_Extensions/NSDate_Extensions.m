//
//  NSDate+Extension.m
//  Airailways
//
//  Created by tgq on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate_Extensions.h"
//一天有多少秒
#define daysSeconds            86400

@implementation NSDate (NSDate_Extensions)

//从时间间隔值获取当前日期 时区为格林威治
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)timeinterval format:(NSString*)formatString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    [dateFormat setDateFormat:formatString];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString  *str = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSinceNow:timeinterval] ];
    NSDate *date = [NSDate ToNSDate:str format:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat release];
    
    return  date;
}

//从时间格式化字符串获取当前日期 时区为原子协调时
+ (NSDate *)ToNSDate:(NSString *)dateString format:(NSString *)formatString
{
    return [NSDate ToNSDate:dateString format:formatString locale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
}

//从时间格式化字符串获取当前日期 时区为原子协调时
+ (NSDate *)ToNSDate:(NSString *)dateString format:(NSString *)formatString locale:(NSLocale *)locale
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    [dateFormat setLocale:locale];
    [dateFormat setDateFormat:formatString];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormat dateFromString:dateString];
    [dateFormat release];
    
    return  date;
}

//当前日期
+ (NSDate *)now
{
    NSString *nowSt =[NSDate ToNSString:[[NSDate date] toLocalDate] format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate ToNSDate:nowSt format:@"yyyy-MM-dd HH:mm:ss"];
    return now;
}

//根据时间戳计算剩余天数，小时分钟数
+ (NSDateComponents *)dateFromTimeInterval:(NSTimeInterval)timeinterval
{
    NSDateComponents *cal = [[NSDateComponents alloc] init];
    cal.year =  (int)timeinterval/(86400 * 365);
    cal.day = ((int)timeinterval%(86400 * 365))/86400;  //(int)timeinterval/86400;
    cal.hour = ((int)timeinterval%86400)/(3600);
    cal.minute = (((int)timeinterval%86400))%(3600)/60;
    cal.second = (((int)timeinterval%86400))%(3600)%60;
    return [cal autorelease];
}

//单独获取某个时间的YMD 星期。。。
- (NSDateComponents *)dateComponents
{
    return [[self toGMTDate] dateComponentsBylocaleIdentifier:NSCalendarIdentifierGregorian];
}

//单独获取某个时间的YMD 星期。。。
- (NSDateComponents *)dateComponentsBylocaleIdentifier:(NSString *)localeIdentifier
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:localeIdentifier];
    [gregorian setLocale:[NSLocale localeWithLocaleIdentifier:localeIdentifier]];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    
    NSDateComponents *weekdayComponents = [gregorian components:unitFlags fromDate:self];
    
    [gregorian release];
    
    return weekdayComponents;
}

//当前日期转化为时间字符串
+ (NSString *)ToNSString:(NSDate *)date format:(NSString *)formatString
{
    
    return [NSDate ToNSString:date format:formatString locale:[NSLocale currentLocale]];
//    return [NSDate ToNSString:date format:formatString locale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
}

//当前日期转化为时间字符串
+ (NSString *)ToNSString:(NSDate *)date format:(NSString *)formatString locale:(NSLocale *)locale
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    [dateFormat setLocale:locale];
    [dateFormat setDateFormat:formatString];
    NSString *s_date = [dateFormat stringFromDate:date];
    [dateFormat release];
    
    return  s_date;
    
}

//转换为本地时间(相差八小时专用)
- (NSDate *)toLocalDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    return [self dateByAddingTimeInterval: interval];
}

//转换为本地时间
- (NSDate *)toGMTDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    return [self dateByAddingTimeInterval:-interval];
}

//转换成UTC时间
- (NSDate *)toUTCDate
{
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    return [self dateByAddingTimeInterval:-interval];
}

//取整,取掉日期后面的时间
- (NSDate *)getDate
{
    NSDateComponents *dc = [self dateComponents];
    NSDate *submitDate = [NSDate ToNSDate:[NSString stringWithFormat:@"%d-%d-%d",(int)dc.year,(int)dc.month,(int)dc.day] format:@"yyyy-MM-dd"];
    
    return submitDate;
}

//字符串转换成时间
+(NSString *)ToString:(NSString *)dateString withDateFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

@end
