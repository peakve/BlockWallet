//
//  UIImage+UIImage.m
//  OrderingCatering
//
//  Created by admin on 13-8-20.
//  Copyright (c) 2013年 terry.tgq. All rights reserved.
//

#import "UIImage+UIImage.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (UIImage)

//等比列压缩缩放 maxsize : 同比缩放的最大尺寸
+ (UIImage *)imageFitScale:(UIImage *)image maxsize:(CGSize)maxsize
{
//    CGFloat width = CGImageGetWidth(image.CGImage);
//    CGFloat height = CGImageGetHeight(image.CGImage);
//    CGSize size = maxsize;
//    
//    float w = 0.0f;
//    float h = 0.0f;
//    float oor = width * 1.0 / height;
//    float nr = size.width * 1.0 / size.height;
//    if(oor < nr) {
//        w = size.width;
//        h = w * height / width;
//    } else {
//        h = size.height;
//        w = h * width / height;
//    }
//    
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    // 绘制改变大小的图片
//    [image drawInRect:CGRectMake((size.width - w)/2, (size.height - h)/2, w, h)];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    // 返回新的改变大小后的图片
//    return scaledImage;
    
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    CGSize size = image.size;
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
    
}



@end
