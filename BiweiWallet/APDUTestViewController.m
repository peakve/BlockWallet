//
//  APDUTestViewController.m
//  hotWalletApduTest
//
//  Created by Owen on 2018/8/30.
//  Copyright © 2018年 owen. All rights reserved.
//

#import "APDUTestViewController.h"

@interface APDUTestViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *phoneButtons;
@property (weak, nonatomic) IBOutlet UILabel *sendLab;
@property (weak, nonatomic) IBOutlet UILabel *getLab;
@property (weak, nonatomic) IBOutlet UIImageView *tipimge;

@end

@implementation APDUTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//按钮点击事件
- (IBAction)btnClick:(UIButton *)sender {
     NSInteger tag = sender.tag;
   
    if (tag==4) {
        
            self.tipimge.hidden = NO;
        
        
    }else{
         [MBProgressHUD showMessage:@"发送中..."];
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self senddata:tag];});

}
-(void)senddata:(NSInteger)tag{
     int timeout = 8000;
        self.getLab.text = [NSString stringWithFormat:@"loading"];
    
        if ([self.blue isConnected]) {//判断是否连接了冷钱包
    
    
            NSString *sendhex = [[NSString alloc] init];
            NSData *senddata = [[NSData alloc] init];
            /*****************
             1、生成助记词
             2、导入助记词
             3、取出公钥
             4、数据签名
             *****************/
            switch (tag) {
                case 1:
                    {
                        
                        sendhex = @"55aa020100000012000011aa55";
                        senddata = [NSData dataWithHexString:sendhex];
    
                    }
                    break;
                case 2:
                {
                    sendhex = @"55aa03010000001200686465736b20747269616c20686967682064616420706f73742062616c6c206172677565206469616772616d2073706f696c2070757269747920676c756520746f74616c20776f727279206675726e616365207761737465206361726420776569726420686170707931aa55";
                    senddata = [NSData dataWithHexString:sendhex];
                }
                    break;
                case 3:
                {
                    sendhex = @"55aa04020000000100000002000005aa55";
                    senddata = [NSData dataWithHexString:sendhex];
                }
                    break;
                case 4:
                {
    
    
                    sendhex = @"55aa05010000000000940200000001022a8108afc8909395cf438dd5190c1c7b482bbe94968e884d145cc8d2433362000000001976a9149f68c6419c5d54924d388c6155e9af91275bb5d488acffffffff02c0df9100000000001976a9149f68c6419c5d54924d388c6155e9af91275bb5d488aca0860100000000001976a914dd3cd6184d192befadcdf32880f081441cab342a88ac0000000001000000f5aa55";
                    senddata = [NSData dataWithHexString:sendhex];
                }
                    break;
                default:
                    break;
            }
            _sendLab.text = sendhex;
            if (tag==4) {
                //因为要完成确认信息和输入pin码，所以此处的超时时间为120000
                timeout = 120000;
            }
            NSData *getdata = [self.blue sendReceive:senddata timeOut:timeout];
            self.tipimge.hidden = YES;
            [MBProgressHUD hideMessage];
            NSLog(@"send:%@",[self convertDataToHexStr:senddata]);
            NSLog(@"revice:%@",[self convertDataToHexStr:getdata]);
            self.getLab.text = [NSString stringWithFormat:@"%@",getdata];
    
        }else{
            [MBProgressHUD hideMessage];
            MBProgressHUDShowText(@"请连接冷钱包");
            [self.navigationController popViewControllerAnimated:YES];
    
        }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



    
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
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
