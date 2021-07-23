//
//  NetworkManager.swift
//  ExploreMovies
//
//  Created by mac on 29/06/2021.
//

import Foundation

public class NetworkManager {
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        session = URLSession.init(configuration: config)
    }
    
    func fetchFilms(completionHandler: @escaping ([Movies]) -> Void) {
        
        let url = URL(string: Config.URL.basePopular + Config.apiKey)!

      let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
          print("Error with fetching films: \(error)")
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
          print("Error with the response, unexpected status code: \(response)")
          return
        }
        if let jsonData = data {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieModel = try decoder.decode(Movies.self, from: jsonData)
                completionHandler([movieModel])
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
      })
      task.resume()
    }
}
