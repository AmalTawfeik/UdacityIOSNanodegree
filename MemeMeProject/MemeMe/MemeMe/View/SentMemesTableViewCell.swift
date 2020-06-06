//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Amal Tawfeik on 23.04.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCellData(_ meme: Meme) {
        memeImageView.image = meme.memedImage
        memeLabel.text = meme.topText + "..." + meme.bottomText
    }
}
