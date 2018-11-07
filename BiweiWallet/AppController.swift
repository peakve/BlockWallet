//
//  AppController.swift
//
//  Copyright © 2018 Kishikawa Katsumi
//  Copyright © 2018 BitcoinKit developers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import BitcoinKit
import KeychainAccess

import EthereumKit

class AppController {
    static let shared = AppController()
    
    let wallet : AppWallet?

//    let network = Network.testnetBTC
    
//    let network = ["BTC":Network.testnetBTC,"ETH":Net]
    
    //是否硬件钱包
    let isHardWallet = false

//    private(set) var wallet: HDWallet? {
//        didSet {
//            NotificationCenter.default.post(name: Notification.Name.AppController.walletChanged, object: self)
//        }
//    }
    

    var internalIndex: UInt32 {
        set {
            UserDefaults.standard.set(Int(newValue), forKey: #function)
        }
        get {
            return UInt32(UserDefaults.standard.integer(forKey: #function))
        }
    }
    var externalIndex: UInt32 {
        set {
            UserDefaults.standard.set(Int(newValue), forKey: #function)
        }
        get {
            return UInt32(UserDefaults.standard.integer(forKey: #function))
        }
    }

    private init() {
        self.wallet = AppWallet()
        let p = ["BTC":WalletNetwork.test,"BCH":WalletNetwork.test,"ETH":WalletNetwork.test]
        self.wallet?.initWallet(params: p)
    }
    

    func importWallet(mnemonic: [String]) {
        self.wallet?.importWallet(mnemonic: mnemonic)
    }
}

extension Notification.Name {
    struct AppController {
        static let walletChanged = Notification.Name("AppController.walletChanged")
        
    }
}

