//
//  SendEthViewController.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/17.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import UIKit
import EthereumKit

class SendEthViewController: UIViewController {
    
    @IBOutlet weak var toAddress:UITextField!
    @IBOutlet weak var ether:UITextField!
    @IBOutlet weak var btnSend:UIButton!
    
    var wallet :EthWallet!

    override func viewDidLoad() {
        super.viewDidLoad()

           self.wallet = AppController.shared.wallet?.getWallet(key: "ETH") as! EthWallet
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func sendConfirm(_ sender: Any) {
        //TODO send
        //0x48fa2f2fec29cffcadac8900f1f12cbd35fb946c
        //0x48Fa2f2fEc29CffcADaC8900f1F12cBd35fb946c
        //nonce 是递增的？？
        let toAdrress = toAddress.text!
        let et = ether.text ?? "0.00001"
        let rawTransaction = RawTransaction(
            value: try! Converter.toWei(ether: et),
            to: toAdrress,
            gasPrice: Converter.toWei(GWei: 10),
            gasLimit: 21000,
            nonce: 1
        )
        
        
        let tx = try! self.wallet.wallet.sign(rawTransaction: rawTransaction)
        self.wallet.geth?.sendRawTransaction(rawTransaction: tx) { result in
            // Do something...
            NSLog("%@", "sendRawTransaction")
            
            switch result {
            case .success(let object):
                NSLog("txhash:%@", object.id)
                
                let alert = UIAlertController(title: "转账成功", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                    action in
                    print("点击了确定")
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            case .failure(let object):
                NSLog("%@", "bb")
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
