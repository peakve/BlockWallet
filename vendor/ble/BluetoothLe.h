//
//  BluetoothLe.h
//  bleDemo
//
//  Created by owen on 15/4/8.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, BleLocalState) {
    BleLocalStatePowerOff,         //本地蓝牙已关闭
    BleLocalStatePowerOn,          //本地蓝牙已开启
    BleLocalStateUnsupported,     //本地不支持蓝牙
};

@class BluetoothLe;

//蓝牙代理协议
@protocol BluetoothLeDelegate <NSObject>
@required

/*
 *	@method
 *		ble:didLocalState
 *	@param
 *      ble             --蓝牙类实例
 *		state			--本地蓝牙状态
 *	@return
 *		无
 *	@discussion
 *		当本地状态改变时，调用该函数
 */
- (void)ble:(BluetoothLe *)ble didLocalState:(BleLocalState)state;

/*
 *	@method
 *		ble:didDisconnect:
 *	@param
 *      ble                 --蓝牙类实例
 *		peripheral          --已经断开的蓝牙设备
 *	@return
 *		无
 *	@discussion
 *		当连接断开后，会点用该函数
 */
- (void)ble:(BluetoothLe *)ble didDisconnect:(CBPeripheral *)peripheral;


@optional

/*
 *	@method
 *		ble:didScan:advertisementData:rssi:
 *	@param
 *      ble                 --蓝牙类实例
 *		peripheral          --扫描到的蓝牙设备
 *      advertisementData   --扫描设备的广播数据
 *      rssi                --rssi值
 *	@return
 *		无
 *	@discussion
 *		调用starScan(扫描函数)后，当扫描到了蓝牙设备会调用该函数
 */
- (void)ble:(BluetoothLe *)ble didScan:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData rssi:(NSNumber *)rssi;

-(void)showlogdaili:(NSString *)showlogstr;

@end



@interface BluetoothLe : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

//蓝牙代理
@property (nonatomic, weak) id<BluetoothLeDelegate>delegate;

//是否正在扫描
@property (readonly) BOOL isScanning;

//蓝牙本地状态
@property(readonly) BleLocalState localState;
@property (nonatomic,strong) NSString *showlog;
@property(nonatomic,strong)	CBPeripheral *peripheral;


/*
 *	@method
 *		sharePkiCard
 *	@param
 *      无
 *	@return
 *		实例化后的蓝牙类
 *	@discussion
 *		蓝牙单例，创建蓝牙类的单例
 */
+ (BluetoothLe *)sharePkiCard;


/*
 *	@method
 *		startScan
 *	@param
 *      无
 *	@return
 *		成功Yes失败No
 *	@discussion
 *		开始扫描
 *  @note
 *      当扫描到蓝牙设备时，会调用ble:didScan:advertisementData:rssi:
 */
- (bool)startScan;



/**
 *  同步扫描
 *
 *  @return 扫描结果
 */
- (NSArray<CBPeripheral *> *)scanSynchronize;


/*
 *	@method
 *		stopScan
 *	@param
 *      无
 *	@return
 *		无
 *	@discussion
 *		停止扫描
 */
- (void)stopScan;

/*
 *	@method
 *		connect:
 *	@param
 *      peripheral      --要链接的蓝牙设备
 *	@return
 *		成功Yes，失败No
 *	@discussion
 *		连接设备
 *  @note
 *      连接超时时间为5s
 */
- (bool)connect:(CBPeripheral *)peripheral;


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
- (bool)isConnected;

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
- (bool)bindingCard:(CBPeripheral *)peripheral;


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
- (CBPeripheral *)getBindingCard;



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
- (void)unbindingCard;


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
- (bool)reconnect;


/**
 *  打开se
 *
 *  @return 返回art
 */
- (NSData *)openSE;


/**
 *  关闭se
 */
- (bool) closeSE;


/*
 *	@method
 *		disconnect:
 *	@param
 *      无
 *	@return
 *		无
 *	@discussion
 *		断开连接
 *  @note
 *      蓝牙断开后，会调用ble:didDisconnect:
 */
- (void)disconnect;


//发送接收函数
- (NSData *)sendReceive:(NSData *)sendData timeOut:(int)time;

- (CBPeripheral *)getPeripheral:(NSString *)identifyUUID;



@end
