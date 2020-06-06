//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 02.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

private let reuseIdentifier = "StudentsDataTableViewCell"

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var studentsLocationsData = [StudentsDataModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getStudentsLocationsData()
    }
    
    // MARK: UITableViewDataSource Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocationsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! StudentsDataTableViewCell
        let student = studentsLocationsData[indexPath.row]
        cell.nameLabel.text = "\(student.firstName) \(student.lastName)"
        cell.mediaURLLabel.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    // MARK: UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        if studentsLocationsData[indexPath.row].mediaURL != nil {
            app.openURL(URL(string: studentsLocationsData[indexPath.row].mediaURL)!)
        }
    }
    
    
    // MARK: IBAction Functions
    
    @IBAction func logoutUser(_ sender: Any) {
        OTMAuthClient.logout {success ,error  in
            guard success else {
                
                return
            }
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.loadAndSetRootWindow() // go to login
            }
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if(OTMUserDefaults.haveCurrentLocation()) {
            let alert = UIAlertController(title: "", message: OTMStrings.overwriteMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: OTMStrings.overwrite, style: .default){
                UIAlertAction in
                self.goToAddorEditLocation()
                
            })
            alert.addAction(UIAlertAction(title: OTMStrings.cancelButton, style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            goToAddorEditLocation()
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        getStudentsLocationsData()
    }
    
    // MARK: MY Own Functions
    
    func getStudentsLocationsData() {
        OTMDataClient.getStudentsData { (studentsLocationsData, error) in
            guard error == nil else {
                OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.loadingDataFaild, message: error?.localizedDescription ?? "")
                return
            }
            self.studentsLocationsData = studentsLocationsData!
            self.tableView.reloadData()
        }
    }
    
    func goToAddorEditLocation() {
        performSegue(withIdentifier: "segueToAddLocation", sender: nil)
    }

}
