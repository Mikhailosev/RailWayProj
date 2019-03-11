//
//  Rails+CoreDataProperties.swift
//  RailWayProj
//
//  Created by iosadmin on 10/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//
//

import Foundation
import CoreData


extension Rails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rails> {
        return NSFetchRequest<Rails>(entityName: "Rails")
    }

    @NSManaged public var timeBack: String?
    @NSManaged public var toWhere: String?
    @NSManaged public var time: String?
    @NSManaged public var attribute: String?

}
