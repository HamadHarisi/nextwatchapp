//
//  MovieTableViewCell.swift
//  NextWatch
//
//  Created by حمد الحريصي on 01/01/2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        let delect = UIBarButtonItem(image: UIImage(systemName: "trash.fill"),style: .plain, target: self, action: #selector(<#T##@objc method#>))
//
//        
//        
//        
//        @objc func handlDelect()
        // Configure the view for the selected state
    }
    func configure(with user:User) -> UITableViewCell
    {
        name.text = user.name
        poster.loadImageUsingCache(with: user.imageUrl)
        
        return self
    }
    
}
