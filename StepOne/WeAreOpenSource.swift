//
//  WeAreOpenSource.me.swift
//  StepOne
//
//  Created by RYPE on 28/04/2015.
//  Copyright (c) 2015 RYPE. All rights reserved.
//

import UIKit

class WeAreOpenSource: UIViewController, ENSideMenuDelegate {
    
    /*************************************************/
    // Main
    /*************************************************/
    
    // Boulet
    /*************************/
    @IBOutlet weak var imgWaos: UIImageView!
    
    // Base
    /*************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // custom
        // ---------------------
        self.imgWaos.layer.cornerRadius = self.imgWaos.frame.size.width / 2
        self.imgWaos.clipsToBounds = true
        // ---------------------

    }
    
    
    /*************************************************/
    // Functions
    /*************************************************/
    
    // Segue
    /*************************/
    @IBAction func toogleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}