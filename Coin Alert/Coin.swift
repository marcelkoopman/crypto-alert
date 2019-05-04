//
//  Coin.swift
//  Coin Alert
//
//  Created by Marcel Koopman on 03/05/2019.
//  Copyright © 2019 Marcel Koopman. All rights reserved.
//

import Foundation

struct Coin {
    var name:String
    var euroPrice:Double
    var timeStamp:String
    
    init(name:String, euroPrice:Double, timeStamp:String) {
        self.name = name
        self.euroPrice = euroPrice
        self.timeStamp = timeStamp
    }
}
