//
//  DeviceTableViewCell.h
//  HotWallet
//
//  Created by Owen on 2018/8/3.
//  Copyright © 2018年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *name;
@property (weak, nonatomic) IBOutlet UILabel *cardname;

@end
