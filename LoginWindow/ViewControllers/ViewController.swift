//
//  ViewController.swift
//  LoginWindow
//
//  Created by 12dot on 20.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }

    func setUpElements(){
        Utilities.styleHollowButton(signupButton)
        Utilities.styleFilledButton(loginButton)
    }

}

