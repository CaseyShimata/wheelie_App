//
//  TabBarController.swift
//  Stunt
//
//  Created by Casey Shimata on 4/27/17.
//  Copyright © 2017 Casey Shimata. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, HomeDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func home() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
