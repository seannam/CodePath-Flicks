//
//  DetailViewController.swift
//  Flicks
//
//  Created by Sean Nam on 2/7/17.
//  Copyright © 2017 Sean Nam. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movie: NSDictionary!
    var posterPath: String!
    var endpoint: String!
    var movieId: Int!
    var castMembers: [NSDictionary]? = []
    var popularity: Double!
    var rating: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationItem.title = "More Info"
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        //let title = movie["title"]
        //titleLabel.text = title as? String
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        
        overviewLabel.sizeToFit()
        
        //popularityLabel.text = popularity as! String
        //ratingLabel.text = rating as! String
        
        let smallImageUrl = "https://image.tmdb.org/t/p/w45" + posterPath
        let largeImageUrl = "https://image.tmdb.org/t/p/original" + posterPath
        
        
        let smallImageRequest = URLRequest(url: URL(string: smallImageUrl)!)
        let largeImageRequest = URLRequest(url: URL(string: largeImageUrl)!)
        
        self.posterImageView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    self.posterImageView.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    self.posterImageView.setImageWith(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            self.posterImageView.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        
        /*
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWith(imageUrl! as URL)
        }
         */
        
        //loadCast()
        //let cast = castMembers[IndexPath]
        //let member = cast["name"]
    }
    func loadCast() {
        endpoint = "credits"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId!)/\(endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // Hide HUD once the network request comes back
            //MBProgressHUD.hide(for: self.view, animated: true)
            
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    self.castMembers = dataDictionary["cast"] as? [NSDictionary]
                  
                }
            }
            
        }
        
        task.resume()
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
        /*
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = self.movie![indexPath.row]
        
        let detailViewController = segue.destination
        */
        //print("prepare for segue called")
    }
 

}
