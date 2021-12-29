//
//  MoviesViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import UIKit

class MoviesViewController: UIViewController {
    var movies = [Movie]()
    
    @IBOutlet weak var MoviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        return cell
    }
}
