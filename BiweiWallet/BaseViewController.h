//
//  BaseViewController.h
//  hotWalletApduTest
//
//  Created by Owen on 2018/8/30.
//  Copyright © 2018年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRadarView.h"
#import "BluetoothLe.h"
#import "DeviceTableViewCell.h"
#import "MBProgressHUD+ZDMCategory.h"
//#import "APDUTestViewController.h"
#import "NSString+Hex.h"
#import "NSData+String.h"
#import "UIColor_Extensions.h"
#import "WiseWaitEvent.h"
#define KMainColor          [UIColor colorWithHexString:@"#F8F8FF"]     //#1C9DEF 软件主色调 1E1E1E
#define KBackgroundColor    [UIColor colorWithHexString:@"#343434"]     // 页面背景色
#define kBtnColor           [UIColor colorWithHexString:@"#F7BB70"]     //按钮主颜色
#define KFontTitleColor     [UIColor colorWithHexString:@"#333333"]     // 主标题颜色
#define KFontDetailColor    [UIColor colorWithHexString:@"#636363"]     // 详情信息颜色
#define KFontSummaryColor   [UIColor colorWithHexString:@"#868686"]     // 简介颜色
#define KIntputDefaultColor [UIColor colorWithHexString:@"#747474"]     // intput提示颜色
#define KIntputNormalColor  [UIColor colorWithHexString:@"#848493"]     // intput颜色
#define KPriceColor         [UIColor colorWithHexString:@"#FF7E00"]     // 价格颜色
#define KLineColor          [UIColor colorWithHexString:@"#DDDDDD"]     // 线颜色
#define KTimeColor          [UIColor colorWithHexString:@"#A4A4A4"]     // 时间的颜色
#define KbgDisableColor     [UIColor color:160 green:160 blue:160 alpha:1.0f]//禁用色
@interface BaseViewController : UIViewController
@property (nonatomic,strong) BluetoothLe *blue;
@end
