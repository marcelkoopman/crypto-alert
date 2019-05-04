//
//  CoinDeskInfo.swift
//  Coin Alert
//
//  Created by Marcel Koopman on 04/05/2019.
//  Copyright © 2019 Marcel Koopman. All rights reserved.
//

import Foundation

class BitcoinPriceIndex: Codable {
    var bpi:Bpi
}

struct Bpi: Codable {
    var EUR:EUR
}

struct EUR: Codable {
    var code:String
    var rate:String
}
