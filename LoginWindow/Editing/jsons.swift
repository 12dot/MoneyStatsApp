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



//completionHandler: (String?, ErrorType?) -> ()
//loginWindow
//func jsonPost(login: String, password: String, success: (_ response: AnyObject) -> Void) {
func jsonPost(login: String, password: String, viewController : UIViewController,completion: @escaping () -> Void) {

    
    let params : [String:String] = [
        "username" : login,
        "password" : password
    ]
  
    AF.request("https://moneystats.herokuapp.com/passport/login/", method: .post, parameters: params, encoding: JSONEncoding.default)
        .responseJSON { response in
            //print(response)
              
                switch response.result{
                
                case .success(let value):
                    //debugPrint(value)
                    let json = JSON(value)
                    if let error = json["error"].string {
                        print(error)
                        viewController.removeSpinner()
                        return
                    }else
                        if let token = json["token"].string{
                            //  print(token)
                        KeychainWrapper.standard.set(token, forKey: "accessToken")
                    }else {
                            viewController.removeSpinner()
                            return
                    }
                            
                    
                    case .failure(let error):
                        viewController.removeSpinner()
                        print(error)
                        return
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
            //debugPrint(response)
            
    }
}

var chartStats : [ChartStats] = []


func jsonChart(completion: @escaping () -> Void){
    
    
    let token : String? = KeychainWrapper.standard.string(forKey: "accessToken")
    let accessToken = "JWT " + token!
    
    //let headers = ["Authorization" : accessToken]
    let headers : HTTPHeaders = ["Authorization" : accessToken]
    
    
    AF.request("https://moneystats.herokuapp.com/api/diagram/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {response in
            switch response.result{
                
            case .success(let value):
                guard let jsonArray = value as? Array<[String: Any]> else { return }
                
                for jsonObject in jsonArray{
                    guard let categoryChart = ChartStats(json: jsonObject)else {return}
                    chartStats.append(categoryChart)
                }
                //print(chartStats)
                
            case .failure(let error):
                print(error)
            }
        completion()
        }

}



var categoriesId : [Categories] = []


func jsonCategories(completion: @escaping () -> Void){
    
    
    let token : String? = KeychainWrapper.standard.string(forKey: "accessToken")
    let accessToken = "JWT " + token!
    
    //let headers = ["Authorization" : accessToken]
    let headers : HTTPHeaders = ["Authorization" : accessToken]
    
    
    AF.request("https://moneystats.herokuapp.com/api/categories/list", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {response in
            switch response.result{
                
            case .success(let value):
                //print(value)
                guard let jsonArray = value as? [String: AnyObject] else { return }
                
                guard let results = jsonArray["results"] as? Array<[String: AnyObject]> else { return }
                
                for jsonObject in results{
                    guard let category = Categories(json: jsonObject)else {return}
                    categoriesId.append(category)
                }
                //print(chartStats)
                
            case .failure(let error):
                print(error)
            }
        completion()
        }

}



func jsonPostExpence(name: String, price: Double, category: Int, viewController : UIViewController,completion: @escaping () -> Void) {
    viewController.showSpinner(onView: viewController.view)
    
    let token : String? = KeychainWrapper.standard.string(forKey: "accessToken")
    let accessToken = "JWT " + token!
    let headers : HTTPHeaders = ["Authorization" : accessToken]
    
    let user: Int? = KeychainWrapper.standard.integer(forKey: "userId")
    let params : [String:Any] = [
        "name" : name,
        "price" : price,
        "category": category,
        "user": user!
    ]
  
    AF.request("https://moneystats.herokuapp.com/api/expenses/create/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
        .responseJSON { response in
            //print(response)
              
                switch response.result{
                    case .success(let value):
                        //print(value)
                        //debugPrint(value)
                        viewController.removeSpinner()
                        let json = JSON(value)
                        if let error = json["error"].string {
                            print(error)
                            return
                        }else {
                            completion()
                        }
                                
                    
                    case .failure(let error):
                    viewController.removeSpinner()
                    print(error)
                    return
 
                }
        }

}

var expensesHome : [Expense] = []

func jsonGetExpensesHome(completion: @escaping () -> Void){
    
    
    let token : String? = KeychainWrapper.standard.string(forKey: "accessToken")
    let accessToken = "JWT " + token!
    
    //let headers = ["Authorization" : accessToken]
    let headers : HTTPHeaders = ["Authorization" : accessToken]
    
    
    AF.request("https://moneystats.herokuapp.com/api/expenses/list/?limit=3", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {response in
            switch response.result{
                
            case .success(let value):
                guard let jsonArray = value as? [String: AnyObject] else { return }
                
                guard let results = jsonArray["results"] as? Array<[String: AnyObject]> else { return }
                
                for jsonObject in results{
                    guard let expense = Expense(json: jsonObject)else{return}
                    expensesHome.append(expense)
                }
                //tableView.reloadData()
                //print(chartStats)
                
            case .failure(let error):
                print(error)
            }
        completion()
        }
}



var expenses : [Expense] = []
var loadMoreStatus = false
var isLoading = Bool()
var nextLoading = true

func jsonGetExpenses(page: String, completion: @escaping () -> Void){
    
    let token : String? = KeychainWrapper.standard.string(forKey: "accessToken")
    let accessToken = "JWT " + token!
    
    //let headers = ["Authorization" : accessToken]
    let headers : HTTPHeaders = ["Authorization" : accessToken]
    var linkAdds : String = "&page="
    if page == "1"{
        linkAdds = ""
    }else{linkAdds = linkAdds+page}
    let link = "https://moneystats.herokuapp.com/api/expenses/list/?limit=15"
    
    AF.request(link+linkAdds, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {response in
            switch response.result{
                
            case .success(let value):
                //print(value)
                let json = JSON(value)
                guard let jsonArray = value as? [String: AnyObject] else { return }
                
                guard let results = jsonArray["results"] as? Array<[String: AnyObject]> else { return }
                
                
                //guard let nullCheker = jsonArray["next"] as? String? else {return}
                //print(nullCheker)
                //if nullCheker == "<null>"{
                    //nextChecker = false
                //}
                for jsonObject in results{
                    guard let expense = Expense(json: jsonObject)else{return}
                    expenses.append(expense)
                }
                if let nullCheker = json["next"].string {} else {
                    nextLoading = false
                }
                //tableView.reloadData()
                //print(chartStats)
                
            case .failure(let error):
                print(error)
            }
        completion()
        }
}


//Вот ссылка: /api/expenses/detail/айди цифрой/
func jsonDeleteExpenses(id: Int, completion: @escaping () -> Void){
    
    let token : String? = KeychainWrapper.standard.string(forKey: "accessToken")
    let accessToken = "JWT " + token!
    
    //let headers = ["Authorization" : accessToken]
    let headers : HTTPHeaders = ["Authorization" : accessToken]
   
    let link = "https://moneystats.herokuapp.com/api/expenses/detail/"+String(id)+"/"
    
    
    AF.request(link, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON {response in
            switch response.result{
            case .success(let value):
                //print(value)
                print(response.result)
                
            case .failure(let error):
                print(error)
            }
        completion()
        }
}
