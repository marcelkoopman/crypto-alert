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
    
    init(name:String, euroPrice:Double) {
        self.name = name
        self.euroPrice = euroPrice
    }
}
