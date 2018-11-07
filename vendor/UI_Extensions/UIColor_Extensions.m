//
//  UIColor+Extension.m
//  Airailways
//
//  Created by wu jianjun on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIColor_Extensions.h"

@implementation UIColor (UIColor_Extensions)

+ (UIColor *) colorWithHexString: (NSString *)color
{
	NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6) {
		return [UIColor clearColor];
	}
	
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) 
		cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) 
		cString = [cString substringFromIndex:1];
	if ([cString length] != 6) 
		return [UIColor clearColor];
	
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	
	//r
	NSString *rString = [cString substringWithRange:range];
	
	//g
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	//b
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom((unsigned)time(NULL));
    }
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *) colorFromRGB:(NSInteger)rgbValue {

	return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *) color:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha {

	return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:alpha];
}

@end
