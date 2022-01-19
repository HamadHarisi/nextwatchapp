//
//  MyListViewCotroller.swift
//  NextWatch
//
//  Created by حمد الحريصي on 05/01/2022.
//

import UIKit
import Firebase
class MyListViewCotroller: UIViewController
{
    let context = (UIApplication.shared.delegate as! AppDelegate)    //.persistentContainer.viewContext
    
    
    var movies = [MovieList]()
    var selectedMovie:MovieList?
    var selectedUser:User?
    var selectedPoster:UIImage?
    let activityIndicator = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
@IBOutlet weak var myListTableView: UITableView!
{
didSet
{
myListTableView.delegate = self
myListTableView.dataSource = self
myListTableView.register(UINib(nibName: "MovieCell", bundle: nil),forCellReuseIdentifier: "MovieCell")
}
}
    
//    override func viewWillAppear(_ animated: Bool) {
//        myListTableView.reloadData()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        myListTableView.reloadData()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = NSLocalizedString("My List", comment: "")
        getMovies()
    }
   func getMovies() {
        let ref = Firestore.firestore()
        ref.collection("movies").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }
            if let snapshot = snapshot {
                print("MOVIE CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let movieData = diff.document.data()
                    switch diff.type {
                    case .added :
                        if let userId = movieData["userId"] as? String {
                            if let currentUserId = Auth.auth().currentUser?.uid {
                                if userId == currentUserId {
                                    ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                        if let error = error {
                                            print("ERROR user Data",error.localizedDescription)
                                        }
                                        if let userSnapshot = userSnapshot,
                                           let userData = userSnapshot.data() {
                                            let user = User(dict:userData)
                                            let movie = MovieList(dict: movieData, id: diff.document.documentID, user: user)
                                            self.myListTableView.beginUpdates()
                                            if snapshot.documentChanges.count != 1 {
                                                self.movies.append(movie)
                                                
                                                self.myListTableView.insertRows(at: [IndexPath(row:self.movies.count - 1,section: 0)],with: .automatic)
                                            }else {
                                                self.movies.insert(movie,at:0)
                                                
                                                self.myListTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .left)
                                            }
                                            self.myListTableView.endUpdates()
                                        }
                                    }
                                }
                            }
                        }
                    case .modified:
                    let movieId = diff.document.documentID
                    if let currentMovie = self.movies.first(where: {$0.title == movieId}),
                    let updateIndex = self.movies.firstIndex(where: {$0.title == movieId}){
                        let newMovie = MovieList(dict: movieData, id: movieId, user: currentMovie.user)
                    self.movies[updateIndex] = newMovie
                                self.myListTableView.beginUpdates()
                                self.myListTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                                self.myListTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                                self.myListTableView.endUpdates()
                        }
                    case .removed:
                        let movieId = diff.document.documentID
                        if let deleteIndex = self.movies.firstIndex(where: {$0.title == movieId}){
                            self.movies.remove(at: deleteIndex)
                                self.myListTableView.beginUpdates()
                                self.myListTableView.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                                self.myListTableView.endUpdates()
                        }
                    }
                }
            }
        }
    }
}
extension MyListViewCotroller : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MyListCell
        return cell.configure(with: movies[indexPath.row])
    }
    
}
extension MyListViewCotroller : UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete".localized) { (action, view,completionHandler) in
            let ref = Firestore.firestore().collection("movies")
            ref.document(self.movies[indexPath.row].id).delete { error in
                    if let error = error {
                        print("Error in db",error)
                    } else {
                        self.movies.remove(at: indexPath.row)
                        tableView.beginUpdates()
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        tableView.endUpdates()
                        completionHandler(true)
                        tableView.deselectRow(at: indexPath, animated: true)
                        }
                }
                 }
        return UISwipeActionsConfiguration(actions: [delete])
            }
}
