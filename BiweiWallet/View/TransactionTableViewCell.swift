//
//  TransactionTableViewCell.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/17.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import UIKit
import EthereumKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txHash:UILabel!
    @IBOutlet weak var timeStamp:UILabel!
    @IBOutlet weak var from:UILabel!
    @IBOutlet weak var to:UILabel!
    @IBOutlet weak var gas:UILabel!
    @IBOutlet weak var value:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:Transaction){
        
        
        value.text = "\( try! data.balance.ether()) ETH"
//        gas.text = "fee: \( try! Converter.toEther(wei: BInt(number: data.gas, withBase: 10)!)  ) ETH"
         gas.text = "fee: \(  data.gas ) wei"
        from.text = data.from
        to.text = data.to
        txHash.text = data.hash
        timeStamp.text = DateFormatter.fullDateString(from: Date(timeIntervalSince1970: TimeInterval(Int64(data.timeStamp)!)))
        
        
    }
    
}
