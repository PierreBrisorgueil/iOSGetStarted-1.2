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
    @IBOutlet weak var labelWaos: UILabel!
    @IBOutlet weak var sublabelWaos: UILabel!
    
    // Base
    /*************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        // custom
        // ---------------------
        self.imgWaos.layer.cornerRadius = self.imgWaos.frame.size.width / 2
        self.imgWaos.clipsToBounds = true
        // ---------------------
        
        // animation
        // ---------------------
        // img
        imgWaos.alpha = 0
        UIView.animateWithDuration(0.3, delay: 0.3,
            options: nil, animations: {
                self.imgWaos.alpha = 1
            }, completion: { _ in
                UIView.animateWithDuration(1, delay: 0,
                    options: nil, animations: {
                        self.imgWaos.alpha = 0.9
                    }, completion: nil)
        })

        // slide & alpha labels
        labelWaos.alpha = 0.3
        labelWaos.center.x += view.bounds.width
        UIView.animateWithDuration(0.3, delay: 0.3,
            options: nil, animations: {
                self.labelWaos.center.x -= self.view.bounds.width
            }, completion: { _ in
                UIView.animateWithDuration(0.3, delay: 0,
                    options: nil, animations: {
                        self.labelWaos.alpha = 1
                    }, completion: nil)
        })
        sublabelWaos.alpha = 0.3
        sublabelWaos.center.x += view.bounds.width
        UIView.animateWithDuration(0.3, delay: 0.4,
            options: nil, animations: {
                self.sublabelWaos.center.x -= self.view.bounds.width
            }, completion: { _ in
                UIView.animateWithDuration(0.3, delay: 0,
                    options: nil, animations: {
                        self.sublabelWaos.alpha = 0.8
                    }, completion: nil)
        })
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