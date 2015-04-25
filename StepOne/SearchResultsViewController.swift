//
//  ViewController.swift
//  StepOne
//
//  Created by WeAreOpenSource.me on 24/04/2015.
//  Copyright (c) 2015 WeAreOpenSource.me rights reserved.
//

// tuto : http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-4-adding-interactions/

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    /*************************************************/
    // Main
    /*************************************************/

    // Boulet
    /*************************/
    @IBOutlet weak var appsTableView: UITableView!
    
    // Var
    /*************************/
    var tableData = []
    let api = APIController()
    let kCellIdentifier: String = "SearchResultCell"

    // Base
    /*************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.delegate = self
        api.searchItunesFor("La Baule")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TableView
    /*************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Download an NSData representation of the image at the URL
            imgData = NSData(contentsOfURL: imgURL),
            // Get the track name
            trackName = rowData["trackName"] as? String {
            // Get the formatted price string for display in the subtitle
            cell.detailTextLabel?.text = formattedPrice
            // Update the imageView cell to use the downloaded image data
            cell.imageView?.image = UIImage(data: imgData)
            // Update the textLabel text to use the trackName from the API
            cell.textLabel?.text = trackName
        }
        return cell
    }
    // TableView Cell selection
    /*************************/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        if let rowData = self.tableData[indexPath.row] as? NSDictionary,
            // Get the name of the track for this row
            name = rowData["trackName"] as? String,
            // Get the price of the track on this row
            formattedPrice = rowData["formattedPrice"] as? String {
                let alert = UIAlertController(title: name, message: formattedPrice, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*************************************************/
    // Functions
    /*************************************************/
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }
    
}

