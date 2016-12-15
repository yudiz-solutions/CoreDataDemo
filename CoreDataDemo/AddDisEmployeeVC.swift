//
//  AddDisEmployeeVC.swift
//  CoreDataDemo
//
//  Created by Yudiz on 12/15/16.
//  Copyright © 2016 Yudiz. All rights reserved.
//

import UIKit

class CustButton: UIButton {
    var idxPath: IndexPath = []
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class AddDisEmployeeVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var btnAdd: CustButton!
    
    var employees: [Employee] = []
    var isUpdating: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployeeFromCoreData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - Action
extension AddDisEmployeeVC{
    @IBAction func btnAddEmployeeTap(sender: UIButton){
        if !tfName.text!.isEmpty{
            if btnAdd.titleLabel?.text == "Update"{
                btnAdd.setTitle("Add", for: UIControlState.normal)
                updateEmployee(name: tfName.text!,idx: btnAdd.idxPath)
            }else{
                addEmployee(name: tfName.text!)
            }
            tfName.text = ""
        }
    }
    
    @IBAction func deleteBtnTap(sender: UIButton){
        self.view.endEditing(true)
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
        }else{
            tableView.setEditing(true, animated: true)
        }
    }
}

// MARK: - tableview methods
extension AddDisEmployeeVC: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = employees[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteEmployee(idx: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delAct = UITableViewRowAction.init(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { (action, index) in
            self.deleteEmployee(idx: index)
        })
        
        let updateAct = UITableViewRowAction.init(style: UITableViewRowActionStyle.normal, title: "Update", handler: { (action, index) in
            self.tfName.becomeFirstResponder()
            self.tfName.text = self.employees[index.row].name
            self.tableView.setEditing(false, animated: true)
            self.btnAdd.setTitle("Update", for: UIControlState.normal)
            self.btnAdd.idxPath = index
        })
        return[delAct,updateAct]
    }
}

// CoreData operations
extension AddDisEmployeeVC{

    func fetchEmployeeFromCoreData(){
        employees = Employee.fetchDataFromEntity(predicate: nil, sortDescs: nil)
        tableView.reloadData()
    }
    
    func addEmployee(name: String){
        let emp = Employee.createNewEntity()
        emp.name = name
        _appDelegator.saveContext()
        employees.append(emp)
        tableView.reloadData()
    }
    
    func updateEmployee(name: String, idx: IndexPath){
        let emp = employees[idx.row]
        emp.name = name
        _appDelegator.saveContext()
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func deleteEmployee(idx: IndexPath){
        _appDelegator.managedObjectContext.delete(employees[idx.row])
        _appDelegator.saveContext()
        employees.remove(at: idx.row)
        tableView.deleteRows(at: [idx], with: .middle)
    }
}
