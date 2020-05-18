//
//  HomeViewController.swift
//  LoginWindow
//
//  Created by 12dot on 20.03.2020.
//  Copyright © 2020 12dot. All rights reserved.
//
import UIKit
import SwiftKeychainWrapper
import Charts
import TinyConstraints


var categories = ["Mall", "Car", "Education", "Sigarettes"]
var moneySpent = [3456.0, 1234.0, 1900.0, 3200.0 ]



class HomeViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var budgetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //func for waiting for token
        
       
        
        
        //setting up all
        setupWelcomeLbl()
        setUpTable()
        setUpChart()
        setUpElements()
        setUpBudgetlbl()
            
    }
    
    
    
    func setUpElements(){
        Utilities.styleLittleFilledButton(moreButton)
        Utilities.styleHollowButton(logoutButton)
        Utilities.styleFilledButton(addItemButton)
    }
    
   // func setUpPlacement(){    }
    
    //setup Butget label
    func setUpBudgetlbl(){
        let budget = 11300.0
        var budgetSpend = 0.0;
        //budgetLabel.layer.borderColor = UIColor.init(red: 204/255, green: 0/255, blue: 204/255, alpha: 1).cgColor
        //budgetLabel.layer.borderWidth = 2

        for i in 0...moneySpent.count-1{
            budgetSpend = budgetSpend + moneySpent[i]
        }
        let myString =  "Your budget is \(String(budget)) rubles\r\rYou spent \(String(budgetSpend)) rubles"
        var myMutableString = NSMutableAttributedString()
        let attributes : [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15)
        
            //.foregroundColor: UIColor.red
        ]
        //butgetLabel.textColor = UIColor.white
        myMutableString = NSMutableAttributedString(string: myString, attributes: attributes)
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20), range: NSRange(location:15,length:String(budget).count))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location:15,length:String(budget).count))
        myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20), range: NSRange(location:34+String(budget).count ,length:String(budgetSpend).count))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:34+String(budget).count ,length:String(budgetSpend).count))
        budgetLabel.attributedText = myMutableString
        
        
        
        //butgetLabel.text = "Your butget is \(String(butget)) rubles \rYou spent \(String(butgetSpend))"
    }

    
    //setting up label
    func setupWelcomeLbl(){
        let name: String? = KeychainWrapper.standard.string(forKey: "name")
        if let someName = name {
            welcomeLabel.text = "Welcome, \(someName)"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //self.welcomeLabel.isHidden = true
            UIView.transition(with: self.welcomeLabel,
                 duration: 0.25,
                  options: .transitionCrossDissolve,
               animations: { [weak self] in
                   self?.welcomeLabel.text = "Your finance:"
            }, completion: nil)
        }
    }
    
    
    
    //setting up chart
    func setUpChart(){
        
        pieChart.animate(xAxisDuration: 3.0)
        pieChart.animate(yAxisDuration: 3.0)
        pieChart.chartDescription?.enabled = false
        //pieChart.drawHoleEnabled = false
        //pieChart.rotationAngle = 0
        //pieChart.rotationEnabled = false
        pieChart.isUserInteractionEnabled = false
        pieChart.legend.enabled = false
    
        
        var entries : [PieChartDataEntry] = Array()
        
        
        for i in 0..<categories.count{
            entries.append(PieChartDataEntry(value: moneySpent[i] , label: categories[i]))
        }
    
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        var colors: [UIColor] = []
        
        for _ in 0..<moneySpent.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        dataSet.colors = colors
        
        pieChart.data = PieChartData(dataSet: dataSet)
    }
    

    
   //setting Up TableView
    func setUpTable(){
        
        tableView.separatorColor = UIColor.init(red: 204/255, green: 0/255, blue: 204/255, alpha: 1)
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BandCell.self, forCellReuseIdentifier: "bandCellId")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
            
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "bandCellId") as! BandCell
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.money = moneySpent[indexPath.section]
        cell.textField = categories[indexPath.section]
        cell.layoutSubviews()
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.init(red: 204/255, green: 0/255, blue: 204/255, alpha: 1).cgColor
        cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        //let header = view as! UITableViewHeaderFooterView
    
        return headerView
    }
    
    /*func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.init(red: 204/255, green: 0/255, blue: 204/255, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white

    }*/
   
    
    @IBAction func moreButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func addNewItemButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeAllKeys()
        //let viewController = storyboard?.instantiateViewController(identifier: "viewController") as? ViewController
        //switchRootViewController(rootViewController: viewController!, animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}




//custom Cell
class BandCell: UITableViewCell{
    
    var textField : String?
    var money : Double?
    
 
    var mainTextView : UITextField = {
       var textView = UITextField()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .boldSystemFont(ofSize: 15)
        return textView
    }()
    
    
    var mainMoneyView : UITextField = {
       var moneyView = UITextField()
        moneyView.translatesAutoresizingMaskIntoConstraints = false
        moneyView.font = .boldSystemFont(ofSize: 15)
        return moneyView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainTextView)
        self.addSubview(mainMoneyView)
        
        //mainTextView.leftToSuperview()
        
        //mainTextView.frame = CGRect(x:50, y:2, width: 100, height: 10)
        //mainTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        //mainTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainTextView.centerYToSuperview()
        mainTextView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10 ).isActive = true
        

        
        //mainMoneyView.rightToSuperview()
        mainMoneyView.centerYToSuperview()
        mainMoneyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        //mainTextView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: 10 ).isActive = true
        //mainTextView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor).isActive = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let textField = textField {
            mainTextView.text = textField
        }
        if let money = money{
           mainMoneyView.text = String(money) + " rub"
        }
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    
}
