//
//  WiseWaitEvent.h
//  HsCrypto
//
//  Created by owen on 10/9/15.
//  Copyright © 2015 owen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WaitResult)
{
    WaitResultSuccess = 0,  //成功
    WaitResultFailed,       //失败
    WaitResultTimeOut,      //等待超时
    WaitResultWaiting,      //正在等待
};

@interface WiseWaitEvent : NSObject
{
}

//等待结果,直到调用waitOver，或mills（ms）后超时
-(WaitResult)waitSignle:(NSUInteger) mills;

//结束等待，并设置waitSignle返回结果
-(void)waitOver:(WaitResult)result;

@end
