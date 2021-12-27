//
//  Movie.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import Foundation
import Firebase

struct Movie
{
    var id = ""
    var moviesName = ""
    var moviesDescription = ""
    var moviePoster = ""
    var user:User
    var createdAt:Timestamp?
    
    init(dict:[String:Any],id:String,user:User)
    {
        if let title = dict["title"] as? String,
           let description = dict["description"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
           
    }
}
