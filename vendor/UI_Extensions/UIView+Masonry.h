//
//  UIView+Masonry.h
//  xlzx
//
//  Created by tony on 16/1/16.
//  Copyright © 2016年 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface UIView (Masonry)

/**
 *  横向等间距排列视图
 *
 *  @param views 视图数组
 */
-(void)distributeSpacingHorizontallyWith:(NSArray *)views;

/**
 *  纵向等间距排列视图
 *
 *  @param views 视图数组
 */
-(void)distributeSpacingVerticallyWith:(NSArray *)views;

@end
