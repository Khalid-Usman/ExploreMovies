//
//  Config.swift
//  ExploreMovies
//
//  Created by mac on 29/06/2021.
//

import Foundation

/// Constants and static data.
struct Config {

    //myApiKey = "ce8da24c66c70aabe5f36a4ceb9a2194"
    static let apiKey = "ce8da24c66c70aabe5f36a4ceb9a2194"
    
    static let maxQueriesHistoryCount = 10
    
    static var totalPages = 1000 // Default
    static var currentPage = 1

    struct URL {
        static let base = "http://api.themoviedb.org/3"
        static let basePopular = "https://api.themoviedb.org/3/movie/popular?api_key="
        static let basePoster = "http://image.tmdb.org/t/p/w154"
        static let baseTrailer = "https://api.themoviedb.org/3/movie/"
    }
    
    struct Keys {
        static let queriesHistory = "_queriesHistory"
    }
    
    struct CellIdentifier {
        struct MovieTable {
            static let movieCell = "MovieItemCell"
            static let historyCell = "HistoryItemCell"
        }
    }
}
