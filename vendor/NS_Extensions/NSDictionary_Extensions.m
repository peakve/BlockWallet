//
//  NSDictionary_Extensions.m
//  Km.0
//
//  Created by terry.tang on 14/11/18.
//  Copyright (c) 2014年 terry.tang. All rights reserved.
//

#import "NSDictionary_Extensions.h"
#import "NSString_Extensions.h"

@implementation NSDictionary(NSDictionary_Extensions)

//读取文件
+ (NSMutableDictionary *)getDictionaryWithFileName:(NSString *)fileName
{
    [fileName.stringByDeletingLastPathComponent directoryExists];
    return [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
}

@end
