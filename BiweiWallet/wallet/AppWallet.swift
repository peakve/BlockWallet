//
//  AppWallet.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/16.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation
import KeychainAccess

class AppWallet  {
    
    var wallets:Dictionary<String,WalletProtocol> = [:]
     let keySeed = "isHasSeed"
    func initWallet(params:Dictionary<String, WalletNetwork>) ->  [WalletProtocol] {
        
        let ws = params.compactMap({ (item) -> WalletProtocol? in
            
            let (key, value) = item
            
            switch key {
                
            case "BTC":
                let w =  BtcWallet()
                w.initWallet(network: value)
                wallets[key] = w
                return w
            case "BCH":
                let w =  BchWallet()
                w.initWallet(network: value)
                wallets[key] = w
                return w
            case "ETH":
                let w =  EthWallet()
                w.initWallet(network: value)
                wallets[key] = w
                return w
            default:
                return nil
            }
        })
        
        return ws
    }
    
    func importWallet(mnemonic: [String]){ 
        for dic in self.wallets {
            dic.value.importWallet(mnemonic: mnemonic)
        }
        
        saveSeed(seed: keySeed.data(using: String.Encoding.utf8)!)
    }
    
    func getWallet(key:String ) -> WalletProtocol?{
        
        return self.wallets[key]
    }
    
    func saveSeed(seed:Data){
        
        let keychain = Keychain()
        keychain[data: keySeed] = seed
    }
    
    func isCreateSeed() ->Bool{
        
        let keychain = Keychain()
        if let _ = keychain[data: keySeed] {
            return true
        }
        return false
    }
    
}
