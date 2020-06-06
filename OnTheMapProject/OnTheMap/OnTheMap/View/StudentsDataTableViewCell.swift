//
//  StudentsDataTableViewCell.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 03.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class StudentsDataTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaURLLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
