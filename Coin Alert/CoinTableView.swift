//
//  CoinTableView.swift
//  Coin Alert
//
//  Created by Marcel Koopman on 04/05/2019.
//  Copyright © 2019 Marcel Koopman. All rights reserved.
//

import UIKit

class CoinTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var bitcoinService = BitcoinService()
    let cellId = "Cell"
    var lastPrice:Double = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
        let coin = self.itemsToLoad[indexPath.row]
        let currentPrice = coin.euroPrice
        if (lastPrice == Double(0)) {
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            cell.textLabel?.text = coin.name + "/EUR €" + String(format:"%.2f",currentPrice) + " @ " + coin.timeStamp
        } else {
            let diff = currentPrice - lastPrice
            if (diff > 0) {
                cell.backgroundColor = UIColor.green
                cell.textLabel?.text = coin.name + "/EUR €" + String(format:"%.2f",currentPrice) + " @ " + coin.timeStamp + " ↑ " + String(diff)
            } else if (diff < 0){
                cell.backgroundColor = UIColor.red
                cell.textLabel?.text = coin.name + "/EUR €" + String(format:"%.2f",currentPrice) + " @ " + coin.timeStamp + " ↓ " + String(diff)
            } else {
                cell.backgroundColor = UIColor.blue
                cell.textLabel?.text = coin.name + "/EUR €" + String(format:"%.2f",currentPrice) + " @ " + coin.timeStamp
            }
        }
        lastPrice = currentPrice
        cell.accessoryType = .detailButton
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    var myTableView: UITableView = UITableView()
    var itemsToLoad: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    @objc
    func runTimedCode() {
        DispatchQueue.global(qos: .background).async {
            self.getPrices()
            DispatchQueue.main.async {
                print("Reload view")
                self.myTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning")
        itemsToLoad = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        myTableView.frame = CGRect(x:0, y:0, width:screenWidth, height:screenHeight)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        let background = #imageLiteral(resourceName: "Image")
        var imageView : UIImageView!
        imageView = UIImageView(frame: myTableView.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = myTableView.center
        myTableView.backgroundView = imageView
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.view.addSubview(myTableView)
    }
    
    func populateTable() {
        myTableView.reloadData()
    }
    
    func updatePrices(index: Int) {
        bitcoinService.getEuroPrice() {
            (coin, error) in
            if error != nil {
                //deal with error
                print("ERROR: "+error.debugDescription)
                return
            } else if let coin = coin {
                self.itemsToLoad[index] = coin
            }
        }
    }
    
    func getPrices() {
        bitcoinService.getEuroPrice() {
            (coin, error) in
            if error != nil {
                //deal with error
                print("ERROR: "+error.debugDescription)
                return
            } else if let coin = coin {
                self.itemsToLoad.append(coin)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToLoad.count
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.updatePrices(index: indexPath.row)
        tableView.reloadData()
    }
    
    
}
