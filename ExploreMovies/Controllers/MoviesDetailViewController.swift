//
//  MoviesDetailViewController.swift
//  ExploreMovies
//
//  Created by mac on 29/06/2021.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import AVKit
import AVFoundation

class MoviesDetailViewController : UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var movieDetailImage : UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var overViewLabel: UILabel!
    
    var movie: Movie?
    var trailers: Trailers?
    
    let playerViewController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1000.0)
        
        titleLabel.text = movie?.title
        dateLabel.text = movie?.release_date
        overViewLabel.text = movie?.overview
        
        let url = Config.URL.basePoster + (movie?.poster_path)!
        let size = movieDetailImage.frame.size
        movieDetailImage.af.setImage(withURL: URL(string: url)!,
                              placeholderImage: nil,
                              filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 0.0),
                              imageTransition: .crossDissolve(0.3))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func watchTrailer(completed: @escaping () -> ()) {
        let urlStr = Config.URL.baseTrailer + String((movie?.id)!) + "/videos?api_key=" + Config.apiKey
        let url = URL(string: urlStr)!
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            if err == nil {
                guard let jsondata = data else {
                    print("Error: ", err!)
                    completed()
                    return
                }
                do {
                    self.trailers = try JSONDecoder().decode(Trailers.self, from: jsondata)
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
    
    @IBAction func watch(sender: UIButton) {
        watchTrailer {
            let trailer = self.trailers?.results![0]
            let url = "https://www.youtube.com/watch?v=" + (trailer?.key)!
            let videoURL = URL(string: url)
            let player = AVPlayer(url: videoURL!)
            self.playerViewController.player = player
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerViewController.player?.currentItem)
            self.present(self.playerViewController, animated: true) {
                self.playerViewController.player!.play()
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.dismiss(animated: true)
    }
}
