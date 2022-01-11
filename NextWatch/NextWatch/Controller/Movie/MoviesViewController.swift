//
//  MoviesViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.


import UIKit
import Firebase
class MoviesViewController: UIViewController
{
    var movies = [Movie]()
    var selectedMovie:Movie?
    var selectedPostImage:UIImage?
    let present = UIAlertAction.self
    
    
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    {
        didSet
        {
            movieCollectionView.delegate = self
            movieCollectionView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            title = "Movies List"
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        
        loadPopularMoviesData()
    }
   
    private func loadPopularMoviesData() {
        let apiService = ApiService()
        apiService.getPopularMoviesData { result in
            switch result {
            case .success(let list):
                self.movies = list.movies
                self.movieCollectionView.reloadData()
            case .failure(_):
                print("ERROR")
            }
        }
    }
}
var titleSender = ""
var overViewSender = ""
var posterSender = ""

func saveMovie(selectedMovie:Movie) {
    
    if let currentUser = Auth.auth().currentUser?.uid {
        //    Activity.showIndicator(parentView: self.view, childView: activityIndicator)
        
        var movieData = [String:Any]()
        let db = Firestore.firestore()
        let ref = db.collection("movies")
        movieData = [
            "userId":currentUser,
            "title":selectedMovie.title ?? "No Title",
            "overview":selectedMovie.overview ?? "No Overview" ,
            "imageUrl":"https://image.tmdb.org/t/p/w300\(selectedMovie.posterImage ?? "No Poster")" ,
//            "imageUrl":"https://image.tmdb.org/t/p/w300\(selectedMovie.posterImage ?? "No Poster")",
            "year":selectedMovie.year ?? "0000",
            "rate":selectedMovie.rate ?? 0.0,
            "createdAt": FieldValue.serverTimestamp(),
        ]
        ref.addDocument(data: movieData) { error in
            if let error = error {
                print("FireStore Error\(error.localizedDescription)")
            }
            //     let alert = UIAlertAction(title: "Done", style: .default)
        }
    }
}



extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let  movie = movies[indexPath.row]
        cell.setCellWithValuesOf(movie)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
        titleSender = movies[indexPath.row].title ?? "Error"
         overViewSender = movies[indexPath.row].overview ?? "Error"
         posterSender =  movies[indexPath.row].posterImage ?? "Error"
//         let alert1 = UIAlertController(title: "This Movie already in your List", message: "", preferredStyle: .alert)
//         alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//         self.present(alert1, animated: false, completion: nil)
         let db = Firestore.firestore()
         let docRef = db.collection("movies").whereField("title", isEqualTo: titleSender).limit(to: 1)
         docRef.getDocuments { (querysnapshot, error) in
             if error != nil {
                 print("Document Error: ", error!)
             } else {
                 if let doc = querysnapshot?.documents, !doc.isEmpty {
                     let alert = UIAlertController(title: "This Movie already in your List", message: "", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                 } else {
                     print("Document is present.")
                     saveMovie(selectedMovie: self.movies[indexPath.row])
                 }
             }
         }
        movieCollectionView.deselectItem(at: indexPath, animated: true)
            
     }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.systemGray
    }
    
}
