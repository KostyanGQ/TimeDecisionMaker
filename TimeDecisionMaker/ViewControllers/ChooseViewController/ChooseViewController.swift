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
        
        
//         
//            let path = Bundle.main.path(forResource: "A", ofType: "ics")
//            let url = URL(fileURLWithPath: path ?? "")
//            let dc = UIDocumentInteractionController(url: url)
//            dc.delegate = self as? UIDocumentInteractionControllerDelegate
//            dc.presentPreview(animated: true)
//            print("dc, \(url)")
//    
//
//        func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//            return self
//        }

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
        print("users \(user[indexPath.row].name)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "ChooseViewController", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MeetViewController") as! MeetViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    


}
