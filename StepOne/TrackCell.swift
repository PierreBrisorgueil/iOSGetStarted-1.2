//
//  ViewController.swift
//  StepOne
//
//  Created by WeAreOpenSource.me on 24/04/2015.
//  Copyright (c) 2015 WeAreOpenSource.me rights reserved.
//

// tuto : http://jamesonquave.com/blog/developing-ios-8-apps-using-swift-animations-audio-and-custom-table-view-cells/


import UIKit

class TrackCell: UITableViewCell {
    
    /*************************************************/
    // Main
    /*************************************************/
    
    // Boulet
    /*************************/
    @IBOutlet weak var playIcon: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Base
    /*************************/
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
