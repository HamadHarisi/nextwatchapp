////
////  MoviesViewController.swift
////  NextWatch
////
////  Created by حمد الحريصي on 27/12/2021.
////
//
//import UIKit
//import Firebase
//class MoviesViewController: UIViewController {
//
//
//
//    var bokimon = [Bokimon]()
//    var movies = [Movie]()
//    var selectedPost:Movie?
//    var selectedPostImage:UIImage?
//
//
//    @IBOutlet weak var moviesCollectionView: UICollectionView!
//    {
//        didSet
//        {
//            moviesCollectionView.delegate = self
//            moviesCollectionView.dataSource = self
//
//        }
//    }
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//
//
//
//
////        title = "Movies List"
////        navigationController?.navigationBar.prefersLargeTitles = true
//
//    }
//
//
//
//    func getDataFromAPI(with endPoint: String)
//    {
//      let baseURL = "https://digimon-api.vercel.app/api"
//        if let url = URL (string: baseURL + endPoint)
//        {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { data , response, error in
//                if let error = error {
//                    print("ERRORRRRRRRR!!!!!!!!",error.localizedDescription)
//                }else
//                {
//                    print("ERRORRRRRRR",data!)
//                    if let safeData = data
//                    {
//                        do
//                        {
//                            let decoder = JSONDecoder()
//                            let decoderData = try decoder.decode([bokimon].self , from: safeData)
//                            self.movies = decoderData
//                            DispatchQueue.main.async {
//                                self.moviesCollectionView.reloadData()
//                            }
//                        }
//                     catch
//                    {
//                        print("ERRORR!?!?!?!?!?!?",error.localizedDescription)
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
//}
//    //\\/\\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
//}
//extension MoviesViewController: UICollectionViewDelegate
//{
//
//}
//extension MoviesViewController: UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        return cell
//    }
//
//
//}
