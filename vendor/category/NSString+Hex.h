//
//  NSString+Hex.h
//  bleDemo
//
//  Created by wurz on 15/4/14.
//  Copyright (c) 2015年 wurz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hex)

//字符串转hex
+(NSString *)hexToString:(NSData *)data space:(BOOL)bSpace;

//utf-8转字符串的编码
+(NSString*)utf8ToUnicode:(NSData*)data;
+(NSString*)utf8ToUnicode:(unsigned char *)data length:(unsigned int)len;
+ (NSString *)getHexByDecimal:(NSInteger)decimal;
@end
