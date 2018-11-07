//
//  UIButton+FillColor.m
//  xlzx
//
//  Created by tony on 15/8/8.
//  Copyright (c) 2015年 tony. All rights reserved.
//

#import "UIButton+FillColor.h"

@implementation UIButton (FillColor)

//将UIColor变换为UIImage
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton createImageWithColor:backgroundColor] forState:state];
}

@end
