//
//  UIImageExtentions.h
//  Teemo
//
//  Created by Wu Kevin on 12/2/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIImage (Extentions)

- (UIImage *)fixOrientation;

/*
 * Creating
 */
+ (CGContextRef)ARGBBitmapContextWithSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithBitmapContext:(CGContextRef)contextRef;

/*
 * Round corner
 */
- (UIImage *)makeRoundCornersOfSize:(CGSize)cornerSize;

/*
 * Cropping
 */
- (UIImage *)cropCenter;
- (UIImage *)cropAt:(CGRect)rect;

/*
 * Scaling
 */
- (UIImage *)scaleToFitSize:(CGSize)bounds;
- (UIImage *)scaleToSize:(CGSize)newSize;

/*
 * Merging
 */
- (UIImage *)mergeWithImage:(UIImage *)image;
- (UIImage *)mergeWithImage:(UIImage *)image atPoint:(CGPoint)point;

/*
 * Masking
 */
- (UIImage *)maskWithImage:(UIImage *)image;

/*
 * Filtering
 */
- (UIImage *)grayscale;
- (UIImage *)negative;

@end
