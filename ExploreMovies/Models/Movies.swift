//
//  Movies.swift
//  ExploreMovies
//
//  Created by mac on 29/06/2021.
//

import Foundation
import UIKit

struct Movies: Decodable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    var results: [Movie]?
    
    private enum CodingKeys: String, CodingKey {
        case page, total_results, total_pages, results
    }
}
