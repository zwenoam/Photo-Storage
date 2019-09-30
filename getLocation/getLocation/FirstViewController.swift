//
//  FirstViewController.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 8/15/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation
import Photos
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIImagePickerControllerDelegate{
    

    @IBOutlet weak var location: UITableView!
    @IBOutlet weak var addPhoto: UITableView!
    @IBOutlet weak var category: UITableView!
    @IBOutlet weak var textView: UITextView!
    var context: NSManagedObjectContext?
    var receivedCategory: String = ""
    
    var receivedLocation: CLLocation!
    var geocoder = CLGeocoder()
    let date = Date()
    let calendar = Calendar.current
    var receivedAddress: String!
    var receivedTime: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.location.delegate = self
        self.location.dataSource = self
        self.addPhoto.delegate = self
        self.addPhoto.dataSource = self
        self.category.delegate = self
        self.category.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if(tableView == location){
            cell = tableView.dequeueReusableCell(withIdentifier: "address")!
            let infomation = ["latitude: "+String(self.receivedLocation.coordinate.latitude), "longitude: "+String(self.receivedLocation.coordinate.longitude), "Address: "+receivedAddress, "Date: "+receivedTime]
            let info = infomation[indexPath.row]
            cell.textLabel?.text = info
            cell.textLabel?.numberOfLines = 0
            
        }
        if(tableView == addPhoto) {
            cell = tableView.dequeueReusableCell(withIdentifier: "add")
            let addArr = ["add photo"]
            let add = addArr[indexPath.row]
            cell.textLabel?.text = add
        }
        if(tableView == category) {
            cell = tableView.dequeueReusableCell(withIdentifier: "descript")
            let descript = ["Category"]
            let description = descript[indexPath.row]
            cell.textLabel?.text = description
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int!
        if(tableView == location) {
            count = 4
        }
        if(tableView == addPhoto) {
            count = 1
        }
        if(tableView == category) {
            count = 1
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == addPhoto) {
            performSegue(withIdentifier: "SegueToAddPhoto", sender: self)
            }
        if(tableView == category) {
            performSegue(withIdentifier: "SegueToCategory", sender: self)
        }
            
        
    }
    
    @IBAction func unwindToFirstVC(segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "SegueToAddPhoto") {
            if let vc = segue.destination as? AddPhoto {
                vc.receivedLocation = receivedLocation
                vc.receivedAddress = receivedAddress
                vc.receivedTime = receivedTime
                vc.receivedDescript = textView.text
                vc.receivedCategoryFromFirstVC = receivedCategory
            }
        }
    }
 
    
}

