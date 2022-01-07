//
//  MovieCell.swift
//  NextWatch
//
//  Created by حمد الحريصي on 06/01/2022.
//
import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var posterInMyList: UIImageView!
    @IBOutlet weak var titleInMyList: UILabel!
    @IBOutlet weak var overViewInMyList: UILabel!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with movielist:MovieList) -> UITableViewCell {
        titleInMyList.text = movielist.title
        overViewInMyList.text = movielist.overview
        posterInMyList.loadImageUsingCache(with: movielist.imageUrl )
        return self
    }
    override func prepareForReuse() {
        posterInMyList.image = nil
    }
}