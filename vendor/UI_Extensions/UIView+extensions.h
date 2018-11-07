//
//  UIView+extensions.h
//  LoveShape
//
//  Created by admin on 13-10-8.
//  Copyright (c) 2013年 terry.tgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extensions)
//设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius;

//设置边框宽度、颜色
- (void)setBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  设置虚线边框
 *
 *  @param borderColor     边框的颜色
 *  @param lineDashPattern 虚线的段长和间隔，例：@[@4,@2]
 */
- (void)setDashedWithBorderColor:(UIColor *)borderColor lineDashPattern:(NSArray *)lineDashPattern;

/**
 *  给view添加虚线
 *
 *  @param lineColor       虚线的颜色
 *  @param startPoint      开始位置
 *  @param endPoint        结束位置
 *  @param lineWidth       线的宽度
 *  @param lineDashPattern @[@线段的长,@空隙的长]
 */
- (void)addDashedWithLineColor:(UIColor *)lineColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth LineDashPattern:(NSArray *)lineDashPattern;

@end
