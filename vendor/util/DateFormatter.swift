//
//  DateFormatter.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/17.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import Foundation

struct DateFormatter {
    private static let fullDateFormatter: Foundation.DateFormatter = {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm"
        return dateFormatter
    }()
    
    static func fullDateString(from date: Date) -> String {
        return fullDateFormatter.string(from: date)
    }
}

