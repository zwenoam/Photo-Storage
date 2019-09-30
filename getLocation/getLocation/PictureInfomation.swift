//
//  PictureInfomation.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 9/6/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PictureInfomation: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var context: NSManagedObjectContext?
    var receivedRowSelected: Int!
    var photoInfo: Array<String> = []
    @IBOutlet weak var pictureInfo: UITableView!
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureInfo.dataSource = self
        pictureInfo.delegate = self
        print (receivedRowSelected)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            let result = try context!.fetch(request)
            let photoSelected = result[receivedRowSelected] as NSManagedObject
            
            let descript = photoSelected.value(forKey: "descript") as! String
            let latitude = photoSelected.value(forKey: "latitude") as! String
            let longitude = photoSelected.value(forKey: "longitude") as! String
            let address = photoSelected.value(forKey: "address") as! String
            print (address)
            let date = photoSelected.value(forKey: "date") as! String
            let category = photoSelected.value(forKey: "category") as! String
            photoInfo.append("Date: " + date)
            photoInfo.append("Descript: " + descript)
            photoInfo.append("Latitude: " + latitude)
            photoInfo.append("Longitude: " + longitude)
            photoInfo.append("Address: " + address)
            photoInfo.append("Category: "+category)
            photo.image = UIImage(data: photoSelected.value(forKey: "picture") as! Data)
        } catch {
            print("failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infomation")!
        let info = photoInfo[indexPath.row]
        cell.textLabel?.text = info
        cell.textLabel?.numberOfLines = 0

        return cell
    }

}
