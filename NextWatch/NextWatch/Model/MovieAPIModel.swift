//
//  MovieAPIModel.swift
//  NextWatch
//
//  Created by حمد الحريصي on 04/01/2022.
//

import Foundation

struct MoviesData: Decodable {
    let movies:[Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "reslts"
    }
}

struct Movie: Decodable {
    var title: String?
    var year: String?
    var rate: Double?
    var posterImage: String?
    var overview: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview
        case year = "release_data"
        case rate = "vote_average"
        case posterImage = "poster_path"
    }
}
