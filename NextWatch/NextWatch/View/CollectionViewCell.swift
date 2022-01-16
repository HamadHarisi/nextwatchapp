//
//  CollectionViewCell.swift
//  NextWatch
//
//  Created by حمد الحريصي on 09/01/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private var urlString: String = ""
    
    
 
//    @IBOutlet weak var addToMylistButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    {
        didSet
        {
            poster.layer.cornerRadius = poster.bounds.height / 20
        }
    }
    
    // Setup movies values
    func setCellWithValuesOf(_ movie:Movie) {
        updateUI(title: movie.title, releaseDate: movie.year, rating: movie.rate, overview: movie.overview, poster: movie.posterImage)
    }



    // Update the UI Views
    private func updateUI(title: String?, releaseDate: String?, rating: Double?, overview: String?, poster: String?) {
        
        self.name.text = title
//        self.overview.text = overview
        
        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.poster.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Before we download the image we clear out the old one
        self.poster.image = nil
        
        getImageDataFrom(url: posterImageURL)
        
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.poster.image = image
                }
            }
        }.resume()
    }
    
    // MARK: - Convert date format
    func convertDateFormater(_ date: String?) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let originalDate = date {
            if let newDate = dateFormatter.date(from: originalDate) {
                dateFormatter.dateFormat = "dd.MM.yyyy"
                fixDate = dateFormatter.string(from: newDate)
            }
        }
        return fixDate
    }
}
