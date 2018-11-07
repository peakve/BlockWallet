//
//  AppHardWallet.swift
//  BiweiWallet
//
//  Created by peak on 2018/9/18.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation

class HardWallet {
    
    static let shared = HardWallet()
    
    func getMnemonicWords() -> MnemonicMessage {
        
        let blue = BluetoothLe.sharePkiCard()
        let sendhex = "55aa020100000012000011aa55"
        let sendData = sendhex.data()
        let getData = blue?.sendReceive(sendData, timeOut: 8000)
        
        NSLog("send:%@",sendData.hex ?? "///");
        NSLog("revice:%@",getData?.hex ?? "///");
        
        let byteStream = ByteStream(getData!)
        let prefix = byteStream.read(Data.self, count: 2)
        
        let length = byteStream.read(Data.self, count: 1)
        let payload = byteStream.read(Data.self, count: length.integer())
        let resCode = byteStream.read(Data.self, count: 2)
        let subffix = byteStream.read(Data.self, count: 2)
        
        
        NSLog("%@,%@,%@,%@,%@",prefix.hex,length.hex,payload.hex,resCode.hex,subffix.hex)
        let str =  String(data:payload ,encoding: String.Encoding.utf8)
        NSLog("content:%@", str ?? "")
        
        let result = MnemonicMessage()
        result.prefix = prefix.hex
        result.resCode = resCode.hex
        result.mnemonic = str?.components(separatedBy: " ")
        
        return result
        
    }
    
    //由硬件生成，暂不支持
//    func createAddress() -> AddressMessage {
//        let blue = BluetoothLe.sharePkiCard()
//         //btc 01:P2PKH 02: P2SH
//        let dstr="0A0200000001020000010000"
//        let checknum = Data.init(hex: dstr)?.xor()
//        var sendData = Data()
//
//        sendData += Data.init(hex: "55aa")!
//        sendData += Data.init(hex: dstr)!
//        sendData += Data.init(bytes: [checknum!])
//        sendData += Data.init(hex: "aa55")!
//
//        let getData = blue?.sendReceive(sendData, timeOut: 8000)
//
//        NSLog("send:%@",sendData.hex);
//        NSLog("revice:%@",getData?.hex ?? "///");
//
//        let byteStream = ByteStream(getData!)
//        let prefix = byteStream.read(Data.self, count: 2)
//
//        let length = byteStream.read(Data.self, count: 1)
//        let payload = byteStream.read(Data.self, count: length.integer())
//        let resCode = byteStream.read(Data.self, count: 2)
//        let subffix = byteStream.read(Data.self, count: 2)
//
//        let str =  String(data:payload ,encoding: String.Encoding.utf8)
//
//        let result = AddressMessage()
//        result.prefix = prefix.hex
//        result.resCode = resCode.hex
//        result.address = str
//
//        return result
//    }
    
    func getPublicKey() ->Data {
        let blue = BluetoothLe.sharePkiCard()
        //btc
        let dstr="040200000001000000020000"
        let checknum = Data.init(hex: dstr)?.xor()
        var sendData = Data()
        
        sendData += Data.init(hex: "55aa")!
        sendData += Data.init(hex: dstr)!
        sendData += Data.init(bytes: [checknum!])
        sendData += Data.init(hex: "aa55")!
        
        let getData = blue?.sendReceive(sendData, timeOut: 8000)
        
        NSLog("send:%@",sendData.hex);
        NSLog("revice:%@",getData?.hex ?? "///");
        
        let byteStream = ByteStream(getData!)
        let prefix = byteStream.read(Data.self, count: 2)
        
        let length = byteStream.read(Data.self, count: 1)
        let raw = byteStream.read(Data.self, count: length.integer())
        let resCode = byteStream.read(Data.self, count: 2)
        let subffix = byteStream.read(Data.self, count: 2)
        
        //获取公钥
        //        let pkeyvalue =  String(data:raw ,encoding: String.Encoding.utf8)
        //        04b882ef84fa5154c659484ee177090c3a0ed0a1b7870bb24c1895b41dba28e1aba505fa113ace5de1f9e16c9b4a48134a3c6068e28df171b06b00e48fea142287
        NSLog("pkey:%@",raw.hex);
        
//        let pkey:PublicKey = PublicKey( bytes: raw, network: AppController.shared.network)
//
//        return pkey
        
        return raw
        
    }
    
//    func createAddress() -> AddressMessage {
//
//        let pkey = getPublicKey()
//
//        let result = AddressMessage()
////        result.prefix = prefix.hex
////        result.resCode = resCode.hex
//        result.address = pkey.toCashaddr()
//        NSLog("address:%@",result.address?.base58 ?? "");
//
//
//        return result
//    }
    
    func sign(signData:Data)->SignMessage{
        
        let blue = BluetoothLe.sharePkiCard()
        //btc
        var xorData = Data()
        xorData += Data.init(hex: "050200000000")!
//        let length:UInt32 = UInt32(signData.count)
//        xorData.append(length.littleEndian)
        xorData += signData.count.data
        xorData += signData
       
        let checknum = xorData.xor()
        
        var sendData = Data()
        sendData += Data.init(hex: "55aa")!
        sendData += xorData
        sendData += checknum.data
        sendData += Data.init(hex: "aa55")!
        
        let getData = blue?.sendReceive(sendData, timeOut: 15000)
        
        NSLog("send:%@",sendData.hex);
        NSLog("revice:%@",getData?.hex ?? "///");
        
        let byteStream = ByteStream(getData!)
        let prefix = byteStream.read(Data.self, count: 2)
        
        let length = byteStream.read(Data.self, count: 1)
        let hkeyCode = byteStream.read(Data.self, count: 1)
        let raw = byteStream.read(Data.self, count: length.integer())
        let resCode = byteStream.read(Data.self, count: 2)
        let subffix = byteStream.read(Data.self, count: 2)
        
        
        let result = SignMessage()
        result.prefix = prefix.hex
        result.resCode = resCode.hex
        result.type = hkeyCode.hex
        result.sign = raw
        NSLog("sign befor:%@",signData.hex);
        NSLog("sign after:%@",result.sign?.hex ?? "");
        
        return result
       
    }
    
    
}
