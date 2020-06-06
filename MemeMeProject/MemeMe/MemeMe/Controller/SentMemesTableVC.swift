//
//  SentMemesTableVC.swift
//  MemeMe
//
//  Created by Amal Tawfeik on 22.04.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesTableViewCell"

class SentMemesTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memesList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource Functions

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! SentMemesTableViewCell
        cell.setCellData(memes[indexPath.row])
        return cell
    }
    
    // MARK: UITableViewDelegate Functions

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

}
