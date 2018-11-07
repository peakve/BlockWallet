//
//  NSDictionary_Extensions.h
//  Km.0
//
//  Created by terry.tang on 14/11/18.
//  Copyright (c) 2014年 terry.tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(NSDictionary_Extensions)

//读取文件
+ (NSMutableDictionary *)getDictionaryWithFileName:(NSString *)fileName;

@end
