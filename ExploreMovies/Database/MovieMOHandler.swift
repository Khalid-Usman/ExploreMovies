//
//  MovieMOHandler.swift
//  ExploreMovies
//
//  Created by mac on 30/06/2021.
//

import Foundation
import CoreData
import UIKit

class MovieMOHandler {
    
    static func saveMovieList(_ movieList: [Movie]) {
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MovieMO", in: managedContext)
        for movie in movieList {
            let urlString = Config.URL.basePoster + movie.poster_path!
            let url = URL(string: urlString)
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            let base64Str = UIImage(data: data)!.jpegData(compressionQuality: 1)?.base64EncodedString()
                            let movieObj = NSManagedObject(entity: entity!,
                                                           insertInto: managedContext)
                            movieObj.setValue(movie.id, forKey: "id")
                            movieObj.setValue(movie.title, forKey: "title")
                            movieObj.setValue(movie.overview, forKey: "overview")
                            movieObj.setValue(movie.release_date, forKey: "release_date")
                            movieObj.setValue(movieObj, forKey: "poster_img")
                            do {
                                try managedContext.save()
                            } catch let error as NSError {
                                print("Could not save. \(error), \(error.userInfo)")
                            }
                            
                        }
                    }
                }
        }
    }
    
    static func fetchMovieList() -> [Movie] {
        let movies = [Movie]()
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieMO")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.count>0 {
                for i in 0..<fetchedResults.count {
                    let movieObj = fetchedResults[i] as? MovieMO
                    if let decodedData = Data(base64Encoded: movieObj?.poster_img as! String, options: .ignoreUnknownCharacters) {
                      let image = UIImage(data: decodedData)
                      //Image(uiImage: image!)
                    }
                }
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return movies
    }
}
