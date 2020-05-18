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
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let loginViewController = storyboard?.instantiateViewController(identifier: "loginViewController") as? LoginViewController
        loginViewController?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(loginViewController!, animated:  true)
        
    }
    
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        let signupViewController = storyboard?.instantiateViewController(identifier: "signupViewController") as? SignUpViewController
        signupViewController?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signupViewController!, animated:  true)
    }
    
    
    
    
}

