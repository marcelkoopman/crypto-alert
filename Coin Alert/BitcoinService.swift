//
//  BitcoinService.swift
//  Coin Alert
//
//  Created by Marcel Koopman on 03/05/2019.
//  Copyright © 2019 Marcel Koopman. All rights reserved.
//

import Foundation

class BitcoinService: NSObject, URLSessionDelegate, CoinService {
    
    let coinDeskUrl = "https://api.coindesk.com/v1/bpi/currentprice/EUR.json"
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    }()
    
    func getEuroPrice(completionHandler: @escaping (Coin?, Error?) -> Void) {
        let url = URL(string: coinDeskUrl)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            //print(String(data: data, encoding: .utf8)!)
            self.parseJSON(data: data, completionHandler: completionHandler)
        }
        task.resume()
    }
    
    private func parseJSON(data:Data, completionHandler: @escaping (Coin?, Error?) -> Void) {
        do {
            let bpi = try JSONDecoder().decode(BitcoinPriceIndex.self, from: data)
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .decimal
            if let rate = formatter.number(from: bpi.bpi.EUR.rate) {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                let currentDateTime = Date()
                let timeStamp = formatter.string(from: currentDateTime)
                let coin = Coin(name: "BTC", euroPrice: rate.doubleValue, timeStamp: timeStamp)
                completionHandler(coin, nil)
            } else {
                print(bpi.bpi.EUR.rate)
            }
        } catch let error as NSError {
            completionHandler(nil, error)
            return
        }
    }
}
