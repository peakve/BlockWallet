
//
//  BluetoothLe.m
//  bleDemo
//
//  Created by owen on 15/4/8.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "BluetoothLe.h"
#import "NSString+Hex.h"
#import "NSData+String.h"
#import "WiseWaitEvent.h"
//#import "MBProgressHUD+ZDMCategory.h"


#define BleServicesData                 @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"

#define BleNotifyCharacteristicsReceive @"0003" //@"FF12"
#define BleDataCharacteristicsSend      @"0002" //@"FF11"

#define BleDataLengthMax                20

#define BleSendSign 					0x55 //0x02		//发送标识
#define BleReceiveSign					0x12		//接收标识

#define BleConnectTime					5000		//5s

#define BleCharacteristicsReceiveLength 20

@interface BluetoothLe()
{
    
    CBCentralManager *_centeralManager;          //蓝牙管理类
    
//    NSUInteger  _totalSendGroup;                 //已经发送的包数
//    NSUInteger  _hasSendGroup;                   //已经发送的包数
	
	WiseWaitEvent *_connectEvent;					//连接等待
	WiseWaitEvent *_recvEvent;						//接收事件
    WiseWaitEvent *_scanEvent;
    WiseWaitEvent *_notifyEvent;
	NSMutableData *_recvData;					//接收数据
	
	int 		_recvCount;						//接收的包数
    
    NSMutableArray<CBPeripheral *> *_scanPers;
    
    //是否为同步
    bool _isSync;
    NSUInteger allPackge;   //数据包总数
    
}



@end


@implementation BluetoothLe

-(id)init
{
    self = [super init];
    if (self != nil) {
        
        _delegate = nil;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _centeralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
        
        _isScanning = NO;    //不是扫描状态
		
		_connectEvent = [[WiseWaitEvent alloc] init];
		_recvEvent = [[WiseWaitEvent alloc] init];
        _scanEvent = [[WiseWaitEvent alloc] init];
        _notifyEvent = [[WiseWaitEvent alloc] init];
        
        _recvData = [NSMutableData data];
        
        _scanPers = [NSMutableArray array];
        
        _isSync = false;
        allPackge =0;
        
    }
    
    return self;
}

//蓝牙单例
+(BluetoothLe *)sharePkiCard
{
    static BluetoothLe *sharePkiCardInstance = nil;
    
    static dispatch_once_t predicate;
    //该函数接收一个dispatch_once用于检查该代码块是否已经被调度,可不用使用@synchronized进行解决同步问题
    dispatch_once(&predicate, ^{
        if (sharePkiCardInstance == nil) {
            sharePkiCardInstance = [[self alloc] init];
        }
    });
    
    return sharePkiCardInstance;

}

-(CBPeripheral *)getPeripheral:(NSString *)identifyUUID
{
	NSArray *peris = [_centeralManager retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:identifyUUID]]];
	return peris[0];
}

//开始扫描
-(bool)startScan
{
    _isSync = false;
    if (_centeralManager.state != CBCentralManagerStatePoweredOn) {
        return NO;
    }
	
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BleServicesData];
    //[_centeralManager scanForPeripheralsWithServices:@[uuid] options:nil];
     [_centeralManager scanForPeripheralsWithServices:nil options:nil];
    _isScanning = YES;
    return YES;
}


/**
 *  同步扫描
 *
 *  @return 扫描结果
 */
- (NSArray<CBPeripheral *> *)scanSynchronize
{
    _scanPers = [NSMutableArray array];
    _isSync = true;
    
    
    if (_centeralManager.state != CBCentralManagerStatePoweredOn) {
        return nil;
    }
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BleServicesData];
   // [_centeralManager scanForPeripheralsWithServices:@[uuid] options:nil];
    [_centeralManager scanForPeripheralsWithServices:nil options:nil];
    [_scanEvent waitSignle:5000]; //扫描5s
    
    
    
    return _scanPers;
}



//停止扫描
-(void)stopScan
{
    [_centeralManager stopScan];
    _isScanning = NO;
}

//连接设备
-(bool)connect:(CBPeripheral *)peripheral
{
	_peripheral = peripheral;
    [_centeralManager connectPeripheral:_peripheral options:nil];
	
    WaitResult result = [_connectEvent waitSignle:BleConnectTime];
	
    if (result != WaitResultSuccess) {
        return NO;
    }
	
    _peripheral.delegate = self;
    [_peripheral discoverServices:nil];
    result = [_notifyEvent waitSignle:10000];
    if (result != WaitResultSuccess) {
        
        return NO;
    }
   // MBProgressHUDShowText(@"连接成功"); //Yaozai zhuxiancheng
    return YES;
}

