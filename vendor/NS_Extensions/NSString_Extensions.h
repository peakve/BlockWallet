//
//  NSString+Extension.h
//  UFun
//
//  Created by wu jianjun on 11-6-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <sys/xattr.h>

@interface NSString (NSString_Extensions) 

- (CGFloat)GetHeightWithWidth:(CGFloat)width UIFont:(UIFont*)font;
- (CGFloat)GetWidthWithHeight:(CGFloat)height UIFont:(UIFont*)font;

//生成随机数
+ (NSString *)getNonce;

//编码转换
- (NSString*)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString*)URLDecodedString;

//把字符串转成一个一个的字符串以数组组成
- (NSArray *)stringsConvertToArray;

//character分隔字符串
- (NSString *)appendCharacter:(NSString *)character;

//验证文件夹是否存在不存在就创建
- (NSString *)directoryExists;

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
//获取KeyValue
- (NSDictionary *)getQueryKeysValues;

@end
