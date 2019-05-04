//
//  CoinService.swift
//  Coin Alert
//
//  Created by Marcel Koopman on 03/05/2019.
//  Copyright © 2019 Marcel Koopman. All rights reserved.
//

import Foundation

protocol CoinService {
    func getEuroPrice(completionHandler: @escaping (Coin?, Error?) -> Void)
}
