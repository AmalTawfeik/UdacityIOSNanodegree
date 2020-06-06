//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Amal Tawfeik on 22.04.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    func setCellData(_ meme: Meme) {
        memeImageView.image = meme.memedImage
    }
}
