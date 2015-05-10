//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Steve Wan on 5/3/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit


// import Foundation
// import XCPlayground
// XCPSetExecutionShouldContinueIndefinitely()



class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var networkerrorLabel: UILabel!
    
    @IBOutlet weak var BoxDVDControl: UISegmentedControl!
    
    var refreshControl: UIRefreshControl!

    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        /*
let YourApiKey = "dagqdghwaq3e3mxyrp7kmmj5" // Fill with the key you registered at http://developer.rottentomatoes.com
// let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
 let RottenTomatoesURLString = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
let url = NSURL(fileURLWithPath: RottenTomatoesURLString)!
let request = NSMutableURLRequest(URL: url)
        
// let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString)!)
NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
var errorValue: NSError? = nil
let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as! NSDictionary
})
*/
        
        
       /*
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? [String: AnyObject],
            feed = json["feed"] as? [String: AnyObject],
            entries = feed["entry"] as? [[String: AnyObject]]
        {
            for entry in entries {
                if let name = entry["im:name"] as? [String: AnyObject],
                    label = name["label"] as? String {
                        titles.append(label)
                }
            }
        } else {
            if let jsonError = jsonError {
                println("json error: \(jsonError)")
            }
        }
*/
        
        // Do any additional setup after loading the view.
     
        println("DidLoadAgain *****")

       SVProgressHUD.show()

        BoxDVDControl.selectedSegmentIndex = 0
        reload()
        
    } // func viewdidLoad
    
 
    override func viewDidAppear(animated: Bool) { // why need override
    super.viewDidAppear(animated)
    println("view did appear")
 
   reload ()
        
    } // end of viewDidAppear
    
    
    @IBAction func OnEditingChanged(sender: AnyObject) {
        
        reload()
        
        println("onEditingChanged called")
    }// end of OnEditingChanged

    
    func reload() {
        var BoxDVD = ["Box", "DVD"]
        var BoxDVDSelected = BoxDVD[BoxDVDControl.selectedSegmentIndex]
        
        // let YourApiKey = "2xb8uzjkngkd5aa58e9j58sw" // Fill with the key you registered at http://developer.rottentomatoes.com
        //        let YourApiKey = "dagqdghwaq3e3mxyrp7kmmj5"
        //        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        
        
        
        var RottenTomatoesURLString =  "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json" // this is Box office
        
        if (BoxDVDSelected == "DVD") {
            RottenTomatoesURLString = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json" // this is DVD
        }
        
        // let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
        
        
        let url = NSURL(string: RottenTomatoesURLString)!
        let request = NSMutableURLRequest(URL: url)
        
        // this first NSURL connection is to fetch JSON
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){(response: NSURLResponse!, data:NSData!, error:NSError!) -> Void in // need to understand this Void In
            
            SVProgressHUD.dismiss()
            println("11111 just dismiss")
            
            if (error != nil) {
                
                self.networkerrorLabel.hidden = false
                println("network error")
            }
            else {
                self.networkerrorLabel.hidden = true
                
                var errorValue: NSError? = nil
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary
                
                if let json = json { // not sure I understand what json = json means, it means if not nil
                    self.movies = json["movies"] as? [NSDictionary] // as! force downcast, or self.movies will just be nil
                    self.tableView.reloadData() // dont understand why this needs to be inside viewDidLoad
                    // println(json)
                }
            }
            self.tableView.dataSource = self // dont understand why this needs to be inside class movieViewController
            self.tableView.delegate = self
            
        }
        
        // need to understand this refresh implementation more
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        

    } // end of reload()
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
 
    
    
    override func didReceiveMemoryWarning() {//?? what's the difference between override func and func
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if let movies = movies { // means not nil
        return movies.count
        }
        else {
        return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        // dont understand what indexPath is and why cast as UITableViewCell; give me a reusable cell; also change as! UITableViewCell to MovieCell; now I have access to titleLabel and synopsysLabel
        
        let movie = movies![indexPath.row] // movie is a local constant, why movies is a NSDirectory from JSON
        
        // cell.textLabel?.text = movie["title"] as? String // why?. why as?, mistake "title"
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        // this second NSURL leveraging AFNetworking call setImageWithURL is to fetch thumbnail
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)! // instead of access movie as directionary, use movie.valueForKey, why as! and why force downcast!
        // valueForKey was wrong
        cell.posterView.setImageWithURL(url) // dont understand this and need to repeat the header.h extension again
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // this func is called if a row is selected, acknowledge and feel free to deslect by leveraging the tableView event
println("111 deselected")
    }
        
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) { // sender is the "thing" that fires the event
// want to setup the title and synopsis in the detailed page when i transition to it
        let cell = sender as! UITableViewCell // downcast to UITableViewCell??? // dont understand what cell is; the cell is what fires off the event
// need to know which row is selected
// the following tableView can tell us which indexPath it is
        let indexPath = tableView.indexPathForCell(cell)! // use this to get the movie
        let movie = movies![indexPath.row]

// now I need to get a handle on the incoming detailed viewcontroller
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController // need to cast it so that I can access the public properties
        movieDetailsViewController.movie = movie
        
        println("I am about to segue") // right before transition to next screen
    }
    
}
