//
//  EthWallet.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/16.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation
import EthereumKit
import KeychainAccess


class EthWallet:WalletProtocol {
    
    var wallet: Wallet!
    var network:Network!
    let keySeed = "eth-seed"
    
    var geth:Geth?
    
    func initWallet(network:WalletNetwork = .test){
        
        
        var n = Network.mainnet
        
        if network == .test {
            n = Network.ropsten
        }
        self.network = n
        
        let keychain = Keychain()
        if let seed = keychain[data: keySeed] {
         self.wallet = try! Wallet(seed: seed, network: n ,debugPrints:true)
        }
        
        var nodeEndpoint: String {
            switch network {
            case .main:
                return "https://mainnet.infura.io/z1sEfnzz0LLMsdYMX4PV"
            case .test:
                return "https://ropsten.infura.io/z1sEfnzz0LLMsdYMX4PV"
            }
        }
        
        var etherscanAPIKey: String {
            return "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7"
        }
        
        self.geth = Geth(configuration: Configuration(
            network: n,
            nodeEndpoint: nodeEndpoint,
            etherscanAPIKey: etherscanAPIKey,
            debugPrints: true
        ))
        
    }

    
    func importWallet(mnemonic: [String]) {
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        let keychain = Keychain()
        keychain[data: keySeed] = seed
        self.wallet = try! Wallet(seed: seed, network: network,debugPrints:true)
        
    }
    
    func getAddress(index:UInt32) ->String {
       
        return wallet.generateAddress()
        
    }
    
}
