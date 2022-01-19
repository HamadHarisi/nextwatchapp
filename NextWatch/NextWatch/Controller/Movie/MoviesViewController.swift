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
    
    // Outlet for movieCollectionView
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
        // Large Title
//        title = "Movies List".localized
//        title = "My List".localized
//        title = "Account".localized
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.title = NSLocalizedString("Movies List", comment: "")
    
     
        // call for the func that load movie from API
        loadPopularMoviesData()
    }
    // condition for collectionview in small divaice
    override func viewWillLayoutSubviews() {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        if UIScreen.main.bounds.width < 400 {
              collectionFlowLayout.itemSize = CGSize(width: 170, height: 335)
              movieCollectionView.collectionViewLayout = collectionFlowLayout
    }
    }
    
   // func that load movieData from API
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

// varibals
var titleSender = ""
var overViewSender = ""
var posterSender = ""
// func that save movie to Fierbase base on currentUser
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
            "imageUrl":"https://image.tmdb.org/t/p/w300\(selectedMovie.posterImage ?? "No Poster")",
            "year":selectedMovie.year ?? "0000",
            "rate":selectedMovie.rate ?? 0.0,
            "createdAt": FieldValue.serverTimestamp(),
        ]
        ref.addDocument(data: movieData) { error in
            if let error = error {
                print("FireStore Error\(error.localizedDescription)")
            }
        }
    }
}
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout
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
         let db = Firestore.firestore()
         let docRef = db.collection("movies").whereField("title", isEqualTo: titleSender).limit(to: 1)
         docRef.getDocuments { (querysnapshot, error) in
             if error != nil {
                 print("Document Error: ", error!)
             } else {
                 if let doc = querysnapshot?.documents, !doc.isEmpty {
                     // alert This Movie already in your List
                     let alert = UIAlertController(title: "RepeatAlertInMVC".localized, message: "", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OKInMVC".localized, style: .destructive, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                 } else {
                     saveMovie(selectedMovie: self.movies[indexPath.row])
                     // alert Success you can check your list
                     let alert = UIAlertController(title: "SuccessInMVC".localized, message: "", preferredStyle: UIAlertController.Style.alert)
                     self.present(alert, animated: true, completion: nil)
                      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
                       self.dismiss(animated: true)
                     }
                 }
             }
         }
        movieCollectionView.deselectItem(at: indexPath, animated: true)
     }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.posterInCollectionView.transform = .init(scaleX: 1.5, y: 1.5)
                cell.titleInCollectionView.transform = .init(scaleX: 1.5, y: 1.5)
                cell.booktagImage.transform = .init(scaleX: 1.5, y: 1.5)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.posterInCollectionView.transform = .identity
                cell.titleInCollectionView.transform = .identity
                cell.booktagImage.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
}
