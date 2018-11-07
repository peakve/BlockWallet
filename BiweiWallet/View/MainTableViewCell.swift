//
//  MainTableViewCell.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/16.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logo:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var balance:UILabel!
    @IBOutlet weak var rateBalance:UILabel!
    @IBOutlet weak var btnRevice:UIButton!
    @IBOutlet weak var btnSend:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layoutUI(){
        
        btnRevice.layer.cornerRadius = 5
        btnRevice.clipsToBounds = true
        btnRevice.setTitleColor(.white, for: .normal)
        btnRevice.backgroundColor = UIColor.init(hexString: "3ca316")
        btnSend.layer.cornerRadius = 5
        btnSend.clipsToBounds = true
        btnSend.backgroundColor = .red
        btnSend.setTitleColor(.white, for: .normal)
        
    }
    
    func setData(data:Symbol){
        
        name.text = data.en! + "(" + data.short! +  ")"
        logo.downloadedFrom(link: data.logo!)
        
    }

}
