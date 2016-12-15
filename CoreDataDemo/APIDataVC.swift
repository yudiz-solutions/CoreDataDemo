//
//  APIDataVC.swift
//  CoreDataDemo
//
//  Created by Yudiz on 12/15/16.
//  Copyright © 2016 Yudiz. All rights reserved.
//

//
//  EmployeeListVC.swift
//  CoreDataDemo
//
//  Created by Yudiz on 12/15/16.
//  Copyright © 2016 Yudiz. All rights reserved.
//

import UIKit

class APIDataVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserList()
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

// MARK: - Webservice methods
extension APIDataVC{
    func getUserList(){
        
        let desc = NSSortDescriptor(key: "id", ascending: true)
        users = User.fetchDataFromEntity(predicate: nil, sortDescs: [desc])
        tableView.reloadData()
        
        // Get Data From API
        KPWebCall.call.getUserList { (json, code) in
            if code == 200{
                if let data = json as? NSDictionary{
                    if let arr = data["employeeList"] as? [NSDictionary]{
                        var tempArr: [User] = []
                        for dic in arr{
                            let user = User.addUpdateEntity(key: "id", value: dic.getStringValue(key: "id") as NSString)
                            user.initWith(data: dic)
                            tempArr.append(user)
                            _appDelegator.saveContext()
                        }
                        
                        // Delete Old Object from coreData
                        User.deleteRemovedObject(oldObjs: self.users, newObjs: tempArr)
                        self.users = tempArr
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - Tableview methods
extension APIDataVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = users[indexPath.row].name
        return cell!
    }
}
