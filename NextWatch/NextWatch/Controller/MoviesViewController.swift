//
//  MoviesViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.


import UIKit
import Firebase
class MoviesViewController: UIViewController {
 //var movieAPI = MovieAPI()
    
    var movies = [Movie]()
    var selectedPost:Movie?
    var selectedPostImage:UIImage?


//    @IBOutlet weak var moviesCollectionView: UICollectionView!
//    {
//        didSet
//        {
//            moviesCollectionView.delegate = self
//            moviesCollectionView.dataSource = self
//
//        }
//    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        title = "Movies List"
        navigationController?.navigationBar.prefersLargeTitles = true

    }

   
//\\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
}
extension MoviesViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! MovieTableViewCell
        return cell.configure(with: movies[indexPath.row].user)
    }
}
