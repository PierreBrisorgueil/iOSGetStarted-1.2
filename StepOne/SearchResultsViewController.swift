//
//  ViewController.swift
//  StepOne
//
//  Created by WeAreOpenSource.me on 24/04/2015.
//  Copyright (c) 2015 WeAreOpenSource.me rights reserved.
//

// tuto : http://jamesonquave.com/blog/developing-ios-8-apps-using-swift-animations-audio-and-custom-table-view-cells/

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, ENSideMenuDelegate {

    /*************************************************/
    // Main
    /*************************************************/

    // Boulet
    /*************************/
    @IBOutlet weak var appsTableView: UITableView!
    @IBOutlet weak var mytable: UITableView!
    
    // Var
    /*************************/
    var albums = [Album]()
    var imageCache = [String:UIImage]()
    var api : APIController!
    let kCellIdentifier: String = "SearchResultCell"
    var refreshControl:UIRefreshControl!

    // Base
    /*************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // custom
        // ---------------------
        self.mytable.rowHeight = 70
        self.mytable.backgroundView = UIImageView(image: UIImage(named: "home.jpg"))
        // ---------------------

        // get data
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Beatles")
        
        //Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.mytable.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TableView
    /*************************/
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        let album = self.albums[indexPath.row]
        
        // Get the formatted price string for display in the subtitle
        cell.detailTextLabel?.text = album.price
        // Update the textLabel text to use the title from the Album model
        cell.textLabel?.text = album.title
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let thumbnailURLString = album.thumbnailImageURL
        let thumbnailURL = NSURL(string: thumbnailURLString)!
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.imageView?.image = img
        }
        else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: NSURLRequest = NSURLRequest(URL: thumbnailURL)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Store the image in to our cache
                    self.imageCache[thumbnailURLString] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                            // animation
                            // ---------------------
                            cellToUpdate.imageView?.alpha = 0
                            UIView.animateWithDuration(0.3, delay: 0.2,
                                options: nil, animations: {
                                    cellToUpdate.imageView?.alpha = 1
                                }, completion: nil)
                            // ---------------------
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        
        // custom
        // ---------------------
        cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        cell.detailTextLabel?.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)

        let customColorView = UIView()
        customColorView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        cell.selectedBackgroundView = customColorView
        // ---------------------

        // animation
        // ---------------------
        cell.textLabel?.alpha = 0.3
        cell.textLabel?.center.x += view.bounds.width
        UIView.animateWithDuration(0.3, delay: 0.1,
            options: nil, animations: {
                cell.textLabel?.center.x -= self.view.bounds.width
            }, completion: { _ in
                UIView.animateWithDuration(0.3, delay: 0,
                    options: nil, animations: {
                        cell.textLabel?.alpha = 1
                    }, completion: nil)
        })

        cell.detailTextLabel?.alpha = 0.3
        cell.detailTextLabel?.center.x += view.bounds.width
        UIView.animateWithDuration(0.3, delay: 0.3,
            options: nil, animations: {
                cell.detailTextLabel?.center.x -= self.view.bounds.width
            }, completion: { _ in
                UIView.animateWithDuration(0.3, delay: 0,
                    options: nil, animations: {
                        cell.detailTextLabel?.alpha = 1
                    }, completion: nil)
        })
        // ---------------------
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }

    // Segue
    /*************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: DetailsViewController = segue.destinationViewController as? DetailsViewController {
            var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
            var selectedAlbum = self.albums[albumIndex]
            detailsViewController.album = selectedAlbum
        }
    }
    
    /*************************************************/
    // Functions
    /*************************************************/
    
    // Segue
    /*************************/
    @IBAction func toogleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // Other
    /*************************/
    func refresh(sender:AnyObject)
    {
        // get data
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Beatles")
    }

    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(results)
            self.appsTableView!.reloadData()
            self.refreshControl.endRefreshing()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
}

