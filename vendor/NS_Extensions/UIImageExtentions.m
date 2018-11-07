//
//  UIImageExtentions.m
//  Teemo
//
//  Created by Wu Kevin on 12/2/13.
//  Copyright (c) 2013 xbcx. All rights reserved.
//

#import "UIImageExtentions.h"

@implementation UIImage (Extentions)


- (UIImage *)fixOrientation
{
  
  // No-op if the orientation is already correct
  if (self.imageOrientation == UIImageOrientationUp) return self;
  
  // We need to calculate the proper transformation to make the image upright.
  // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
  CGAffineTransform transform = CGAffineTransformIdentity;
  
  switch (self.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, 0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, 0, self.size.height);
      transform = CGAffineTransformRotate(transform, -M_PI_2);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationUpMirrored:
      break;
  }
  
  switch (self.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.width, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
      
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      transform = CGAffineTransformTranslate(transform, self.size.height, 0);
      transform = CGAffineTransformScale(transform, -1, 1);
      break;
    case UIImageOrientationUp:
    case UIImageOrientationDown:
    case UIImageOrientationLeft:
    case UIImageOrientationRight:
      break;
  }
  
  // Now we draw the underlying CGImage into a new context, applying the transform
  // calculated above.
  CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                           CGImageGetBitsPerComponent(self.CGImage), 0,
                                           CGImageGetColorSpace(self.CGImage),
                                           CGImageGetBitmapInfo(self.CGImage));
  CGContextConcatCTM(ctx, transform);
  switch (self.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
      // Grr...
      CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
      break;
      
    default:
      CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
      break;
  }
  
  // And now we just create a new UIImage from the drawing context
  CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
  UIImage *img = [UIImage imageWithCGImage:cgimg];
  CGContextRelease(ctx);
  CGImageRelease(cgimg);
  return img;
}

#pragma mark - Creating

+ (CGContextRef)ARGBBitmapContextWithSize:(CGSize)size
{
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGContextRef contextRef = CGBitmapContextCreate(NULL,
                                                  size.width,
                                                  size.height,
                                                  8,
                                                  4*size.width,
                                                  colorSpaceRef,
                                                  (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
  CGColorSpaceRelease(colorSpaceRef);
  return contextRef;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
  CGSize newSize = CGSizeMake(floor(size.width), floor(size.height));
  
  CGContextRef contextRef = [self ARGBBitmapContextWithSize:newSize];
  
  
  CGContextSetFillColorWithColor(contextRef, color.CGColor);
  CGContextFillRect(contextRef, CGRectMake(0.0, 0.0, newSize.width, newSize.height));
  
  
  CGImageRef retvalImageRef = CGBitmapContextCreateImage(contextRef);
  UIImage *retvalImage = [UIImage imageWithCGImage:retvalImageRef];
  CGImageRelease(retvalImageRef);
  
  CGContextRelease(contextRef);
  
  return retvalImage;
}

+ (UIImage *)imageWithBitmapContext:(CGContextRef)contextRef
{
  if ( contextRef ) {
    CGImageRef retvalImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *retvalImage = [UIImage imageWithCGImage:retvalImageRef];
    CGImageRelease(retvalImageRef);
    
    return retvalImage;
  }
  return nil;
}


#pragma mark - Round corner

- (UIImage *)makeRoundCornersOfSize:(CGSize)cornerSize
{
  CGSize newCornerSize = CGSizeMake(floor(cornerSize.width), floor(cornerSize.height));
  
  if ( (newCornerSize.width>0.0) && (newCornerSize.height>0.0) ) {
    
    CGContextRef contextRef = [UIImage ARGBBitmapContextWithSize:self.size];
    
    
    CGContextBeginPath(contextRef);
    CGContextSaveGState(contextRef);
    CGContextTranslateCTM (contextRef, 0.0, 0.0);
    CGContextScaleCTM (contextRef, newCornerSize.width, newCornerSize.height);
    
    CGFloat fw = self.size.width / newCornerSize.width;
    CGFloat fh = self.size.height / newCornerSize.height;
    
    CGContextMoveToPoint(contextRef, fw, fh/2.0);
    CGContextAddArcToPoint(contextRef, fw, fh, fw/2.0, fh, 1.0);
    CGContextAddArcToPoint(contextRef, 0.0, fh, 0.0, fh/2.0, 1.0);
    CGContextAddArcToPoint(contextRef, 0.0, 0.0, fw/2.0, 0.0, 1.0);
    CGContextAddArcToPoint(contextRef, fw, 0.0, fw, fh/2.0, 1.0);
    
    CGContextClosePath(contextRef);
    CGContextRestoreGState(contextRef);
    CGContextClip(contextRef);
    
    CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, self.size.width, self.size.height), self.CGImage);
    
    
    UIImage *retvalImage = [UIImage imageWithBitmapContext:contextRef];
    CGContextRelease(contextRef);
    return retvalImage;
    
  }
  
  return self;
}


#pragma mark - Cropping

- (UIImage *)cropCenter
{
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  
  CGRect rect = CGRectZero;
  
  if ( width > height ) {
    rect = CGRectMake((width - height)/2.0, 0.0, height, height);
  } else if ( width < height ) {
    rect = CGRectMake(0.0, (height - width)/2.0, width, width);
  } else {
    return self;
  }
  
  return [self cropAt:rect];
}

