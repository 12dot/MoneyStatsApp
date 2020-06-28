//
//  Constants\.swift
//  LoginWindow
//
//  Created by 12dot on 15.04.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation
import UIKit
import TinyConstraints

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


let mainPurple = hexStringToUIColor(hex: "#9b59b6")
//let purpleColor = UIColor(#9b59b6)

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

struct ChartStats {
    var category_id: Int
    var name : String
    var total : Double
    
    
    init?(json: [String: Any]) {

         guard
            let total = json["total"] as? Double,
            let name = json["name"] as? String,
            let category_id = json["category_id"] as? Int
        else {
            return nil
        }

        self.category_id = category_id
        self.total = total
        self.name = name
    }
    
}


struct Categories{
    var id: Int
    var name : String
    
    
    init?(json: [String: Any]) {

        guard
            let name = json["name"] as? String,
            let id = json["id"] as? Int
        else {
            return nil
        }

        self.id = id
        self.name = name
    }
    
}


struct Expense{
    var name: String
    var categoryId : Int
    var price : Double
    var id : Int
    
    
    init?(json: [String: Any]) {

         guard
            let price = json["price"] as? Double,
            let name = json["name"] as? String,
            let categoryId = json["category"] as? Int,
            let id = json["id"] as? Int
        else {
            return nil
        }

        self.price = price
        self.categoryId = categoryId
        self.name = name
        self.id = id
    }
    
}

//custom Cell
class BandCell: UITableViewCell{
    
    var textField : String?
    var money : Double?
    var category : String?
    
 
    var mainTextView : UITextField = {
        var textView = UITextField()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .boldSystemFont(ofSize: 15)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    
    var mainMoneyView : UITextField = {
        var moneyView = UITextField()
        moneyView.translatesAutoresizingMaskIntoConstraints = false
        moneyView.font = .boldSystemFont(ofSize: 15)
        moneyView.isUserInteractionEnabled = false
        return moneyView
    }()
    
    var mainCategoryView : UITextField = {
        var categoryView = UITextField()
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.font = .boldSystemFont(ofSize: 10)
        categoryView.textColor = UIColor.gray
        categoryView.isUserInteractionEnabled = false
        return categoryView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainTextView)
        self.addSubview(mainMoneyView)
        self.addSubview(mainCategoryView)
        
        //mainCategoryView.textColor = UIColor.gray
        //mainCategoryView.centerYToSuperview()
        mainCategoryView.centerInSuperview()
        
        mainTextView.centerYToSuperview()
        mainTextView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10 ).isActive = true
       
        mainMoneyView.centerYToSuperview()
        mainMoneyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
       
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let textField = textField {
            mainTextView.text = textField
        }
        if let money = money{
           mainMoneyView.text = String(money) + " rub"
        }
        
        if let category = category {
            mainCategoryView.text = category
        }
        
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    
}



