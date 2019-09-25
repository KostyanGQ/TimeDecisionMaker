//
//  ChooseViewController.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/20/19.
//

import UIKit

class ChooseViewController: UITableViewController {

    
    
    private var ICSPathA = "A"
    private var ICSPathB = "B"
    private var selectUser : User?
    
    private var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsersAtArray()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    
    private func UsersAtArray() {
        user.append(User(name: "User A", ICSFile: ICSPathA))
        user.append(User(name: "User B", ICSFile: ICSPathB))
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChooseTableViewCell
        cell.users.text = user[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectUser = user[indexPath.row]
        
    }


}
