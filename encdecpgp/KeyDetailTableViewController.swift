//
//  KeyDetailTableViewController.swift
//  encdecpgp
//
//  Created by Darshil Chanpura on 23/08/17.
//  Copyright © 2017 Darshil Chanpura. All rights reserved.
//

import UIKit
import os.log

class KeyDetailTableViewController: UITableViewController {
    //MARK: Properties
    var keyDetails = [KeyDetail]()
    
    //MARK: Private Methods
    
    private func loadSampleKeys() {
        keyDetails = CryptoUtils.getPublicKeys()
        
    }
    
    private func loadKeys() -> [KeyDetail]? {
        os_log("Loading Keys...", log: OSLog.default, type: .debug)
        return NSKeyedUnarchiver.unarchiveObject(withFile: KeyDetail.ArchiveURL.path) as? [KeyDetail]
    }
    
    
    
    private func saveKeyDetails() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(keyDetails, toFile: KeyDetail.ArchiveURL.path)
        
        
        if isSuccessfulSave {
            os_log("keys successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save keys...", log: OSLog.default, type: .error)
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        //        CryptoUtils.initializeKeyringFromFile()
        if let savedKeys = loadKeys() {
            keyDetails += savedKeys
        } else {
            //            loadSampleKeys()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyDetails.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "KeyDetailTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? KeyDetailTableViewCell  else {
            fatalError("The dequeued cell is not an instance of KeyDetailTableViewCell.")
        }
        let keyDetail = keyDetails[indexPath.row]
        
        // configuring the cell
        cell.keyIdLabel.text = keyDetail.keyId
        cell.keyUserIdLabel.text = keyDetail.keyUsers.first?.userID
        return cell
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            keyDetails.remove(at: indexPath.row)
            saveKeyDetails()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK: Actions
    
    @IBAction func unwindToKeyDetailList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? KeyDetailViewController, let keyDetail = sourceViewController.keyDetail
        {
            let message = sourceViewController.message
            if message.isEmpty {
                
                // these are from the KeyDetailViewController
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    // Needed to be checked.
                    keyDetails[selectedIndexPath.row] = keyDetail
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    let newIndexPath = IndexPath(row: keyDetails.count, section: 0)
                    
                    keyDetails.append(keyDetail)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
                saveKeyDetails()
            } else {
                os_log("message is not empty", log: OSLog.default, type: .debug)
            }
        }
        
    }
}
