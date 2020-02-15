//
//  User.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit
import CoreData

extension User {
    
    /// The current user or a new, default user if none existed
    public private(set) static var current: User = {
        let controller = DataController.shared
        let users = controller.fetchAllObjects(for: User.fetchRequest())
        let earliestUser = users.max { (first, second) -> Bool in
            first.dateCreated! > second.dateCreated!    // If conflict, use the earliest created
        }
        if let foundUser = earliestUser {
            return foundUser
        }
        
        let newUser = controller.create(new: User.self)
        newUser.firstName = "Cliff"
        newUser.lastName = "Panos"
        newUser.contactImage = UIImage(named: "Contact-Default")!
        newUser.dateCreated = Date()
        return newUser
    }()

    public var contactImage: UIImage? {
        get {
            guard let data = imageData else { return nil}
            return UIImage(data: data, scale: UIScreen.main.scale)?.withRenderingMode(.alwaysOriginal)
        }
        set {
            self.imageData = newValue?.pngData()
        }
    }
    
}
