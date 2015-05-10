//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Steve Wan on 5/9/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary! //movie is a local var? why! implicit unwrapped optional??
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.show()

        
        titleLabel.text = movie["title"] as? String // what's the difference between as ? and as!
        synopsisLabel.text = movie["synopsis"] as? String // mistake was I linked the imageview not the label
        
        // let url = NSURL(string: movie.valueForKeyPath("posters.original") as! String)! // instead of access movie as directionary, use movie.valueForKey, why as! and why force downcast!
        // valueForKey was wrong
        
    
        var urlstring = movie.valueForKeyPath("posters.original") as! String
        
        
        imageView.setImageWithURL(NSURL(string: urlstring)) // dont understand why changes to imageView.setImage

        
        var range = urlstring.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlstring = urlstring.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        
        
        let url = NSURL(string: urlstring)!
        
        
        
        imageView.setImageWithURL(url) // dont understand why changes to imageView.setImage
        
        SVProgressHUD.dismiss() // why this one doesn't work;

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
