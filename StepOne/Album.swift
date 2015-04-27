//
//  ViewController.swift
//  StepOne
//
//  Created by WeAreOpenSource.me on 24/04/2015.
//  Copyright (c) 2015 WeAreOpenSource.me rights reserved.
//

// tuto : http://jamesonquave.com/blog/developing-ios-8-apps-using-swift-animations-audio-and-custom-table-view-cells/

import Foundation

struct Album {
    let title: String
    let price: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let itemURL: String
    let artistURL: String
    let collectionId: Int
    let primaryGenreName: String
    let artistName: String
    let country: String
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int, primaryGenreName: String, artistName: String, country: String) {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
        self.primaryGenreName = primaryGenreName
        self.artistName = artistName
        self.country = country
    }
    
    /*************************************************/
    // Functions
    /*************************************************/
    static func albumsWithJSON(results: NSArray) -> [Album] {
        // Create an empty array of Albums to append to from this list
        var albums = [Album]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in results {
                
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                        else {
                            price = ""
                        }
                    }
                }
                
                //let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                // more information
                let primaryGenreName = result["primaryGenreName"] as? String ?? ""
                let artistName = result["artistName"] as? String ?? ""
                let country = result["country"] as? String ?? ""

                
                // tricks for get a good image quality
                let BigimageURL = imageURL.stringByReplacingOccurrencesOfString(".100x100-", withString: ".300x300-", options: nil, range: nil)
                
                // thumbnailURL bad quality .. 60x60, su we use imageURL
                if let collectionId = result["collectionId"] as? Int {
                    var newAlbum = Album(name: name!,
                        price: price!,
                        thumbnailImageURL: imageURL,
                        largeImageURL: BigimageURL,
                        itemURL: itemURL!,
                        artistURL: artistURL,
                        collectionId: collectionId,
                        primaryGenreName: primaryGenreName,
                        artistName: artistName,
                        country: country)
                    albums.append(newAlbum)
                }
            }
        }
        return albums
    }
    
}
