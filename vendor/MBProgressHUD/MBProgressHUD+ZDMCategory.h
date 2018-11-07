//
//  MBProgressHUD+ZDMCategory.h
//  MBTest
//
//  Created by 银羽网络 on 16/8/3.
//  Copyright © 2016年 银羽网络. All rights reserved.
//

//#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD.h"
#define MBProgressHUDShowText(text) [MBProgressHUD autoShowAndHideWithMessage:(text)]

// 网络错误提醒
#define kNetworkErrorPrompt [MBProgressHUD autoShowAndHideWithMessage:@"网络错误,请稍后再试..."];
// 接口返回数据错误提示
#define kInterfaceErrorMsg  if (![responseObject[@"success"] boolValue]) { \
[MBProgressHUD autoShowAndHideWithMessage:responseObject[@"message"]]; \
return ; \
}

@interface MBProgressHUD (ZDMCategory)
+(void)showMessage:(NSString *)message;

+(void)hideMessage;

+(void)autoShowAndHideWithMessage:(NSString *)msg;
@end
