//
//  SignMessage.swift
//  BiweiWallet
//
//  Created by peak on 2018/9/20.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation

class SignMessage: HwResponse {
    
    var type:String?//硬件确认状态 00、01、02
    var sign:Data?
}
