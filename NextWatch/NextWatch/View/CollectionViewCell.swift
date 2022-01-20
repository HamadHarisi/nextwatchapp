//
//  CollectionViewCell.swift
//  NextWatch
//
//  Created by حمد الحريصي on 09/01/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
   // private variable
    private var urlString: String = ""
//    outlet variables
    @IBOutlet weak var titleInCollectionView: UILabel! {
        didSet{
            titleInCollectionView.sizeToFit()
        }
    }
    @IBOutlet weak var posterInCollectionView: UIImageView!
    {
        didSet
        {
            posterInCollectionView.layer.cornerRadius = posterInCollectionView.bounds.height / 20
        }
    }
    @IBOutlet weak var contentViewInCollectionViewCell: UIView!
    {
        didSet
        {
            contentViewInCollectionViewCell.layer.cornerRadius = 18
        }
    }
    @IBOutlet weak var booktagImage: UIImageView!
    {
        didSet
        {
            booktagImage.layer.cornerRadius = 7
        }
    }    
    // Setup movies values
    func setCellWithValuesOf(_ movie:Movie) {
        updateUI(title: movie.title, releaseDate: movie.year, rating: movie.rate, overview: movie.overview, poster: movie.posterImage)
    }

    // Update the UI Views
    private func updateUI(title: String?, releaseDate: String?, rating: Double?, overview: String?, poster: String?) {
        
        self.titleInCollectionView.text = title
        
        guard let posterString = poster else {return}
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.posterInCollectionView.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Clear before download new one
        self.posterInCollectionView.image = nil
        
        getImageDataFrom(url: posterImageURL)
        
    }
    
    // Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                self.posterInCollectionView.image = image
                }
            }
        }.resume()
    }
}