/*
 *	@method
 *		isConnected
 *	@param
 *      无
 *	@return
 *		成功true，失败false
 *	@discussion
 *		查看卡是否已经连接
 */
-(bool)isConnected
{
    if (_peripheral == nil) {
        return false;
    }
    
    if (_peripheral.state == CBPeripheralStateConnected) {
        return true;
    }
    else{
        return false;
    }

}

/*
 *	@method
 *		bindingCard:
 *	@param
 *      peripheral      --要绑定的蓝牙设备
 *	@return
 *		成功true，失败false
 *	@discussion
 *		绑定设备
 */
-(bool)bindingCard:(CBPeripheral *)peripheral
{
    if (peripheral == nil) {
        return false;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[peripheral.identifier UUIDString] forKey:@"BleCardUUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return true;
}


/*
 *	@method
 *		getBindingCard
 *	@param
 *      无
 *	@return
 *		返回已绑定的蓝牙设备，没有绑定设备时返回nil
 *	@discussion
 *		绑定设备
 */
-(CBPeripheral *)getBindingCard
{
    CBPeripheral *peripheral = nil;
    
    //读取沙盒中保存的uuid
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"BleCardUUID"];
    if (uuid) {
        peripheral = [self getPeripheral:uuid];
    }
    
    return peripheral;
}

/*
*	@method
*		unbindingCard
*	@param
*      无
*	@return
*		无
*	@discussion
*		解除绑定
*/
- (void)unbindingCard
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BleCardUUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*
 *	@method
 *		reconnect
 *	@param
 *      无
 *	@return
 *		成功true，失败false
 *	@discussion
 *		重新连接之前已连接过的设备
 */
-(bool)reconnect
{
    if ([self isConnected]) {
        return true;
    }
    
    if (_peripheral == nil) {
        return false;
    }
    else{
        return [self connect:_peripheral];
    }
}


/**
 *  打开se
 *
 *  @return 返回art
 */
- (NSData *)openSE
{
    CBService * service = [self getService:BleServicesData fromPeripheral:_peripheral];
    CBCharacteristic  * charact = [self getCharacteristic:BleDataCharacteristicsSend fromService:service];
    unsigned char openSeCmd[] = { 0x10, 0x01, 0x00, 0x01, 0x03 };
    
    _recvCount = 0;
    NSData *temp = [NSData dataWithBytes:openSeCmd length:sizeof(openSeCmd)];
    [_peripheral writeValue:temp forCharacteristic:charact type:CBCharacteristicWriteWithResponse];
    
    NSMutableData *tempData = [NSMutableData data];
    WaitResult result = [_recvEvent waitSignle:3000];
    if(result != WaitResultSuccess){
        return nil;
    }
    
    [tempData appendData:_recvData];
    
    return tempData;
}


/**
 *  关闭se
 */
- (bool)closeSE
{
    CBService * service = [self getService:BleServicesData fromPeripheral:_peripheral];
    CBCharacteristic  * charact = [self getCharacteristic:BleDataCharacteristicsSend fromService:service];
    unsigned char closeSeCmd[] = { 0x10, 0x01, 0x00, 0x01, 0x04 };
    
    if (![self isConnected]) {
        return true;
    }
    
    _recvCount = 0;
    NSData *temp = [NSData dataWithBytes:closeSeCmd length:sizeof(closeSeCmd)];
    [_peripheral writeValue:temp forCharacteristic:charact type:CBCharacteristicWriteWithResponse];
    
    NSMutableData *tempData = [NSMutableData data];
    WaitResult result = [_recvEvent waitSignle:3000];
    if(result != WaitResultSuccess){
        return false;
    }
    
    [tempData appendData:_recvData];
    Byte *bytes = tempData.mutableBytes;
    if (tempData.length < 2 || bytes[0] != 0x90 || bytes[1] != 0x00) {
        return false;
    }
    
    return true;
}



//断开连接
-(void)disconnect
{
    [_centeralManager cancelPeripheralConnection:_peripheral];
}

