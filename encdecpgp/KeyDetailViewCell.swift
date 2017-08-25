//
//  KeyDetailViewCell.swift
//  encdecpgp
//
//  Created by Darshil Chanpura on 23/08/17.
//  Copyright © 2017 Darshil Chanpura. All rights reserved.
//

import UIKit

class KeyDetailViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet var keyId: UILabel!
    @IBOutlet var keyFingerPrint: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
