//
//  SelectCategory.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 9/8/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class selectCategory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var saveButton: UIButton!
    var context: NSManagedObjectContext!
    var selectedCategory: String!
    @IBOutlet weak var categories: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories.delegate = self
        self.categories.dataSource = self
        saveButton.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category")!
        let categories = ["Architecture", "Cityscape","Nature", "Landscape", "Portrait"]
        let cate = categories[indexPath.row]
        cell.textLabel?.text = cate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveButton.isHidden = false
        let currentCell = tableView.cellForRow(at: indexPath)
        selectedCategory = currentCell?.textLabel?.text
    }
    
    @IBAction func onSaveButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFirstVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToFirstVC" {
            if let vc = segue.destination as? FirstViewController {
                vc.receivedCategory = selectedCategory
            }
        }
    }
    
    
    
}
