//
//  ViewController.swift
//  encdecpgp
//
//  Created by Darshil Chanpura on 19/08/17.
//  Copyright © 2017 Darshil Chanpura. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    //MARK: Properties
    
    @IBOutlet weak var textLabel: UIStackView!

    @IBOutlet weak var keyNameTextField: UITextField!
    
    @IBOutlet weak var keyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CryptoUtils.initializeKeyringFromFile()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK: Actions
    
    @IBAction func addKeyAction(_ sender: UIButton) {
        let isAdded:Bool = CryptoUtils.addKey(keyNameTextField.text!, keyText: keyTextView.text);
        if (isAdded) {
            print("added")
        }
    }
    
    
    //MARK: UITextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    

    
}
