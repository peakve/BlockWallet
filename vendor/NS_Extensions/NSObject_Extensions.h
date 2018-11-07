//
//  NSObject_Extensions.h
//  yueta
//
//  Created by wu jianjun on 13-1-14.
//  Copyright (c) 2013年 mobo360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject ( NSObject_Extensions )

+ (id)viewControllerFromClass:(NSString *)className;

+ (id)navigationControllerFromClass:(NSString *)className;

+ (BOOL)isValidObject:(id)object obj_class:(Class)obj_class;

@end
