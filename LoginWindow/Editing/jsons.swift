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


//loginWindow
func jsonPost(login: String, password: String) -> String?{
    let params : [String:String] = [
        "username" : login,
        "password" : password
    ]
        
    var tokenToSave : String? = nil
        AF.request("https://moneystats.herokuapp.com/passport/login/", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result{
                    
                case .success(let value):
                        let json = JSON(value)
                        if let token = json["token"].string{
                            print(token)
                            tokenToSave = token
                    }
                    
                case .failure(let error):
                    print(error)
                }
 
        }
    
    if tokenToSave != nil {return tokenToSave}
    else {return nil}
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

