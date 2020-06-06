//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Amal Tawfeik on 22.04.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionViewCell"

class SentMemesCollectionVC: UICollectionViewController {

    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memesList
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupColletcionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource Functions

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemesCollectionViewCell
        cell.setCellData(memes[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate Functions

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToMemeDetails", sender: indexPath.row)
    }
    
    // MARK: IBAction Functions
    
    @IBAction func addMeme(_ sender: Any) {
        performSegue(withIdentifier: "segueToAddMeme", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMemeDetails" {
            let memeDetailsVC = segue.destination as! MemeDetailsVC
            if let sender = sender as? Int {
                let selectedMeme = memes[sender]
                memeDetailsVC.meme = selectedMeme
            }
        }
    }
    
    // MARK: My Own Functions
    
    func setupColletcionViewFlowLayout() {
        let space:CGFloat = 2.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
}
