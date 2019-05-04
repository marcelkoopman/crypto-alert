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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = self.itemsToLoad[indexPath.row]
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    var myTableView: UITableView = UITableView()
    var itemsToLoad: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        myTableView.frame = CGRect(x:0, y:0, width:screenWidth, height:screenHeight)
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
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
        
        self.populateTable()
    }
    
    func populateTable() {
        self.updatePrices()
        myTableView.reloadData()
    }
    
    private func updatePrices() {
        bitcoinService.getEuroPrice() {
            (coin, error) in
            if error != nil {
                //deal with error
                print(error.debugDescription)
                return
            } else if let coin = coin {
                let name = coin.name
                let price = coin.euroPrice
                self.itemsToLoad.append(name + "/EUR €" + String(format:"%.2f",price))
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToLoad.count
    }
}
