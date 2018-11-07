//
//  BaseViewController.m
//  hotWalletApduTest
//
//  Created by Owen on 2018/8/30.
//  Copyright © 2018年 owen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<BluetoothLeDelegate>
{
    CBPeripheral *myper;//已经绑定的可信载体
    WiseWaitEvent *_connectEvent;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _blue = [BluetoothLe sharePkiCard];
    _blue.delegate = self;
    _connectEvent = [[WiseWaitEvent alloc] init];
    // Do any additional setup after loading the view.
}
#pragma mark blu delegate
-(void)ble:(BluetoothLe *)ble didDisconnect:(CBPeripheral *)peripheral{
    [MBProgressHUD hideMessage];
    
    MBProgressHUDShowText(@"钱包断开连接 ");
}
-(void)ble:(BluetoothLe *)ble didLocalState:(BleLocalState)state{
    
    
}
- (void)ble:(BluetoothLe *)ble didScan:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData rssi:(NSNumber *)rssi{
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
//    NSString *string = [defa objectForKey:bluname];
//    if ([peripheral.name isEqualToString: string]) {
//        myper =peripheral;
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
