//
//  UserBarButtonItem.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class UserBarButtonItem: UIBarButtonItem {

    class func forCurrentUser(with action: Selector) -> UIBarButtonItem {
        let user = User.current
        let contactImage = user.contactImage ?? UIImage(named: "Contact-Default")
        let item = UIBarButtonItem(image: contactImage, style: .plain, target: nil, action: action)
        item.tintColor = nil
        return item
    }

}
