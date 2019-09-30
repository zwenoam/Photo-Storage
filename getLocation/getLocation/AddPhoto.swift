//
//  AddPhoto.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 8/24/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import CoreData
import CoreImage


class AddPhoto: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var photoAlbum: UIButton!
    @IBOutlet weak var photo: UIImageView!
    var receivedAddress: String!
    var receivedTime: String!
    var receivedLocation: CLLocation!
    var receivedDescript: String!
    var context: NSManagedObjectContext?
    var receivedCategoryFromFirstVC: String = ""
    var photoID: Int = 1
    var photoURL: URL {
        let filename = "Photo-\(photoID).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onCameraButtonClicked(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: .video) { response in
            if response {
                self.presentUIImagePicker(sourceType: .camera)
            } else {
                self.showPhotoDeniedAlert()
                return
            }
        }
    }
    
    @IBAction func onPhotoButtonClicked(_ sender: Any) {
        presentUIImagePicker(sourceType: .photoLibrary)
    }
    
    private func presentUIImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    let applicationDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    func showPhotoDeniedAlert() {
        let alert = UIAlertController(title: "Photo Access Denied", message: "Please enable photo access for this app in settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        photo.image = chosenImage
        saveButton.isHidden = false
        if let data = UIImageJPEGRepresentation(chosenImage, 1.0),
            !FileManager.default.fileExists(atPath: photoURL.path) {
            do {
                
                try data.write(to: photoURL)
                
                print("photo saved")
            }catch {
                print ("error saving file", error)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context!)
        let newImage = NSManagedObject(entity: entity!, insertInto: context)
        newImage.setValue(receivedTime, forKey: "date")
        newImage.setValue(receivedAddress, forKey: "address")
        let lati = String(receivedLocation.coordinate.latitude)
        let long = String(receivedLocation.coordinate.longitude)
        newImage.setValue(lati, forKey: "latitude")
        newImage.setValue(long, forKey: "longitude")
        newImage.setValue(receivedDescript, forKey: "descript")
        newImage.setValue(receivedCategoryFromFirstVC, forKey: "category")
        newImage.setValue(UIImagePNGRepresentation(photo.image!), forKey: "picture")
        newImage.setValue(photoURL.absoluteString, forKey: "photoURL")
        print (photoURL.absoluteString)
        do {
            try context!.save()
            print("saved")
        } catch {
            print("Failed saving")
        }
       self.performSegue(withIdentifier: "unwindToFirstView", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
