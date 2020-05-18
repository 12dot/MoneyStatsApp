//
//  SignUpViewController.swift
//  LoginWindow
//
//  Created by 12dot on 22.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backArrow: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailText)
        Utilities.styleTextField(loginText)
        Utilities.styleTextField(firstNameText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(registerButton)
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
        //let viewController = storyboard?.instantiateViewController(identifier: "viewController") as? ViewController
        //viewController?.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(viewController!, animated:  true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func validateField() -> String? {
        
        //check all fields are filled
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
        return "Please fill all the fields."
        }
        
        //check if password is correct
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordvalid(cleanedPassword) == false{
            return "Incorrect password"
        }
        
        return nil
        }
    

    
    @IBAction func registerButtonTapped(_ sender: Any) {
        //validate fields
        let error = validateField()
        
        if error != nil {
            errorLabel.text = error
            shake(view: errorLabel)
        }
        else{
            
            jsonRegPost(name: firstNameText.text!, login: loginText.text!, email: emailText.text!, password: passwordText.text!)
            
       /*
            let startViewController = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController
                           view.window?.rootViewController = startViewController
                           view.window?.makeKeyAndVisible()
         */
            self.navigationController?.popViewController(animated: true)
        }
        
    }
        
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


