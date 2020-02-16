//
//  DataController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit
import CoreData

public class DataController: NSObject {
    
    /// The shared cloud-data data controller
    public static let shared = DataController()
    
    /// The Core Data managed object context. Used to instantiate new managed objects.
    public var managedObjectContext: NSManagedObjectContext!
    
    /// Create a new managed object of a managed object type
    internal func create<T>(new type: T.Type) -> T where T: NSManagedObject {
        return T.init(context: self.managedObjectContext)
    }
    
    /// Fetch all objects of a managed object type
    internal func fetchAllObjects<T: NSFetchRequestResult>(for fetchRequest: NSFetchRequest<T>,
                                                           predicate: NSPredicate? = nil) -> [T] {
        var batch: [T] = []
        fetchRequest.predicate = predicate
        do {
            batch = try self.managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            // If we get an error here, we probably lost the user's progress altogether... :/
            print(error.localizedDescription)
        }
        return batch
    }
    
    
    // MARK: - Private
    
    private override init() {
        super.init()
    }
    
}
