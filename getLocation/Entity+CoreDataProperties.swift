//
//  Entity+CoreDataProperties.swift
//  getLocation
//
//  Created by Zhang Qiuhao on 9/13/19.
//  Copyright © 2019 Zhang Qiuhao. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var address: String?
    @NSManaged public var category: String?
    @NSManaged public var date: String?
    @NSManaged public var descript: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var picture: Data?

}
