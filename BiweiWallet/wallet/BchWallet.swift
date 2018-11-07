//
//  BtcWallet.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/16.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation
import BitcoinKit
import KeychainAccess

class  BchWallet: WalletProtocol {
    
    var wallet: HDWallet!
    var network:Network!
    let keySeed = "bch-seed"
    func initWallet(network:WalletNetwork = .test){
        
        
        var n = Network.mainnet
        
        if network == .test {
            n = Network.testnet
        }
        self.network = n
        
        let keychain = Keychain()
        if let seed = keychain[data: keySeed] {
            self.wallet = HDWallet(seed: seed, network: n)
        }
        
    }
    
    func importWallet(mnemonic: [String]) {
        let seed = Mnemonic.seed(mnemonic: mnemonic)
        let keychain = Keychain()
        keychain[data: keySeed] = seed
        self.wallet = HDWallet(seed: seed, network: network)
    }
    
    func getAddress(index:UInt32) ->String {
        let externalIndex = index
        let address = try! wallet.receiveAddress(index: externalIndex)
        return address.cashaddr
        
    }
    
}
