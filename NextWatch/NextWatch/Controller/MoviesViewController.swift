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
    var selectedPost:Movie?
    var selectedPostImage:UIImage?
    
    private var viewModel = MovieViewModel()

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
        viewModel.fetchPopularMoviesData { [weak self] in
            self?.movieTableView.dataSource = self
            self?.movieTableView.reloadData()
        }
    }
}
//\\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
//    func getPosts() {
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
//                    case .added :
//
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
//                                        self.movieTableView.insertRows(at: [IndexPath(row:0, section: 0)], with: .automatic)
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
//                            self.movies.remove(at: deleteIndex)
//
//                            self.movieTableView.beginUpdates()
//                            self.movieTableView.deleteRows(at: [IndexPath(row: deleteIndex, section: 0)], with: .automatic)
//                            self.movieTableView.endUpdates()
//                        }
//                    }
//                }
//            }
//        }
//    }
//\\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource
{
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 150}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MovieTableViewCell
        
        let  movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
}
