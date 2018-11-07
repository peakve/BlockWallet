//
//  MainTableViewController.swift
//  BiweiWallet
//
//  Created by peak on 2018/10/16.
//  Copyright © 2018年 51bb8. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    
    var datas = [Symbol]()
    var selectData:Symbol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "币唯钱包"
        
        let s1 = Symbol()
        s1.short = "BTC"
        s1.en = "Bitcoin"
        s1.zh = "比特币"
        s1.logo = "https://www.awakenpay.com/bfile/file/290a7b90-aa03-4eed-b150-bea894c7a972"
        datas.append(s1)
        
        let s3 = Symbol()
        s3.short = "BCH"
        s3.en = "BitcoinCash"
        s3.zh = "比特现金"
        s3.logo = "https://www.51bb8.com/bfile/file/f50a1398-efbb-4df7-9ae7-54b7f704cf91"
        datas.append(s3)
        
        let s2 = Symbol()
        s2.short = "ETH"
        s2.en = "Ethereum"
        s2.zh = "以太坊"
        s2.logo = "https://www.awakenpay.com/bfile/file/fd0e876a-5662-466e-9a6b-5dfd4a2faa5c"
        datas.append(s2)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let w = AppController.shared.wallet,w.isCreateSeed() else {
            performSegue(withIdentifier: "createWallet", sender: self)
            return
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "maincellIdentifier", for: indexPath) as! MainTableViewCell

        let data = datas[indexPath.row]
        cell.setData(data: data)
        cell.btnRevice.tag = indexPath.row
        cell.btnSend.tag = indexPath.row
        cell.btnSend.addTarget(self, action: #selector(btnSendClick), for: .touchUpInside)

        return cell
    }
    
    @objc func  btnSendClick(sender:Any){
    
        //TODO
        let s = self.datas[(sender as! UIButton).tag]
        
        if "ETH" == s.short {
            performSegue(withIdentifier: "sendEth", sender: sender)
        }else {
            performSegue(withIdentifier: "sendSegue", sender: sender)
        }
    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.selectData = datas[indexPath.row]
        
//        performSegue(withIdentifier: "to" + self.selectData?.short! , sender: self)
        if "ETH" == self.selectData?.short {
            performSegue(withIdentifier: "toETH", sender: self)
        }else {
            performSegue(withIdentifier: "toBTC", sender: self)
        }
        
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        NSLog("prepare:%@", segue.identifier ?? "--")
     
       if segue.identifier!.isEqual("receiveSegue"){

          let s = self.datas[(sender as! UIButton).tag]
            let receivef = segue.destination as! ReceiveViewController;
             receivef.coin = s
        }
       else if segue.identifier!.isEqual("sendSegue"){
        
        
        
        }
 
    }
 

}
