//
//  LoginViewController.swift
//  LoginWindow
//
//  Created by 12dot on 20.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha=0;
        Utilities.styleTextField(loginText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        //validate fields
            
            let error = validateField()
            
            if error != nil {
                errorLabel.text = error
                shake(view: errorLabel)
            }
            else{
                
                jsonPost(login : loginText.text!, password: passwordText.text!)
                let homeViewController = storyboard?.instantiateViewController(identifier: "ViewControllerHome") as? HomeViewController
                view.window?.rootViewController = homeViewController
                view.window?.makeKeyAndVisible()
            }
    }
    
    
    func validateField() -> String? {
        
        //check all fields are filled
        if loginText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        return nil
        }
    
}
