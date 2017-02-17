//
//  MovieCollectionsViewController.swift
//  Flicks
//
//  Created by Sean Nam on 2/16/17.
//  Copyright © 2017 Sean Nam. All rights reserved.
//

import UIKit

class MovieCollectionsViewController: UIViewController {

    var movies: [NSDictionary]? = []
    let baseUrl = "https://image.tmdb.org/t/p/w500/"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "detailedSegue")
        {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie = self.movies![(indexPath?.row)!]
            //print(movie["title"])
            let posterPath = movie["poster_path"] as? String
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
            
            
            detailViewController.posterPath = posterPath
            /*
             detailViewController.movieId = movieId
             
             detailViewController.popularity = popularity
             detailViewController.rating = rating
             */
            
            //print("prepare for segue called from movieviewcontroller")
        }
    }
    

}
extension MovieCollectionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count;
        } else {
            return 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let movies = movies {
            return movies.count;
        } else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath as IndexPath) as! MovieCollectionCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        
        //cell.titleLabel.text = title
        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            //let imageUrl = baseUrl + posterPath
            cell.posterView.setImageWith(imageUrl! as URL)
        }
        
        //fadePosterImagesIn(cell, movie)
        
        return cell
    }
    func fadePosterImagesIn(_ cell: MovieCollectionCell, _ movie: NSDictionary) {
        //let baseUrl = "https://image.tmdb.org/t/p/w500/"
        
        if let posterPath = movie["poster_path"] as? String {
            //let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageUrl = baseUrl + posterPath
            //cell.posterView.setImageWith(imageUrl! as URL)
            
            let imageRequest = NSURLRequest(url: NSURL(string: imageUrl)! as URL)
            
            cell.posterView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
                    print("error loading image")
            })
            
        }
        
    }
}
