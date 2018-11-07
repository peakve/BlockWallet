//
//  WiseWaitEvent.m
//  HsCrypto
//
//  Created by owen on 10/9/15.
//  Copyright © 2015 owen. All rights reserved.
//

#import "WiseWaitEvent.h"

@interface WiseWaitEvent()
{
    WaitResult _wResult;          //等待结果
    dispatch_semaphore_t _semaphore;
    
}
@end

@implementation WiseWaitEvent

-(id)init
{
    self = [super init];
    if (self != nil) {
        
        //创建信号量
        _semaphore = dispatch_semaphore_create(0);

    }
    
    return self;
}

//等待结果,直到调用waitOver，或mills（ms）后超时
-(WaitResult)waitSignle:(NSUInteger) mills
{
    WaitResult result;
    
    //创建信号量
    _semaphore = dispatch_semaphore_create(0);
    
    //线程同步
    @synchronized(self)
    {
        _wResult = WaitResultWaiting;
    }
    
    dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , mills * NSEC_PER_MSEC ) ;
    //信号等待,不为0表示超时
    if ( dispatch_semaphore_wait(_semaphore, time) != 0 ){
        [self waitTimeOut];
    }

    @synchronized(self)
    {
        result = _wResult;
    }
    
    return result;
}

//结束等待，并设置waitSignle返回结果
-(void)waitOver:(WaitResult)result
{
    //线程同步
    @synchronized(self)
    {
        _wResult = result;
    }
    
    if (result != WaitResultTimeOut) {
    }
    
    dispatch_semaphore_signal(_semaphore);
}

//超时
-(void)waitTimeOut
{
    [self waitOver:WaitResultTimeOut];
}

@end
