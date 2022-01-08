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
    
    
    @IBOutlet weak var movieTableView: UITableView!
    {
        didSet {
            movieTableView.delegate = self
            movieTableView.dataSource = self
            //      movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadPopularMoviesData()
    }
    private func loadPopularMoviesData() {
        let apiService = ApiService()
        apiService.getPopularMoviesData { result in
            switch result {
            case .success(let list):
                self.movies = list.movies
                self.movieTableView.reloadData()
            case .failure(_):
                print("ERROR")
            }
        }
    }
}

var titleSender = ""
var overViewSender = ""
var posterSender = ""


//func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let toMyList = segue.destination as! MyListViewCotroller
//    //    distenationVC.selectedItem = selectedItem
////    toMyList.titleResiver = titleSender
////    toMyList.overViewResiver = overViewSender
//    // toMyList.poster.image = posterInMyList
//}

//func getPosts() {
//        let ref = Firestore.firestore()
//        ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
//            if let error = error {
//                print("DB ERROR Posts",error.localizedDescription)
//            }
//            if let snapshot = snapshot {
//                print("POST CANGES:",snapshot.documentChanges.count)
//                snapshot.documentChanges.forEach { diff in
//                    let postData = diff.document.data()
//                    switch diff.type {
//                    case .added:
//                        if let userId = postData["userId"] as? String {
//                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
//                                if let error = error {
//                                    print("ERROR user Data", error.localizedDescription)
//                                }
//                                if let userSnapshot = userSnapshot,
//                                   let userData = userSnapshot.data() {
//                                    let user = User(dict: userData)
//                                    let post = Movie(dict: postData, id: diff.document.documentID, user: user)
//                                    self.movieTableView.beginUpdates()
//                                    if snapshot.documentChanges.count != 1 {
//                                        self.movies.append(post)
//
//                                        self.movieTableView.insertRows(at: [IndexPath(row: self.movies.count - 1 , section: 0)], with: .automatic)
//                                    }else {
//                                        self.movies.insert(post,at:0)
//                                    self.movieTableView.insertRows(at: [IndexPath(row:0, section: 0)], with: .automatic)
//                                    }
//                                    self.movieTableView.endUpdates()
//                                }
//                            }
//                        }
//                    case .modified:
//                        let postId = diff.document.documentID
//                        if let currentPost = self.movies.first(where: {$0.id == postId}),
//                           let updateIndex = self.movies.firstIndex(where: {$0.id == postId }) {
//                            let newPost = Movie(dict:postData, id: postId, user: currentPost.user)
//                            self.movies[updateIndex] = newPost
//                        }
//                    case .removed:
//                        let postId = diff.document.documentID
//                        if let deleteIndex = self.movies.firstIndex(where: {$0.id == postId }) {
//                        self.movies.remove(at: deleteIndex)
//
//                            self.movieTableView.beginUpdates()
//                        self.movieTableView.deleteRows(at: [IndexPath(row: deleteIndex, section: 0)], with: .automatic)
//                        self.movieTableView.endUpdates()
//                        }
//                    }
//                }
//            }
//        }
//    }




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
            "imageUrl":"https://image.tmdb.org/t/p/w300\(selectedMovie.posterImage ?? "")",
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



extension MoviesViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 150 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieTableViewCell
        
        let  movie = movies[indexPath.row]
        cell.setCellWithValuesOf(movie)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleSender = movies[indexPath.row].title ?? "Error"
        overViewSender = movies[indexPath.row].overview ?? "Error"
        posterSender =  movies[indexPath.row].posterImage ?? "Error"
        let db = Firestore.firestore()
        let docRef = db.collection("movies").whereField("title", isEqualTo: titleSender).limit(to: 1)
//        let docRef = db.collection("movies").whereField("title", isEqualTo: "titleSender").limit(to: 1)
        docRef.getDocuments { (querysnapshot, error) in
            if error != nil {
                print("Document Error: ", error!)
            } else {
                if let doc = querysnapshot?.documents, !doc.isEmpty {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    let alert = UIAlertController(title: "This Movie already in your List", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Document is present.")
                    saveMovie(selectedMovie: self.movies[indexPath.row])
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
