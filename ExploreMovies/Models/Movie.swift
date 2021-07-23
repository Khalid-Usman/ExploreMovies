//
//  Movie.swift
//  ExploreMovies
//
//  Created by mac on 29/06/2021.
//

import Foundation
import UIKit

struct Movie: Decodable {
    let id: Int?
    let poster_path: String?
    let backdrop_path: String?
    let title: String?
    let overview : String?
    let release_date : String?
}