- (UIImage *)cropAt:(CGRect)rect
{
  CGRect newRect = CGRectMake(floor(rect.origin.x),
                              floor(rect.origin.y),
                              floor(rect.size.width),
                              floor(rect.size.height));
  
  CGImageRef retvalImageRef = CGImageCreateWithImageInRect(self.CGImage, newRect);
  UIImage *retvalImage = [UIImage imageWithCGImage:retvalImageRef];
  CGImageRelease(retvalImageRef);
  
  return retvalImage;
}


#pragma mark - Scaling

- (UIImage *)scaleToFitSize:(CGSize)bounds
{
  CGFloat factor = MIN(bounds.width/self.size.width, bounds.height/self.size.height);
  return [self scaleToSize:CGSizeMake(self.size.width * factor, self.size.height * factor)];
}

- (UIImage *)scaleToSize:(CGSize)size
{
  CGSize newSize = CGSizeMake(floor(size.width), floor(size.height));
  
  CGContextRef contextRef = [UIImage ARGBBitmapContextWithSize:newSize];
  
  
  CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, newSize.width, newSize.height), self.CGImage);
  
  
  UIImage *retvalImage = [UIImage imageWithBitmapContext:contextRef];
  CGContextRelease(contextRef);
  return retvalImage;
}


#pragma mark - Merging

- (UIImage *)mergeWithImage:(UIImage *)image
{
  return [self mergeWithImage:image atPoint:CGPointZero];
}

- (UIImage *)mergeWithImage:(UIImage *)image atPoint:(CGPoint)point
{
  if ( image ) {
    
    CGPoint newPoint = CGPointMake(floor(point.x), floor(point.y));
    
    CGContextRef contextRef = [UIImage ARGBBitmapContextWithSize:self.size];
    
    
    CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, self.size.width, self.size.height), self.CGImage);
    CGContextDrawImage(contextRef, CGRectMake(newPoint.x, newPoint.y, image.size.width, image.size.height), image.CGImage);
    
    
    UIImage *retvalImage = [UIImage imageWithBitmapContext:contextRef];
    CGContextRelease(contextRef);
    return retvalImage;
  }
  
  return self;
}


#pragma mark - Masking

- (UIImage *)maskWithImage:(UIImage *)image
{
  CGImageRef maskImageRef = CGImageMaskCreate(CGImageGetWidth(image.CGImage),
                                              CGImageGetHeight(image.CGImage),
                                              CGImageGetBitsPerComponent(image.CGImage),
                                              CGImageGetBitsPerPixel(image.CGImage),
                                              CGImageGetBytesPerRow(image.CGImage),
                                              CGImageGetDataProvider(image.CGImage),
                                              NULL,
                                              false);
  
  CGImageRef retvalImageRef = NULL;
  
  if ( CGImageGetAlphaInfo(self.CGImage) == kCGImageAlphaNone ) {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGContextRef contextRef = [UIImage ARGBBitmapContextWithSize:CGSizeMake(width, height)];
    CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, width, height), self.CGImage);
    CGImageRef alphaedImageRef = CGBitmapContextCreateImage(contextRef);
    CGContextRelease(contextRef);
    
    retvalImageRef = CGImageCreateWithMask(alphaedImageRef, maskImageRef);
    CGImageRelease(alphaedImageRef);
  } else {
    retvalImageRef = CGImageCreateWithMask(self.CGImage, maskImageRef);
  }
  
  CGImageRelease(maskImageRef);
  
  UIImage *retvalImage = [UIImage imageWithCGImage:retvalImageRef];
  CGImageRelease(retvalImageRef);
  
  return retvalImage;
}


#pragma mark - Filtering

- (UIImage *)grayscale
{
  CGFloat width = self.size.width;
  CGFloat height = self.size.height;
  
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
  CGContextRef contextRef = CGBitmapContextCreate(NULL,
                                                  width,
                                                  height,
                                                  8,
                                                  3*width,
                                                  colorSpaceRef,
                                                  (CGBitmapInfo)kCGImageAlphaNone);
  CGColorSpaceRelease(colorSpaceRef);
  
  CGContextSetShouldAntialias(contextRef, false);
  CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
  
  CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, width, height), self.CGImage);
  
  
  UIImage *retvalImage = [UIImage imageWithBitmapContext:contextRef];
  CGContextRelease(contextRef);
  return retvalImage;
}

- (UIImage *)negative
{
  CGContextRef contextRef = [UIImage ARGBBitmapContextWithSize:self.size];
  
  CGContextSetBlendMode(contextRef, kCGBlendModeCopy);
  CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, self.size.width, self.size.height), self.CGImage);
  
  CGContextSetBlendMode(contextRef, kCGBlendModeDifference);
  CGContextSetFillColorWithColor(contextRef, [UIColor whiteColor].CGColor);
  CGContextFillRect(contextRef, CGRectMake(0.0, 0.0, self.size.width, self.size.height));
  
  
  UIImage *retvalImage = [UIImage imageWithBitmapContext:contextRef];
  CGContextRelease(contextRef);
  return retvalImage;
}


@end
