//
//  jsons.swift
//  LoginWindow
//
//  Created by 12dot on 30.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper




//loginWindow
//func jsonPost(login: String, password: String, success: (_ response: AnyObject) -> Void) {
func jsonPost(login: String, password: String,completion: @escaping () -> Void) {

    let params : [String:String] = [
        "username" : login,
        "password" : password
    ]
            
        AF.request("https://moneystats.herokuapp.com/passport/login/", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result{
                    
                case .success(let value):
                        let json = JSON(value)
                        if let token = json["token"].string{
                            //  print(token)
                        KeychainWrapper.standard.set(token, forKey: "accessToken")
                    }
                    
                case .failure(let error):
                    print(error)
                }
             completion()
        }

}




func jsonRegPost(name: String, login: String, email: String, password: String) {
    let params : [String:String] = [
        "name" : name,
        "username" : login,
        "email" : email,
        "password" : password
    ]
    
    AF.request("https://moneystats.herokuapp.com/passport/register/", method: .post, parameters: params, encoding: JSONEncoding.default)
        .responseJSON { response in
            debugPrint(response)
            
    }
}

