//
//  MemeDetailsVC.swift
//  MemeMe
//
//  Created by Amal Tawfeik on 23.04.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeDetailsVC: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!

    var meme : Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let meme = meme {
            memeImageView.image = meme.memedImage
        }
    }
}
