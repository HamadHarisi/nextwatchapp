//
//  User.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import Foundation
import Firebase
// user struct
struct User
{
    var id = ""
    var name = ""
    var email = ""
    var imageUrl = ""
    
    init(dict:[String:Any])
    {
        if let id = dict["id"] as? String,
           let name = dict["name"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           let email = dict["email"] as? String
        {
            self.id = id
            self.name = name
            self.imageUrl = imageUrl
            self.email = email
        }
    }
}
