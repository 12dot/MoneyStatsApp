//
//  HistoryTableViewController.swift
//  LoginWindow
//
//  Created by 12dot on 19.05.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll



class HistoryTableViewController: UITableViewController {
    var indexPage = Int()
    
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backArrow: UIButton!
    
    
    
    @IBAction func backArrowTapped(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.popViewController(animated: true)
        makeAllClear()
    }
    
    /*
    @IBAction func backArrowTapped(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.popViewController(animated: true)
        makeAllClear()
    }
    */
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.tableView.reloadData()
        }
    }
    /*
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func backArrowTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        makeAllClear()
    }
    
    */
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewDidLoad()
        makeAllClear()
        jsonGetExpenses(page: String(indexPage)){
            self.tableView.reloadData()
        }
        Utilities.styleLittleFilledButton(editButton)
        //navigationTab.barTintColor = .white
        

        self.tableView.allowsSelection = false
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "tableviewloadingcellid")
        self.tableView.register(BandCell.self, forCellReuseIdentifier: "bandCellId")

        
       // for i in 1...20{
         //   itemsArray.append("Item \(String(i))")
        //}
        //for i in 1...20{
          //  moneyArray.append(Double(i))
        //}
        
        
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return expenses.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section <= expenses.count {
            //Return the amount of items
            return 1
       // } else if section == expenses.count+1 {
            //Return the Loading cell
            //return 1
        } else {
            //Return nothing
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
            //if indexPath.section < expenses.count {
                    let cell  = tableView.dequeueReusableCell(withIdentifier: "bandCellId") as! BandCell
                    if(expenses.count <= indexPath.section){
                          cell.textField = "Clear"
                    }else{
                      
                        cell.category = categoriesId.first(where: {$0.id == expenses[indexPath.section].categoryId})?.name
                        cell.money = expenses[indexPath.section].price
                        cell.textField = expenses[indexPath.section].name
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
            /*} else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewloadingcellid", for: indexPath) as! LoadingCell
                cell.activityIndicator.startAnimating()
                //cell.editingStyle e
                return cell
            }*/
    }
    
    // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            jsonDeleteExpenses(id: expenses[indexPath.section].id){
            expenses.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .fade)
            //print(expenses)
            }
         }else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 10
      }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        //let header = view as! UITableViewHeaderFooterView
    
        return headerView
    }

    func makeAllClear(){
        indexPage = 1
        expenses.removeAll()
        isLoading = false
        nextLoading = true
    }
    
   /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section <= itemsArray.count {
            return 44 //Item Cell height
        } else {
            return 55 //Loading Cell height
        }
    }
    */
    
    
/*
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height

            if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading{
                loadMoreData()
            }
    }
  */
    /*
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoading{
            loadMoreData()
        }
    }
    */
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height && !isLoading {
            loadMoreData()
            self.tableView.reloadData()

            // tell the table view to reload with the new data
        }
        
    }
    
    
    func loadMoreData() {
        if !isLoading{
            isLoading = true
            //DispatchQueue.global().async {
                // Fake background loading task for 2 seconds
                self.indexPage = self.indexPage+1
                //sleep(2)
                // Download more data here
                DispatchQueue.main.async {
                    jsonGetExpenses(page: String(self.indexPage) ) {
                        if nextLoading == false{
                            isLoading = true
                        }else {
                        isLoading = false
                        }
                        self.tableView.reloadData()
                    }
                }
            //}
        }
    }
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == expenses.count{return false}else{return true}
    }
    
    /*
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            if indexPath.section == expenses.count{return false}else{return true}
    }*/
    
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}

