//
//  ScanWalletViewController.m
//  HotWallet
//
//  Created by Owen on 2018/8/3.
//  Copyright © 2018年 owen. All rights reserved.
//

#import "ScanWalletViewController.h"
#import "APDUTestViewController.h"

@interface ScanWalletViewController ()<UITableViewDelegate,UITableViewDataSource,BluetoothLeDelegate>
{
   // NSIndexPath *lastindex;
    NSMutableArray *deviceArray;
    NSIndexPath *lastIndex;
    
}
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;




@end

@implementation ScanWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
   // NSString *string = [defa objectForKey:bluname];
//    if (string.length>2) {
//        self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [self.appDelegate setRootViewControl];
//        return;
//    }
    self.title = @"Scan";
    self.view.backgroundColor = KMainColor;
    _mytableview.backgroundColor = KMainColor;
    deviceArray = [NSMutableArray arrayWithCapacity:1];
    CCRadarView *view = [[CCRadarView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) andThumbnail:@"蓝牙"];
    [self.blueView addSubview:view];
    self.blue.delegate=self;
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectBtnCLick:(id)sender {
    
    if (!lastIndex) {
        MBProgressHUDShowText(@"请选择硬件钱包");
        return;
    }
    [self.blue stopScan];
    CBPeripheral *card = deviceArray[lastIndex.row];

    [MBProgressHUD showMessage:@"连接中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
       BOOL issuccessConnet =  [self.blue connect:card];
        dispatch_async(dispatch_get_main_queue(),^{
            

            [MBProgressHUD hideMessage];
            if (issuccessConnet) {
//                 UITabBarController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
//                //    CustomNavigationController *na = [[CustomNavigationController alloc] initWithRootViewController:vc];
//                [self.navigationController pushViewController:vc animated:YES];
                [self performSegueWithIdentifier:@"home" sender:self];
//                  performSegue(withIdentifier: "createWallet", sender: self)
            }else{
                MBProgressHUDShowText(@"连接超时");
            }
        });
    });
   
    
   
   
    
}
- (IBAction)ResetBtnClick:(id)sender {
    [self.blue stopScan];
    [deviceArray removeAllObjects];
    [_mytableview reloadData];
    [self.blue startScan];
   // [self testrpcxiaofang];
}
#pragma mark blu delegate
-(void)ble:(BluetoothLe *)ble didDisconnect:(CBPeripheral *)peripheral{
    
}
-(void)ble:(BluetoothLe *)ble didLocalState:(BleLocalState)state{
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
 *    @method
 *        ble:didScan:advertisementData:rssi:
 *    @param
 *      ble                 --蓝牙类实例
 *        peripheral          --扫描到的蓝牙设备
 *      advertisementData   --扫描设备的广播数据
 *      rssi                --rssi值
 *    @return
 *        无
 *    @discussion
 *        调用starScan(扫描函数)后，当扫描到了蓝牙设备会调用该函数
 */
- (void)ble:(BluetoothLe *)ble didScan:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData rssi:(NSNumber *)rssi{
     NSLog(@"%@",peripheral);
    if ([peripheral.name containsString:@"Combo_Wallet"]|| [peripheral.name containsString:@"Hierstar_Wallet"]) {
        [deviceArray addObject:peripheral];
       
        [self.mytableview reloadData];
    }
   
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor =KMainColor;
    CBPeripheral *per = deviceArray[indexPath.row];
    cell.cardname.text =[NSString stringWithFormat:@"%@",per.name] ;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return deviceArray.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (lastIndex) {
        DeviceTableViewCell *celllast = [self.mytableview cellForRowAtIndexPath:lastIndex];
        celllast.cardname.textColor = [UIColor whiteColor];
    }
    lastIndex = indexPath;
    DeviceTableViewCell *cell = [self.mytableview cellForRowAtIndexPath:indexPath];
    cell.cardname.textColor = kBtnColor;
    
}

@end
