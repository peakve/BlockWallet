//
//  UIColor+Extension.h
//  Airailways
//
//  Created by wu jianjun on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor (UIColor_Extensions)

//16进制转颜色值, 常用于web颜色值码(除用于web页面解析, 其他地方不建议采用)
+ (UIColor *) colorWithHexString: (NSString *)color;

//16进制转颜色值
+ (UIColor *) colorFromRGB:(NSInteger)rgbValue;

//10进制转颜色值
+ (UIColor *) color:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;
//随机颜色
+(UIColor *)randomColor;
@end