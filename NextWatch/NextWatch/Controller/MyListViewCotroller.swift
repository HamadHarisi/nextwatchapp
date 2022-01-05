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

    var movies = [MovieList]()
    var selectedMovie:Movie?
    var selectedPostImage:UIImage?
    
    @IBOutlet weak var myListTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
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
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("ERROR user Data",error.localizedDescription)
                                    
                                }
                                if let userSnapshot = userSnapshot,
                                   let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                                    let movie = MovieList(dict: movieData, title: diff.document.documentID, user: user)
                                    self.myListTableView.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.movies.append(movie)
                                      
                                      self.myListTableView.insertRows(at: [IndexPath(row:self.movies.count - 1,section: 0)],with: .automatic)
                                    }else {
                                        self.movies.insert(movie,at:0)
                                        
                                        self.myListTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
                                    }
                                    self.myListTableView.endUpdates()
                                }
                            }
                        }
                    case .modified:
                        let movieId = diff.document.documentID
                        if let currentMovie = self.movies.first(where: {$0.title == movieId}),
                           let updateIndex = self.movies.firstIndex(where: {$0.title == movieId}){
                            let newMovie = MovieList(dict: movieData, title: movieId, user: currentMovie.user)
                        //    let newMovie = Movie(dict: movieData, id: movieId, user: currentMovie.title)
                            self.movies[updateIndex] = newMovie
                         
                                self.myListTableView.beginUpdates()
                                self.myListTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                                self.myListTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                                self.myListTableView.endUpdates()
                            
                        }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.movies.firstIndex(where: {$0.title == postId}){
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
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellList") as! MovieCell
        return cell.configure(with: movies[indexPath.row].self)
    }
    
    
}
extension MyListViewCotroller : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }

}
