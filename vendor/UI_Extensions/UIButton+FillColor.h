//
//  UIButton+FillColor.h
//  xlzx
//
//  Created by tony on 15/8/8.
//  Copyright (c) 2015年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FillColor)

//设置按钮不同状态的背景色
- (void)setBackgroundColor:(UIColor*)backgroundColor forState:(UIControlState)state;

@end
