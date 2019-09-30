//
//  ViewController.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 8/12/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate {
    
    var location: CLLocation!
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    let date = Date()
    //let calendar = Calendar.current
    var address: String!
    var time: String!
    let dateFormatter = DateFormatter()
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longititude: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var tagLocation: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    var context: NSManagedObjectContext?
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.deleteAllData("Entity")
        locationManager.delegate = self
        
    }
    
//    func deleteAllData(_ entity:String) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        fetchRequest.returnsObjectsAsFaults = false
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        context = appDelegate.persistentContainer.viewContext
//        do {
//            let results = try context!.fetch(fetchRequest)
//            for object in results {
//                guard let objectData = object as? NSManagedObject else {continue}
//                context!.delete(objectData)
//            }
//        } catch let error {
//            print("Detele all data in \(entity) error :", error)
//        }
//    }
    
    @IBAction func showFirstViewController(_ sender: Any) {
        
        performSegue(withIdentifier: "SegueToFirstVC", sender: self)
    }
    @IBAction func getLocation(_ sender: Any) {
        
        let authStatus = CLLocationManager.authorizationStatus()
        if (authStatus == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if (authStatus == .denied || authStatus == .restricted) {
            showLocationServiceDeniedAlert()
            return
        }
        self.tagLocation.titleLabel?.text = "Tag Location"
        location = locationManager.location
        centerLocationOnMap(location: location)
        let note = MKPointAnnotation()
        note.title = "You are here"
        note.coordinate = location.coordinate
        self.mapView.addAnnotation(note)
        latitude.text = "Latitude: " + String( location.coordinate.latitude)
        longititude.text = "Longitude: " + String( location.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if error == nil, let p = placemarks, !p.isEmpty {
                self.street.text = p[0].subThoroughfare
                
                self.city.text = "\(p[0].subAdministrativeArea!) \(p[0].administrativeArea!) \(p[0].postalCode!)"
                self.tagLocation.setTitle("Tag Location", for: .normal)
                self.address = "\(p[0].subThoroughfare ?? "") \(p[0].subAdministrativeArea ?? ""), \(p[0].administrativeArea ?? "") \(p[0].postalCode ?? ""), \(p[0].country ?? "")"
                
                self.dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                self.time = (self.dateFormatter.string(from: self.date))
            }
        })
        
    }
    
    func centerLocationOnMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showLocationServiceDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SegueToFirstVC") {
            if let vc = segue.destination as? FirstViewController {
                vc.receivedLocation = location
                vc.receivedAddress = address
                vc.receivedTime = time
            }
        }
    }
}

