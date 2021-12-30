//
//  MoviesViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import UIKit

class MoviesViewController: UIViewController {
   
    
   // var movies = [Movie]()
  //  var number:Int?
    
    @IBOutlet weak var MoviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     number = 999
        
//        MoviesCollectionView.delegate = self
//        MoviesCollectionView.dataSource = self
//
//
        
        title = "Movies List"
        navigationController?.navigationBar.prefersLargeTitles = true

//        title = "Movies List"
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//
    //    navigationController?.navigationBar.largeTitleTextAttributes =

     
    }
}
//extension MoviesViewController: UICollectionViewDelegate
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return movies.count
//    }



    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>) as! MovieCollectionViewCell
//        return cell.configure(with: movies[indexPath.row])
//        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
//        return cell
//    }
//}


//extension MoviesViewController: UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return
//    }
//
//
//}
