//
//  Movie.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import Foundation
import Firebase

struct MovieInFB
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
           let createdAt = dict["createdAt"] as? Timestamp
        {
            self.moviesName = title
            self.moviesDescription = description
            self.moviePoster = imageUrl
            self.createdAt = createdAt
        }
        self.id = id
        self.user = user
    }
}
struct Digmon: Codable
{
    var name:String
    var img:String
    var level:String
}
