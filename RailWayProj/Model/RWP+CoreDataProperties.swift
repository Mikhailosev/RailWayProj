//
//  RWP+CoreDataProperties.swift
//  RailWayProj
//
//  Created by iosadmin on 14/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//
//

import Foundation
import CoreData


extension RWP {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RWP> {
        return NSFetchRequest<RWP>(entityName: "RWP")
    }

    @NSManaged public var arrivalC: String?
    @NSManaged public var arrivalCodeC: String?
    @NSManaged public var departureC: String?
    @NSManaged public var departureCodeC: String?
    @NSManaged public var platformArrC: String?
    @NSManaged public var platformDepC: String?
    @NSManaged public var timeArrC: String?
    @NSManaged public var timeDepC: String?
    @NSManaged public var typeArrivalC: String?
    @NSManaged public var typeDepartureC: String?
    @NSManaged public var typeTrainC: String?
    @NSManaged public var versionC: String?
    @NSManaged public var dateOfTripC: String?

}
