//
//  ImageView.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import Foundation
import UIKit
let imageCache = NSCache<NSString,UIImage>()
extension UIImageView
{
    func circlerImage()
    {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    func loadImageUsingCache(with urlString:String)
    {
        if let cachedImage = imageCache.object(forKey: urlString as NSString)
        {
            self.image = cachedImage
        }
        else
        {
            if let url = URL(string:urlString)
            {
//                DispatchQueue.global().async {
//                    if let data = try? Date(contentsOf: url)
//                    {
//                        DispatchQueue.main.async
//                        {
//                            if let dowloadedImage = UIImage(data: data)
//                            {
//                                imageCache.setObject(dowloadedImage, forKey: urlString as NSString)
//                                self.image = dowloadedImage
//                            }
//                        }
//                    }
//                }
            }
        }
    }
}
