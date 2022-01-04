////
////  MovieAPI.swift
////  NextWatch
////
////  Created by حمد الحريصي on 03/01/2022.
////
//
//import Foundation
//
//protocol MovieAPIDelegate {
//    func didFetchMovie(movie: Digmon)
//    func didFailWithError (error: Error?)
//}
//struct MovieAPI {
//    var delegate:MovieAPIDelegate?
//    func getDataFromAPI() {
//      let urlString = "https://digimon-api.vercel.app/api"
//        let url = URL (string: urlString)
//            let urlSession = URLSession(configuration: .default)
//        let task = urlSession.dataTask(with: url!) { (data , urlResponse, error) in
//                if  error != nil {
//                    print("ERRORRRRRRRR!!!!!!!!",error?.localizedDescription)
//}else{
//    do {
//        let thisPosts = try JSONDecoder().decode(Digmon.self, from: data!)
//        delegate?.didFetchMovie(movie:thisPosts)
//    }catch{
//    print(error)
//    }
//
//}
//            }
//        task.resume()
//    }
//}
