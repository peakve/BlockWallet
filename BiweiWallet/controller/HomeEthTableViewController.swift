//
//  HomeEthTableViewController.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/17.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import UIKit
import EthereumKit

class HomeEthTableViewController: UITableViewController {

     var wallet :EthWallet!
    var datas = [Transaction] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wallet = AppController.shared.wallet?.getWallet(key: "ETH") as! EthWallet
        
        //TODO eg. ETH
//        if "ETH" == coin.short
        let address = self.wallet.getAddress(index: AppController.shared.externalIndex)
        self.wallet.geth?.getBalance(of: address , completionHandler: { (result) in
            NSLog("%@", result.description)
            switch result {
            case .success(let object):
                NSLog("%@", "aa")
                
                self.title = "\( try! Converter.toEther(wei: object.wei) ) ETH"
            case .failure(let object):
                NSLog("%@", "bb")
            }
            
        })
        
        self.wallet.geth?.getTransactions(address: address , completionHandler: { (result) in
            NSLog("%@", result.description)
            switch result {
            case .success(let object):
                NSLog("%@", "aa")
                
                var ds = object.elements
                
                self.datas += ds.reversed()
                self.tableView.reloadData()
            case .failure(let object):
                NSLog("%@", "bb")
            }
            
        })
        
        
        
       
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.datas.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ethTransTC", for: indexPath) as! TransactionTableViewCell
        
        let data = datas[indexPath.row]
        cell.setData(data: data)
       

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
