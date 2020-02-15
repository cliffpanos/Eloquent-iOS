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
        if let user = controller.fetchAllObjects(for: User.fetchRequest()).first {
            return user
        }
        
        let newUser = controller.create(new: User.self)
        newUser.firstName = "Cliff"
        newUser.lastName = "Panos"
        newUser.imageData = UIImage(named: "Contact-Default")!.pngData()
        newUser.dateCreated = Date()
        return newUser
    }()

    public var contactImage: UIImage? {
        guard let data = imageData else { return nil}
        return UIImage(data: data)
    }
    
}
