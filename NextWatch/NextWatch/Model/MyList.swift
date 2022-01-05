//
//  MyList.swift
//  NextWatch
//
//  Created by حمد الحريصي on 06/01/2022.
//

import Foundation
import Firebase
struct MovieList {
    //var id = ""
    var title = ""
    var overview = ""
    var imageUrl = ""
    var user:User
    var createdAt:Timestamp?
    
    init(dict:[String:Any],title:String,user:User) {
        if let title = dict["title"] as? String,
           let overview = dict["overview"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp{
            self.title = title
            self.overview = overview
            self.imageUrl = imageUrl
            self.createdAt = createdAt
        }
        self.title = title
        self.user = user
    }
}
