//
//  NSMutableData+Append.m
//  HsBluetoothPkiCardAPI
//
//  Created by LiPeng on 15-5-26.
//  Copyright (c) 2015年 wurz. All rights reserved.
//

#import "NSMutableData+Append.h"

@implementation NSMutableData (Append)

-(void)appendByte:(Byte) by
{
	[self appendBytes:&by length:1];
}

@end
