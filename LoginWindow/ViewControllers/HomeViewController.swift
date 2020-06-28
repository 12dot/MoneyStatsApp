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
import AudioToolbox



var categories = ["Mall", "Car", "Education", "Sigarettes"]
var moneySpent = [3456.0, 1234.0, 1900.0, 3200.0]





class HomeViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{
 
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var budgetLabel: UILabel!
    var picker = UIPickerView()
    var categoryIdAdd = Int()
    var alertController = UIAlertController()
    var refreshControl = UIRefreshControl()


    
    override func viewDidLoad() {
        //picker for category
        picker.delegate = self
        picker.dataSource = self
        loadJsons()
        super.viewDidLoad()
        //func for waiting for token
        
        //pull to refresh


      
        
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
    
    
    func loadJsons(){
        categoriesId = []
        jsonCategories {
        }
        jsonGetExpensesHome(){
            self.tableView.reloadData()
        }
    }
    
    
   // func setUpPlacement(){    }
    
    
    
    
    //setup Butget label
    func setUpBudgetlbl(){
        
        budgetLabel.alpha = 0
        /*
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
*/
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
        
        var entries : [PieChartDataEntry] = Array()
        
        chartStats.removeAll()
        jsonChart{
            for item in chartStats{
                entries.append(PieChartDataEntry(value: item.total , label: item.name))
            }
            self.pieChart.animate(xAxisDuration: 3.0)
            self.pieChart.animate(yAxisDuration: 3.0)
            self.pieChart.chartDescription?.enabled = false
                //pieChart.drawHoleEnabled = false
                //pieChart.rotationAngle = 0
                //pieChart.rotationEnabled = false
            self.pieChart.isUserInteractionEnabled = false
            self.pieChart.legend.enabled = false
                
              /*
                for i in 0..<categories.count{
                    entries.append(PieChartDataEntry(value: moneySpent[i] , label: categories[i]))
                }
            */
                
            let dataSet = PieChartDataSet(entries: entries, label: "")
            
            var colors: [UIColor] = []
            
            for _ in 0..<chartStats.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
            
            dataSet.colors = colors
            
            self.pieChart.data = PieChartData(dataSet: dataSet)
        }
        
        
    }
    

    
   //setting Up TableView
    func setUpTable(){
        
        expensesHome.removeAll()
            
        self.tableView.separatorColor = mainPurple
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(BandCell.self, forCellReuseIdentifier: "bandCellId")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
                    
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "bandCellId") as! BandCell
        if(expensesHome.count <= indexPath.section){
            cell.textField = "Clear"
        }else{
            
            cell.category = categoriesId.first(where: {$0.id == expensesHome[indexPath.section].categoryId})?.name
            cell.money = expensesHome[indexPath.section].price
            cell.textField = expensesHome[indexPath.section].name
        }
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        //cell.money = expenses[indexPath.section].price
        //cell.textField = expenses[indexPath.section].name
        
        //cell.money = moneySpent[indexPath.section]
        //cell.textField = categories[indexPath.section]
        cell.layoutSubviews()
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = mainPurple.cgColor
        cell.layer.borderWidth = 5
        cell.layer.cornerRadius = 22
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
        //historyTableViewController
        let historyTableViewController = storyboard?.instantiateViewController(identifier: "historyTableViewController") as? HistoryTableViewController
        //historyTableViewController?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(historyTableViewController!, animated:  true)
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return categoriesId.count
     }
    
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return categoriesId[row].name
     }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryIdAdd = categoriesId[row].id
        alertController.textFields?[2].text = categoriesId[row].name
                    
    }
    
    
    

    @IBAction func addNewItemButtonTapped(_ sender: Any) {
        alertController = UIAlertController(title: "Create new item", message: nil, preferredStyle: .alert)
        
        self.alertController.addTextField { (textField) in
            textField.placeholder = "New item name"
         }
        self.alertController.addTextField { (textField) in
            textField.placeholder = "Money spent"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        self.alertController.addTextField { (textField) in
            //textField.tag = 12345
            textField.placeholder = "Category"
            textField.inputView = self.picker
            //textField.text = self.pickerString
            //textField.isUserInteractionEnabled = false
            
        }
        let alertAction1 = UIAlertAction(title: "Cancel", style: .default){ (alert) in
            return
        }
         let alertAction2 = UIAlertAction(title: "Create", style: .cancel){ (alert) in
            let name = self.alertController.textFields![0].text
            guard let price = Double(self.alertController.textFields![1].text!)else{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                return
            }
            //let category = self.categoryIdAdd

            if (name?.trimmingCharacters(in: .whitespaces).isEmpty )! || (self.categoryIdAdd==0) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                return
             } else {
                jsonPostExpence(name: name!, price: price, category: self.categoryIdAdd, viewController: self){
                    self.setUpChart()
                    self.setUpTable()
                    jsonGetExpensesHome {
                        self.tableView.reloadData()
                    }
                }
                return
             }
         }
         
        self.alertController.addAction(alertAction1)
        self.alertController.addAction(alertAction2)
        present(self.alertController, animated: true, completion: nil)

    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeAllKeys()
        //let viewController = storyboard?.instantiateViewController(identifier: "viewController") as? ViewController
        //switchRootViewController(rootViewController: viewController!, animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
        expensesHome.removeAll()
    }

}
