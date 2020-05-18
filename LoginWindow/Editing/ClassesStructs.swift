//
//  Constants\.swift
//  LoginWindow
//
//  Created by 12dot on 15.04.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation


struct UserConstants{
    
    var username : String
    var login: String
    var token: String
    var email : String
    

    init(){
        self.username = ""
        self.login = ""
        self.email = ""
        self.token=""
    }
    
    init(name:String, login:String, email:String, token: String){
        self.username = name;
        self.login = login;
        self.email = email;
        self.token = token;
    }
}



var userConstants = UserConstants()

