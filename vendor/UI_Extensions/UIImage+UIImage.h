//
//  UIImage+UIImage.h
//  OrderingCatering
//
//  Created by admin on 13-8-20.
//  Copyright (c) 2013年 terry.tgq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (UIImage)

//等比列压缩缩放 maxsize : 同比缩放的最大尺寸
+ (UIImage *)imageFitScale:(UIImage *)image maxsize:(CGSize)maxsize;

 

@end
 