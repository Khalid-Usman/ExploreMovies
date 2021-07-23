//
//  Trailers.swift
//  ExploreMovies
//
//  Created by mac on 30/06/2021.
//

import Foundation
import UIKit

struct Trailers: Decodable {
    let id: Int?
    var results: [Trailer]?
    
    private enum CodingKeys: String, CodingKey {
        case id, results
    }
}
