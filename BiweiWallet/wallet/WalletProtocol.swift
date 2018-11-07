//
//  WalletProtocol.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/16.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation

enum WalletNetwork : Int {
    case main = 0  //主链
    case test = 1 //测试链
}

protocol WalletProtocol {
    
      func initWallet(network:WalletNetwork)
    
      func importWallet(mnemonic: [String])
    
      func getAddress(index:UInt32) ->String
}
