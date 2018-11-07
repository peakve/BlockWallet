//
//  NSString+Extension.m
//  UFun
//
//  Created by wu jianjun on 11-6-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString_Extensions.h"
#import "NSDate_Extensions.h"
#import <UIKit/UIKit.h>



@implementation NSString (NSString_Extensions)

- (CGFloat)GetHeightWithWidth:(CGFloat)width UIFont:(UIFont*)font
{
    return  [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font ,NSFontAttributeName, nil]  context:nil].size.height;
}

- (CGFloat)GetWidthWithHeight:(CGFloat)height UIFont:(UIFont*)font
{
    return  [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font ,NSFontAttributeName, nil]  context:nil].size.width;
}

//生成随机数
+ (NSString *)getNonce{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

//编码转换
- (NSString*)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),encoding));
}

- (NSString*)URLDecodedString
{
//    NSString *result = [[self stringByReplacingOccurrencesOfString:@"%0D%0A" withString:@""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [[self stringByReplacingOccurrencesOfString:@"%0D%0A" withString:@""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

//把字符串转成一个一个的字符串以数组组成
- (NSArray *)stringsConvertToArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0;i < self.length; i++) {
        NSRange r;
        r.length = 1;
        r.location = i;
        //        [self substringFromIndex:<#(NSUInteger)#>]
    }
    return array;
}

//character分隔字符串
- (NSString *)appendCharacter:(NSString *)character
{
    if(self.length <= 1)
        return self;
    NSMutableString *strs = [[NSMutableString alloc] initWithCapacity:0];
    NSRange r = NSMakeRange(0,0);
    for (int i = 0; i < self.length; i++) {
        r.location = i;
        r.length = 1;
        [strs appendString:[self substringWithRange:r]];
        if(i < (self.length - 1))
            [strs appendString:character];
    }
    return strs;
}

//验证文件夹是否存在,不存在就创建
- (NSString *)directoryExists
{
    BOOL no = NO;
    if(![[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&no])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return self;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

//获取KeyValue
- (NSDictionary *)getQueryKeysValues
{
    NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
    NSArray *arrays = [self componentsSeparatedByString:@"&"];
    for (NSString *item in arrays) {
        NSArray *value = [item componentsSeparatedByString:@"="];
        if([value count] == 2)
        {
            [queryDict setObject:value[1] forKey:value[0]];
        }
    }
    return queryDict;
}

@end




