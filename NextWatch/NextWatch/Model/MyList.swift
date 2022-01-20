//
//  MyList.swift
//  NextWatch
//
//  Created by حمد الحريصي on 06/01/2022.
//

import Foundation
import Firebase
// custome list struct (MyList)
struct MovieList {
    var id       = ""
    var title    = ""
    var overview = ""
    var imageUrl = ""
    var user:User
    
    init(dict:[String:Any],id:String,user:User) {
        if let title   = dict["title"] as? String,
           let overview   = dict["overview"] as? String,
           let imageUrl   = dict["imageUrl"] as? String{
            self.title     = title
            self.overview  = overview
            self.imageUrl  = imageUrl
        }
        self.id   = id
        self.user = user
    }
}
