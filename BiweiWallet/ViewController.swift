////
////  ViewController.swift
////  BiweiWallet
////
////  Created by peak on 2018/9/14.
////  Copyright © 2018年 51bb8. All rights reserved.
////
//
//import UIKit
//import BitcoinKit
//
//class ViewController: UIViewController {
//
//     var wallet : HDWallet!
//     var peerGroup: PeerGroup?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//       
//        //
////        createWallet()
//        
//        //mhXhY919yLVtH9SGFUtj5dQav56Cx9u8oK
//        getLocalWallet()
//        
////        sendToSomeAddress("mqaGzWeTNUKma2TpnL8Uw3Sa3q6V6vEDBM", 1000000)
//       
//        
//        
//        
//    }
//    
//     //1\创建钱包
//    func createWallet(){
//        
//        do {
//            //助记词
////            ["inject","close","steel","amateur","rigid","roast","lift","almost","hurry","that","surge","gadget"]
//            let mnemonic:[String] = try Mnemonic.generate()
//            for (idx,m) in mnemonic.enumerated() {
//                NSLog("%d:%@",idx,m)
//            }
//            
//            //1111111
//            //wallet地址：bitcoin:
//            //mhXhY919yLVtH9SGFUtj5dQav56Cx9u8oK
//            //qqgcsmenk6pyxdtdzxx6y3hav8hxkhryu5660qp8fg
//            
//            //22222
//            //mqaGzWeTNUKma2TpnL8Uw3Sa3q6V6vEDBM
//            
//            let seed = Mnemonic.seed(mnemonic: mnemonic)
//            let network = Network.testnetBTC
//            
//            let wallet = HDWallet(seed: seed, network: network)
//            
//            //钱包地址
//            let address =  try wallet.receiveAddress()
//            //from Testnet Cashaddr
//            //wallet地址：bitcoin:qqtpgk20c24d3u6y8uf8r9cz5cv3es6lmydn4dq5gu
//            NSLog("wallet地址：%@", address.cashaddr)
//            
//            // from Base58 format
//            //wallet地址：mhXhY919yLVtH9SGFUtj5dQav56Cx9u8oK
//            NSLog("wallet地址：%@", address.base58)
//            
//            //            let ad = try AddressFactory.create(address.cashaddr)
//            
//            
//        } catch  {
//            NSLog("%@", "error")
//        }
//    }
//    
//    //初始化钱包
//    func getLocalWallet(){
//        
//        //1\创建钱包
//        do {
//            //助记词
//            let mnemonic = ["inject","close","steel","amateur","rigid","roast","lift","almost","hurry","that","surge","gadget"]
////            let mnemonic:[String] = try Mnemonic.generate()
//            for (idx,m) in mnemonic.enumerated() {
//                NSLog("%d:%@",idx,m)
//            }
//            
//            //wallet地址：bitcoin:
//            //            mpM6hrps7y4t3aCJcrQo5s1Rsi5fZjK6U2
//            //            qqgcsmenk6pyxdtdzxx6y3hav8hxkhryu5660qp8fg
//            
//            let seed = Mnemonic.seed(mnemonic: mnemonic)
//            let network = Network.testnetBTC
//            
//            self.wallet = HDWallet(seed: seed, network: network)
//            
//            //钱包地址
//            let address =  try wallet.receiveAddress()
//            //from Testnet Cashaddr
//            //wallet地址：bitcoin:qqtpgk20c24d3u6y8uf8r9cz5cv3es6lmydn4dq5gu
//            NSLog("wallet地址：%@", address.cashaddr)
//            
//            // from Base58 format
//            //wallet地址：mhXhY919yLVtH9SGFUtj5dQav56Cx9u8oK
//            NSLog("wallet地址：%@,banance:%d", address.base58,wallet.balance)
//
//            
////          self.showBalance()
////            let blockStore = try! SQLiteBlockStore.default(network: AppController.shared.network)
////
////
////            //同步
////            print("start sync")
////            let blockChain = BlockChain(network: network, blockStore: blockStore)
////            peerGroup = PeerGroup(blockChain: blockChain)
////            peerGroup?.delegate = self
////
////
////            for address in usedAddresses() {
////                if let publicKey = address.publicKey {
////                    peerGroup?.addFilter(publicKey)
////                }
////                peerGroup?.addFilter(address.data)
////            }
////
////            peerGroup?.start()
////
//            
//        } catch   {
//            NSLog("error:%@",error.localizedDescription)
//        }
//        
//    }
//    
//    
//    func sendToSomeAddress(_ addr:String,_ amount: Int64){
//        //转账
//        let toAddress: Address = try! AddressFactory.create(addr)
//        let changeAddress: Address = try! self.wallet.changeAddress()
//        
//        var payments = [Payment]()
//        //获取未消费
////        let blockStore = try! SQLiteBlockStore.default(network: AppController.shared.network)
////
//////         payments.append(contentsOf: try! blockStore.unspentTransactions(address: self.wallet.receiveAddress()))
//////        payments.append(contentsOf: try! blockStore.unspentTransactions(address: self.wallet.changeAddress()))
////        for address in usedAddresses() {
////            payments.append(contentsOf: try! blockStore.unspentTransactions(address: address))
////        }
////        
////        var utxos: [UnspentTransaction] = []
////        for p in payments {
////            let value = p.amount
////            let lockScript = Script.buildPublicKeyHashOut(pubKeyHash: p.to.data)
////            let txHash = Data(p.txid.reversed())
////            let txIndex = UInt32(p.index)
////            print(p.txid.hex, txIndex, lockScript.hex, value)
////            
////            let unspentOutput = TransactionOutput(value: value, lockingScript: lockScript)
////            let unspentOutpoint = TransactionOutPoint(hash: txHash, index: txIndex)
////            let utxo = UnspentTransaction(output: unspentOutput, outpoint: unspentOutpoint)
////            utxos.append(utxo)
////        }
////        
////        let unsignedTx = self.createUnsignedTx(toAddress: toAddress, amount: amount, changeAddress: changeAddress, utxos: utxos)
////        
//////        var keys = [PrivateKey]()
//////        keys.append(try! self.wallet.privateKey(index: 0))
//////        keys.append(try! self.wallet.changePrivateKey(index: 0))
////       
////        let signedTx = self.signTx(unsignedTx: unsignedTx, keys: usedKeys())
////        
////        peerGroup?.sendTransaction(transaction: signedTx)
//  
//    }
//    
//    private func usedKeys() -> [PrivateKey] {
//        var keys = [PrivateKey]()
////        guard let wallet = AppController.shared.wallet else {
////            return []
////        }
//        // Receive key
//        for index in 0..<(0 + 20) {
//            if let key = try? wallet.privateKey(index: UInt32(index)) {
//                keys.append(key)
//            }
//        }
//        // Change key
//        for index in 0..<(0 + 20) {
//            if let key = try? wallet.changePrivateKey(index: UInt32(index)) {
//                keys.append(key)
//            }
//        }
//        
//        return keys
//    }
//    
//    private func usedAddresses() -> [Address] {
//        var addresses = [Address]()
////        guard let wallet = AppController.shared.wallet else {
////            return []
////        }
//        for index in 0..<(0 + 20) {
//            if let address = try? wallet.receiveAddress(index: UInt32(index)) {
//                addresses.append(address)
//            }
//        }
//        for index in 0..<(0 + 20) {
//            if let address = try? wallet.changeAddress(index: UInt32(index)) {
//                addresses.append(address)
//            }
//        }
//        return addresses
//    }
//    
//    public func selectTx(from utxos: [UnspentTransaction], amount: Int64) -> (utxos: [UnspentTransaction], fee: Int64) {
//        //TODO
//        return (utxos, 500)
//    }
//
//    
//    public func createUnsignedTx(toAddress: Address, amount: Int64, changeAddress: Address, utxos: [UnspentTransaction]) -> UnsignedTransaction {
//        let (utxos, fee) = self.selectTx(from: utxos, amount: amount)
//        let totalAmount: Int64 = utxos.reduce(0) { $0 + $1.output.value }
//        let change: Int64 = totalAmount - amount - fee
//        
//        let toPubKeyHash: Data = toAddress.data
//        let changePubkeyHash: Data = changeAddress.data
//        
//        let lockingScriptTo = Script.buildPublicKeyHashOut(pubKeyHash: toPubKeyHash)
//        let lockingScriptChange = Script.buildPublicKeyHashOut(pubKeyHash: changePubkeyHash)
//        
//        let toOutput = TransactionOutput(value: amount, lockingScript: lockingScriptTo)
//        let changeOutput = TransactionOutput(value: change, lockingScript: lockingScriptChange)
//        
//        // この後、signatureScriptやsequenceは更新される
//        let unsignedInputs = utxos.map { TransactionInput(previousOutput: $0.outpoint, signatureScript: Data(), sequence: UInt32.max) }
//        let tx = Transaction(version: 1, inputs: unsignedInputs, outputs: [toOutput, changeOutput], lockTime: 0)
//        return UnsignedTransaction(tx: tx, utxos: utxos)
//    }
//    
//    public func signTx(unsignedTx: UnsignedTransaction, keys: [PrivateKey]) -> Transaction {
//        var inputsToSign = unsignedTx.tx.inputs
//        var transactionToSign: Transaction {
//            return Transaction(version: unsignedTx.tx.version, inputs: inputsToSign, outputs: unsignedTx.tx.outputs, lockTime: unsignedTx.tx.lockTime)
//        }
//        
//        // Signing
//        let hashType = SighashType.BTC.ALL
//        for (i, utxo) in unsignedTx.utxos.enumerated() {
//            let pubkeyHash: Data = Script.getPublicKeyHash(from: utxo.output.lockingScript)
//            
//            let keysOfUtxo: [PrivateKey] = keys.filter { $0.publicKey().pubkeyHash == pubkeyHash }
//            guard let key = keysOfUtxo.first else {
//                print("No keys to this txout : \(utxo.output.value)")
//                continue
//            }
//            print("Value of signing txout : \(utxo.output.value)")
//            
//            let sighash: Data = transactionToSign.signatureHash(for: utxo.output, inputIndex: i, hashType: hashType)
//            let signature: Data = try! Crypto.sign(sighash, privateKey: key)
//            let txin = inputsToSign[i]
//            let pubkey = key.publicKey()
//            
//            let unlockingScript = Script.buildPublicKeyUnlockingScript(signature: signature, pubkey: pubkey, hashType: hashType)
//            
//            // TODO: sequence 更新
//            inputsToSign[i] = TransactionInput(previousOutput: txin.previousOutput, signatureScript: unlockingScript, sequence: txin.sequence)
//        }
//        return transactionToSign
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
//extension ViewController : PeerGroupDelegate {
//    
//    func peerGroupDidStop(_ peerGroup: PeerGroup) {
//        peerGroup.delegate = nil
//        self.peerGroup = nil
//    }
//    
//    func peerGroupDidReceiveTransaction(_ peerGroup: PeerGroup) {
//        
//        showBalance()
//    }
//    
//    func showBalance(){
//        
//      
//        //重新更新获取
////        let blockStore = try! SQLiteBlockStore.default(network: AppController.shared.network)
////
////        //        let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
////        //
////        //          let blockStore =   try! SQLiteBlockStore(file: cachesDir.appendingPathComponent("blockchain.sqlite"),network: Network.testnetBTC)
////        //        let address = try! self.wallet.receiveAddress()
////        //        let balance: Int64 = try! blockStore.calculateBalance(address: address)
////        
////        
////        var balance: Int64 = 0
////        for address in usedAddresses() {
////            balance += try! blockStore.calculateBalance(address: address)
////        }
////        
////        NSLog(">>>>banance>>>> %.8f BTC",Double(balance)/Double(100000000))
//        
//    }
//
//    
//}
//
