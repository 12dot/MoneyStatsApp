//
//  LoginViewController.swift
//  LoginWindow
//
//  Created by 12dot on 20.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit
import JWTDecode
import SwiftyJSON
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backArrow: UIButton!
    
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
            let homeViewController = storyboard?.instantiateViewController(identifier: "homeViewController") as? HomeViewController
            let error = validateField()
            
            if error != nil {
                errorLabel.text = error
                shake(view: errorLabel)
            }
            else{
                self.showSpinner(onView: self.view)
                jsonPost(login: loginText.text!, password: passwordText.text!, viewController: self) {
                    KeychainWrapper.standard.set(self.loginText.text!, forKey: "login")
                    let token: String? = KeychainWrapper.standard.string(forKey: "accessToken")
                    let jwt = try! decode (jwt: token! )
                    let claimEmail = jwt.claim(name: "name")
                    let claimUserId = jwt.claim(name: "user_id")
                    if let userid = claimUserId.integer{
                       KeychainWrapper.standard.set(userid, forKey: "userId")
                       //print(name)
                       //print(jwt.body)
                    }
                    if let name = claimEmail.string{
                        KeychainWrapper.standard.set(name, forKey: "name")
                        //print(name)
                        //print(jwt.body)
                    }
                    //switchRootViewController(rootViewController: homeViewController!, animated: true, completion: nil)
                    self.removeSpinner()
                    self.navigationController?.pushViewController(homeViewController!, animated: true)
                    //UIApplication.shared.windows.first?.rootViewController = homeViewController
                    //UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
                
               
            }
        
        //self.removeSpinner()
    }
    
    
    
    
    @IBAction func backArrowTapped(_ sender: Any) {
        //let viewController = storyboard?.instantiateViewController(identifier: "viewController") as? ViewController
        //viewController?.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(viewController!, animated:  true)
        self.navigationController?.popViewController(animated: true)
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
