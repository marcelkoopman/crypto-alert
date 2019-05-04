//
//  BitcoinService.swift
//  Coin Alert
//
//  Created by Marcel Koopman on 03/05/2019.
//  Copyright © 2019 Marcel Koopman. All rights reserved.
//

import Foundation

class BitcoinService: NSObject, URLSessionDelegate, CoinService {
    
    let euroPriceUrl = "https://min-api.cryptocompare.com/data/price"
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    }()
    
    func getEuroPrice(completionHandler: @escaping (Coin?, Error?) -> Void) {
        
        guard var components = URLComponents(string: euroPriceUrl) else {return}
        components.queryItems = [
            URLQueryItem(name: "fsym", value: "BTC"),
            URLQueryItem(name: "tsyms", value: "EUR")
        ]
        
        guard let url = components.url else {return}
        //generate request
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error=error {
                completionHandler(nil, error)
            }
            guard let data = data else { return }
            self.parseJSON(data: data, completionHandler: completionHandler)
        }
        task.resume()
    }
    
    private func parseJSON(data:Data, completionHandler: @escaping (Coin?, Error?) -> Void) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let price = (json["EUR"] as? Double) {
                   let coin = Coin(name: "BTC", euroPrice: price)
                   completionHandler(coin,nil)
                }
            } else {
                completionHandler(nil, nil)
            }
        } catch let error as NSError {
            completionHandler(nil, error)
            return
        }
    }
}
