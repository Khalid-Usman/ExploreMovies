//
//  MoviesListViewController.swift
//  ExploreMovies
//
//  Created by mac on 29/06/2021.
//

import Foundation
import UIKit
import CoreData

class MoviesListViewController : UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var movies: Movies?
    var totalMovies = [Movie]()
    var filteredMovies = [Movie]()
    
    var isLoadig : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        if Reachability.isConnectedToNetwork() {
            getMovies {
                if self.movies?.results!.count == 0 || self.movies?.results!.count == nil {
                    return
                }
                //self.filteredMovies = (self.movies?.results)!
                self.movieTableView.reloadData()
                // Save into CoreData
                // MovieMOHandler.saveMovieList(self.totalMovies)
            }
        } else if Config.currentPage > 1 {
            // Fetch from Core Data
            // MovieMOHandler.fetchMovieList()
        } else {
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func getMovies(completed: @escaping () -> ()) {
        let url = URL(string: Config.URL.basePopular + Config.apiKey + "&language=en-US&page=\(Config.currentPage)")!
        print(url)
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            if err == nil {
                guard let jsondata = data else {
                    print("Error: ", err!)
                    completed()
                    return
                }
                do {
                    self.movies = try JSONDecoder().decode(Movies.self, from: jsondata)
                    self.totalMovies.append(contentsOf: (self.movies?.results)!)
                    self.filteredMovies = self.totalMovies
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    print("JSON Downloading Error!")
                }
            }
        }.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 4) && !self.isLoadig {
            self.isLoadig = true
            if Config.currentPage < Config.totalPages {
                Config.currentPage += 1
                self.getMovies {
                    self.movieTableView.reloadData()
                    self.isLoadig = false
                }
            }
        }
    }
}

extension MoviesListViewController : UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.CellIdentifier.MovieTable.movieCell, for: indexPath) as? MovieCell else {
          fatalError("Issue dequeuing \(Config.CellIdentifier.MovieTable.movieCell)")
        }
        let movie = self.filteredMovies[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.movieOverview.text = movie.overview
        cell.configureCell(with: (movie.poster_path)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

extension MoviesListViewController : UITableViewDelegate {
    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailViewController = storyBoard.instantiateViewController(withIdentifier: "movieDetailVC") as! MoviesDetailViewController
        detailViewController.movie = self.filteredMovies[indexPath.row]
        detailViewController.modalPresentationStyle = .fullScreen
        self.present(detailViewController, animated:true, completion:nil)
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredMovies = (searchText.isEmpty ? movies?.results :  movies?.results!.filter {($0.title ?? "").range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil })!
        self.movieTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filteredMovies = (movies?.results)!
        searchBar.resignFirstResponder()
    }
}

