//
//  MBProgressHUD+ZDMCategory.m
//  MBTest
//
//  Created by 银羽网络 on 16/8/3.
//  Copyright © 2016年 银羽网络. All rights reserved.
//

#import "MBProgressHUD+ZDMCategory.h"

@implementation MBProgressHUD (ZDMCategory)
+(void)showMessage:(NSString *)message{
    
    [[[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES] label] setText:message];
}

+(void)hideMessage{
    
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
}

+(void)autoShowAndHideWithMessage:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
    hud.label.text = msg;
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:2.0f];
}
@end
