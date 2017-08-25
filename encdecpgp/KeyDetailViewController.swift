//
//  KeyDetailViewController.swift
//  encdecpgp
//
//  Created by Darshil Chanpura on 24/08/17.
//  Copyright © 2017 Darshil Chanpura. All rights reserved.
//

import UIKit
import os.log


class KeyDetailViewController: UIViewController, UITextViewDelegate {

    var keyDetail:KeyDetail?
    var message:String = ""

    
    //MARK: Properties
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var keyDetailInputTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyDetailInputTextView.delegate = self
        keyDetailInputTextView.layer.cornerRadius = 5
        keyDetailInputTextView.layer.borderColor = UIColor.lightGray.cgColor
        keyDetailInputTextView.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        updateSaveButtonState()
    }

    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Pass the selected object to the new view controller.
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let keyDetailDataString = keyDetailInputTextView.text ?? "";
        if let keyDetailData = Data(base64Encoded: keyDetailDataString), let aKeyDetail = KeyDetail(pgpKeyData: keyDetailData)
        {
            keyDetail = aKeyDetail
            return
        } else {
            let alert:UIAlertController = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
            os_log("Key cannot be decoded.", log: OSLog.default, type: .error)
            message = "Key cannot be decoded."
            alert.message = message
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            //        self.navigationController?.pushViewController(alert, animated: true)
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    
    
    // MARK: Text View Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveButton.isEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = keyDetailInputTextView.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
