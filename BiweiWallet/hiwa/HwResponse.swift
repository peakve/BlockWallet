//
//  HwResponse.swift
//  BiweiWallet
//
//  Created by peak on 2018/9/18.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation


class HwResponse {
    
    var prefix:String?
    var length:Int?
//    var data:Data?
    var resCode:String = "0000"
    
    
//    
//    let byteStream = ByteStream(getData!)
//    let prefix = byteStream.read(Data.self, count: 2)
//    
//    let length = byteStream.read(Data.self, count: 1)
//    let payload = byteStream.read(Data.self, count: length.integer())
//    let resCode = byteStream.read(Data.self, count: 2)
//    let subffix = byteStream.read(Data.self, count: 2)
    
    required init() {
        
    }
}
