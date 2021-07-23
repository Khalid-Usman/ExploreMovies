//
//  MovieCell.swift
//  ExploreMovies
//
//  Created by mac on 29/06/2021.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    
    func configureCell(with urlString: String) {
        let url = Config.URL.basePoster + urlString
        let size = movieImage.frame.size
        movieImage.af.setImage(withURL: URL(string: url)!,
                              placeholderImage: nil,
                              filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 0.0),
                              imageTransition: .crossDissolve(0.3))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.af.cancelImageRequest()
        movieImage.image = nil
    }
}
