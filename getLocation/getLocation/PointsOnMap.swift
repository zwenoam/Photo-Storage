//
//  PointsOnMap.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 9/7/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import CoreLocation

class PointsOnMap: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var context: NSManagedObjectContext!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let result = try context!.fetch(request)
            for data in result as [NSManagedObject] {
                print (data.value(forKey: "latitude") as! String)
                let latitude = Double(data.value(forKey: "latitude") as! String)
                let longitude = Double(data.value(forKey: "longitude") as! String)
                let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let note = MKPointAnnotation()
                note.coordinate = locationCoordinate
                mapView.addAnnotation(note)
            }
        } catch {
            print ("failed")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinateLatitude = view.annotation?.coordinate.latitude
        let coordinateLongitude = view.annotation?.coordinate.longitude
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let result = try context!.fetch(request)
            for data in result as [NSManagedObject] {
                let lat = data.value(forKey: "latitude") as! String
                let long = data.value(forKey: "longitude") as! String
                if(coordinateLatitude == Double(lat) && coordinateLongitude == Double(long)) {
                    photoView.image = UIImage(data: data.value(forKey: "picture") as! Data)
                    descriptionLabel.text = "Description:  \(data.value(forKey: "descript") as! String) "
                    coordinateLabel.text = "Coordinate: \(data.value(forKey: "latitude") as! String), \(data.value(forKey: "longitude") as! String)"
                    categoryLabel.text = "Category: \(data.value(forKey: "category") as! String)"
                    addressLabel.text = "Address: \(data.value(forKey: "address") as! String)"
                    dateLabel.text = "Date: \(data.value(forKey: "date") as! String)"
                }
            }
        } catch {
            print ("error get photo")
        }
    }
    
    
}
