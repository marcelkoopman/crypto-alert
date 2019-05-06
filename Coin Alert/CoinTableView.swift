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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
        let coin = self.itemsToLoad[indexPath.row]
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.textLabel?.text = coin.name + "/EUR €" + String(format:"%.2f",coin.euroPrice)
        cell.accessoryType = .detailButton
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    var tableView: UITableView = UITableView()
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
            print("Got prices")
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
        
        tableView.frame = CGRect(x:0, y:0, width:screenWidth, height:screenHeight)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        let background = #imageLiteral(resourceName: "Image")
        var imageView : UIImageView!
        imageView = UIImageView(frame: tableView.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = tableView.center
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.view.addSubview(tableView)
        print("Added subview")
    }
    
    func populateTable() {
        tableView.reloadData()
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
                DispatchQueue.main.async {
                    print("Reload view")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToLoad.count
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let coin = itemsToLoad[indexPath.row]
        self.showUpdatedAlert(coin:coin)
    }
    
    func showUpdatedAlert(coin: Coin) {
        let message = coin.name + "/EUR €" + String(format:"%.2f",coin.euroPrice) + " @" + coin.timeStamp
        let alert = UIAlertController(title: "Price updated on", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
}
