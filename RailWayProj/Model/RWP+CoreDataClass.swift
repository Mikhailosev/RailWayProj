//
//  RWP+CoreDataClass.swift
//  RailWayProj
//
//  Created by iosadmin on 14/03/2019.
//  Copyright © 2019 iosadmin. All rights reserved.
//
//

import Foundation
import CoreData


public class RWP: NSManagedObject {
    class func checkForRide (version: String, context: NSManagedObjectContext) throws -> RWP? {
        let request:NSFetchRequest<RWP> = RWP.fetchRequest()
        request.predicate = NSPredicate(format: "versionC = %@", version)
        do {
            let matchingRide = try context.fetch(request)
            if matchingRide.count == 1 {
                return matchingRide[0]
            } else if (matchingRide.count == 0) {
                let newRide = RWP(context: context)
                return newRide
            } else {
                print("Database inconsistent found equal news")
                return matchingRide[0]
            }
        } catch {
            throw error
        }
    }
    
}

