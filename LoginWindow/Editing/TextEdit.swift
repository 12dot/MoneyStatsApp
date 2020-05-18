//
//  TextEdit.swift
//  LoginWindow
//
//  Created by 12dot on 23.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import UIKit



class Utilities{
    
    static func styleLittleFilledButton(_ button: UIButton){
        button.backgroundColor = UIColor.init(red: 204/255, green: 0/255, blue: 204/255, alpha: 1)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    

    
    static func styleTextField(_ textField: UITextField){
    
        //create bottomLine
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x:0, y:textField.frame.height - 2, width:textField.frame.width, height:2)
        bottomLine.backgroundColor = UIColor.init(red: 204/255, green: 0/255, blue: 204/255, alpha: 1).cgColor
        
        //remove border
        textField.borderStyle = .none
        
        //add bottomLine to textField
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button : UIButton){
        button.backgroundColor = UIColor.init(red: 204/255, green: 0/255, blue: 204/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        }
    
    static func styleHollowButton(_ button: UIButton){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        
    }
    
    static func isPasswordvalid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}



struct Product {
    var productName : String
    var productImage : UIImage
    var productDesc : String
}