//time ms
-(NSData *)sendReceive:(NSData *)sendData timeOut:(int)time
{
//    NSLog(@"send Data %@",sendData);
	CBService * service = [self getService:BleServicesData fromPeripheral:_peripheral];
	CBCharacteristic  * charact = [self getCharacteristic:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E" fromService:service];
	NSMutableData *temp= [[NSMutableData alloc] initWithCapacity:0];
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
/*    NSString *hex = [NSString getHexByDecimal:sendData.length];
    NSLog(@"hex====%@",hex);
    Byte by[6];
    by[0] = 0x00;
    by[1] = 0xff;
    by[2]  =0xff;
    by[3]  =0xff;
    by[4] = 0x55;
    by[5] = 0xaa;
    
   // by[2] = sendData.length/256;
////    by[2] = (sendData.length+2)%256;
////    by[3] = sendData.length/256;
////    by[4] = sendData.length%256;
    [data appendBytes:by length:sizeof(by)];
    [data appendData:[NSData dataWithHexString:hex]];
	[data appendData:sendData];
	//获取校验和
    char s = [self jiaoyandata:sendData];
     NSLog(@"s=!!!!=%d",s);
    Byte b = (Byte)s;
    //增加校验和
    [data appendBytes:&b length:1];*/
	NSUInteger nGroup = (sendData.length+(BleDataLengthMax-1)-1)/(BleDataLengthMax-1);
	
//	_hasSendGroup = 0;
//	_totalSendGroup = nGroup;
	
	_recvCount = 0; //已接受到得包数清零
	
    for (NSUInteger i=0; i<nGroup; i++)
    {
        [temp setLength:0];
//        by[0] = (nGroup<<4)+i;
//        [temp appendBytes:by length:1];
        if (i == (nGroup-1)) {
            [temp appendBytes:(sendData.bytes+i*(BleDataLengthMax-1)) length:sendData.length-i*(BleDataLengthMax-1) ];
        }
        else{
            [temp appendBytes:(sendData.bytes+i*(BleDataLengthMax-1)) length:(BleDataLengthMax-1)];
        }

        [_peripheral writeValue:temp forCharacteristic:charact type:CBCharacteristicWriteWithResponse];
    }
    [_recvData setLength:0];//清空缓存数据；！！！！！
	NSMutableData *tempData = [NSMutableData data];
	WaitResult result = [_recvEvent waitSignle:time];
    if(result != WaitResultSuccess){
       // MBProgressHUDShowText(@"等待超时");
        return nil;
    }
	
	[tempData appendData:_recvData];
//    Byte *bytes = _recvData.mutableBytes;
//
//    //长度或接收标识错误
//    if (tempData.length < 7 || bytes[0] != BleReceiveSign || ((bytes[3]<<8)+bytes[4]+2) != ((bytes[1]<<8)+bytes[2]) ) {
//        return nil;
//    }
//    int len = (bytes[3]<<8)+bytes[4];
//
//    return [NSMutableData dataWithBytes:tempData.mutableBytes+5 length:len];
    return tempData;
}
/*******
 异或校验和
 ******/
-(char)jiaoyandata:(NSData * ) data {
    char s = 0;
   Byte *testByte = (Byte *)[data bytes] ;
    for (NSInteger i=0; i<data.length; i++) {
        s = s^testByte[i];
    }
    return s;

}
//获取服务
-(CBService *)getService:(NSString *)serviceID fromPeripheral:(CBPeripheral *)peripheral
{
    CBUUID *uuid = [CBUUID UUIDWithString:serviceID];
    
    for (NSUInteger i=0; i<peripheral.services.count; i++) {
        CBService *service = [peripheral.services objectAtIndex:i];
        if ([service.UUID isEqual:uuid]) {
            return service;
        }
    }
    
    return nil;
}


//获取特征值
-(CBCharacteristic *)getCharacteristic:(NSString *)characteristicID fromService:(CBService *)service
{
    CBUUID *uuid = [CBUUID UUIDWithString:characteristicID];
    
    for (NSUInteger i=0; i<service.characteristics.count; i++) {
        CBCharacteristic *characteristic = [service.characteristics objectAtIndex:i];
        if ([characteristic.UUID isEqual:uuid]) {
            return characteristic;
        }
    }
    
    return nil;
}

#pragma mark - CBCentralManager代理函数

//本地蓝牙设备状态更新代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            _localState = BleLocalStatePowerOff;
            break;
        case CBCentralManagerStatePoweredOn:
            _localState = BleLocalStatePowerOn;
            break;
        default:
            _localState = BleLocalStateUnsupported;
            break;
    }
    if(_delegate && [self.delegate respondsToSelector:@selector(ble:didLocalState:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate ble:self didLocalState:_localState];
        });
    }
}

//扫描信息代理
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
	
    if (_isSync) {
        [_scanPers addObject:peripheral];
    }
    else {
        
        if(_delegate && [self.delegate respondsToSelector:@selector(ble:didScan:advertisementData:rssi:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate ble:self didScan:peripheral advertisementData:advertisementData rssi:RSSI];
            });
        }
    }
}

