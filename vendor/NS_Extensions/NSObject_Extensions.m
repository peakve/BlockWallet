//
//  NSObject_Extensions.m
//  yueta
//
//  Created by wu jianjun on 13-1-14.
//  Copyright (c) 2013年 mobo360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject_Extensions.h"

@implementation NSObject ( NSObject_Extensions )

+ (id)viewControllerFromClass:(NSString *)className
{
    return [[[NSClassFromString(className) alloc] init] autorelease];
}

+ (id)navigationControllerFromClass:(NSString *)className
{
    id _class = [[[NSClassFromString(className) alloc] init] autorelease];
    return [[[UINavigationController alloc] initWithRootViewController:_class] autorelease];
}

+ (BOOL)isValidObject:(id)object obj_class:(Class)obj_class
{
    return (object != nil && ![object isKindOfClass:[NSNull class] ] && [object isKindOfClass:obj_class]);
}

@end
