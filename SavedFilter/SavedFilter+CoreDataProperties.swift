//
//  SavedFilter+CoreDataProperties.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 19.08.2024.
//
//

import Foundation
import CoreData

extension SavedFilter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedFilter> {
        return NSFetchRequest<SavedFilter>(entityName: "SavedFilter")
    }

    @NSManaged public var cameraName: String?
    @NSManaged public var cameraFullName: String?
    @NSManaged public var roverName: String?
    @NSManaged public var photoDate: Date?
    @NSManaged public var timestamp: Date?

}

extension SavedFilter : Identifiable {

}