//外围蓝牙设备连接代理
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"HlBluetooth  连接ok");
    [_connectEvent waitOver:WaitResultSuccess];
}

//外围蓝牙设备断开代理
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(ble:didDisconnect:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate ble:self didDisconnect:peripheral];
        });
    }
    
}

//连接外围设备失败代理
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	//连接失败
	[_connectEvent waitOver:WaitResultFailed];
}

#pragma mark - CBPeripheral代理函数
//搜索服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        
		for (CBService *service in peripheral.services) {
			[peripheral discoverCharacteristics:nil forService:service];
		}
    }
    
}

//扫描特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {
//        int count = (int)service.characteristics.count;
//
//        for(int i=0; i < count; i++) {
//            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
//            if ([c.UUID.UUIDString isEqualToString:BleNotifyCharacteristicsReceive]){
//                NSLog(@"%d",c.isNotifying);
//            }
//        }

        CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count-1)];
        if([service.UUID isEqual:s.UUID]) {

            //获取HlBleServicesNotify服务
            CBService *ser = [self getService:BleServicesData fromPeripheral:peripheral];
            //获取HlBleNotifyCharacteristicsReceive特征值
            CBCharacteristic *characteristic = [self getCharacteristic:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E" fromService:ser];

            //打开通知
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];

        }

    }
    if (error)
    {
        NSLog(@"error Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }

    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"service:%@ 的 Characteristic: %@",service.UUID,characteristic.UUID);
    }

    //获取Characteristic的值，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }

    //搜索Characteristic的Descriptors，读到数据会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
    for (CBCharacteristic *characteristic in service.characteristics){
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
    }

}
//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //打印出Characteristic和他的Descriptors
    NSLog(@"characteristic uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        NSLog(@"Descriptor uuid:%@",d.UUID);
    }
    
}
//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
}
//通知状态更改
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
            
            //通知已打开
            if (characteristic.isNotifying) {
//                NSLog(@"通知已打开");
				//连接
				[_notifyEvent waitOver:WaitResultSuccess];
            }
            else{
                [self disconnect];
            }
            
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if ([characteristic.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]) {
		NSLog(@"数据:%@", characteristic.value);
       
         _showlog = [NSString stringWithFormat:@"%@",characteristic.value];
       
		if (error != nil)
		{
			[_recvEvent waitOver:WaitResultFailed];
			return ;
		}
        [_recvData appendData:characteristic.value];
        Byte *bytes = (Byte*)characteristic.value.bytes;
       NSInteger chang= characteristic.value.length;
        if (chang>=2) {
            if (bytes[chang-1]==0x55 && bytes[chang-2]==0xaa) {
                NSLog(@"receive over");
                [_recvEvent waitOver:WaitResultSuccess];
            }
        }
        if (chang==1) {
            if (bytes[chang-1]==0x55 ) {
                NSLog(@"receive over");
                [_recvEvent waitOver:WaitResultSuccess];
            }
        }
        
//        Byte *bytes = (Byte*)characteristic.value.bytes;
//        NSUInteger totalPackage = ((bytes[0]>>4)&0x0F);  //数据总包数
//        NSUInteger currentPackage = (bytes[0]&0x0F);     //当前数据包数
//
//        //接收到第一包
//        if (_recvCount <= 0)
//        {
//            [_recvData setLength:totalPackage*(BleDataLengthMax-1)];
//        }
//        //将数据拷贝到对应的位置
//        memcpy(_recvData.mutableBytes+currentPackage*(BleDataLengthMax-1), bytes+1,
//               characteristic.value.length-1);
//
//        _recvCount++; //接收到的包数加1；
//        if (totalPackage == _recvCount) //所有数据包均已接受完毕
//        {
////            NSLog(@"receive over");
//            [_recvEvent waitOver:WaitResultSuccess];
//        }
    }
	
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//	NSLog(@"written %@",error);
//    if (!error) {
//        _hasSendGroup++;
//        if (_hasSendGroup == _totalSendGroup) {
//            if(_delegate && [self.delegate respondsToSelector:@selector(ble:didWriteData:result:)]) {
//                [self.delegate ble:self didWriteData:peripheral result:YES];
//            }
//        }
//    }
//    else{
//        if(_delegate && [self.delegate respondsToSelector:@selector(ble:didWriteData:result:)]) {
//            [self.delegate ble:self didWriteData:peripheral result:NO];
//        }
//    }
}

-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
	
}


@end
