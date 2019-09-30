//
//  PhotoTable.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 8/28/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PhotoTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var context: NSManagedObjectContext?
    
    var rowToPass: Int = 0
    

    
    @IBOutlet weak var savedPhotos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.savedPhotos.delegate = self
        self.savedPhotos.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let count = try context!.count(for: request)
            return count
        }catch {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photo")!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        var photoURLs: Array<String> = []
        var photoPNGs: Array<Data> = []
        var dates: Array<String> = []
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let result = try context!.fetch(request)
            for data in result as [NSManagedObject] {
                
                let date = data.value(forKey: "date") as! String
                dates.append(date)
                let photoPNG = data.value(forKey: "picture") as! Data
                photoPNGs.append(photoPNG)
            }
        }catch {
            print ("failed")
        }
        let dt = dates[indexPath.row]
        cell.textLabel?.text = "                       " + dt
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 5, y: 15, width: 100, height: 100))
        cellImg.image = UIImage(data: photoPNGs[indexPath.row])
        cell.addSubview(cellImg)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowToPass = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToPictureInfomation") {
            if let vc = segue.destination as? PictureInfomation {
                vc.receivedRowSelected = rowToPass
            }
        }
    }
}
