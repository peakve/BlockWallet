//
//  HomeViewController.swift
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

import UIKit
import BitcoinKit

class HomeViewController: UITableViewController, PeerGroupDelegate {
    var peerGroup: PeerGroup?
    var payments = [Payment]()
    
    var myAddress:Address?

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var syncButton: UIButton!
    
    var wallet :BtcWallet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.wallet = AppController.shared.wallet?.getWallet(key: "BTC") as! BtcWallet
        
        NotificationCenter.default.addObserver(self, selector: #selector(walletChanged(notification:)), name: Notification.Name.AppController.walletChanged, object: nil)
        //00000000000288d9a219419d0607fb67cc324d4b6d2945ca81eaa5e739fab81e
       let hash =  Data(Data(hex: "494b0a9dc52f3fd20efde839970f859b3f96206cb389033343e3040000000000")!.reversed())
        
        NSLog("%@", hash.hex)
        
       
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "transactionCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBalance()
    }
    
    @IBAction func sync(_ sender: UIButton) {
        if let peerGroup = peerGroup {
            print("stop sync")
            peerGroup.stop()
            syncButton.setTitle("Sync", for: .normal)
        } else {
            print("start sync")
            let blockStore = try! SQLiteBlockStore.default(network: self.wallet.network)
            let blockChain = BlockChain(network: self.wallet.network, blockStore: blockStore)

            peerGroup = PeerGroup(blockChain: blockChain)
            peerGroup?.delegate = self

            for address in usedAddresses() {
                if let publicKey = address.publicKey {
                    peerGroup?.addFilter(publicKey)
                }
                peerGroup?.addFilter(address.data)
            }

            peerGroup?.start()
            syncButton.setTitle("Stop", for: .normal)
        }
    }
    
    @objc
    func walletChanged(notification: Notification) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transactions"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
//        var cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath)
//
//        if cell == nil {
//            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "transactionCell")
//        }

        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }

        
        let payment = payments[indexPath.row]
        let decimal = Decimal(payment.amount)
        let amountCoinValue = decimal / Decimal(100000000)
        let txid = payment.txid.hex
        cell?.textLabel?.text = "\(amountCoinValue) BTC"
        cell?.detailTextLabel?.text = txid
        print(txid, amountCoinValue, payment.from, payment.to)

        return cell!
    }

    func peerGroupDidStop(_ peerGroup: PeerGroup) {
        peerGroup.delegate = nil
        self.peerGroup = nil
    }
    
    func peerGroupDidReceiveTransaction(_ peerGroup: PeerGroup) {
        updateBalance()
    }

    private func usedAddresses() -> [Address] {
        var addresses = [Address]()
        
        if AppController.shared.isHardWallet {
           //hiva
            if let myaddr = self.myAddress {
                addresses.append(myaddr)
            }else {
                
                let pkeyBytes = HardWallet.shared.getPublicKey()
                let pkey:PublicKey = PublicKey( bytes: pkeyBytes, network: wallet.network)
                let addr = pkey.toCashaddr().base58 as! Address
                //            let address = try! AddressFactory.create(addr!)
                addresses.append(addr)
                
                self.myAddress = addr
            }
      
        }else {
            guard let w = AppController.shared.wallet else {
                return []
            }
            for index in 0..<(AppController.shared.externalIndex + 20) {
                if let address = try? self.wallet.wallet.receiveAddress(index: index) {
                    addresses.append(address)
                }
            }
            for index in 0..<(AppController.shared.internalIndex + 20) {
                if let address = try? self.wallet.wallet.changeAddress(index: index) {
                    addresses.append(address)
                }
            }
        }
        return addresses
    }
    
    func transactions() -> [Payment] {
        let blockStore = try! SQLiteBlockStore.default(network: self.wallet.network)

        var payments = [Payment]()
        for address in usedAddresses() {
            let newPayments = try! blockStore.transactions(address: address)
            for p in newPayments where !payments.contains(p){
                payments.append(p)
            }
        }
        return payments
    }

    private func updateBalance() {
        let blockStore = try! SQLiteBlockStore.default(network: self.wallet.network)

        var balance: Int64 = 0
        for address in usedAddresses() {
            balance += try! blockStore.calculateBalance(address: address)
        }

        let decimal = Decimal(balance)
        balanceLabel.text = "\(decimal / Decimal(100000000)) BTC"

        payments = transactions()
        tableView.reloadData()
    }
    
}
