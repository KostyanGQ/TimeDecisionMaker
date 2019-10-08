//
//  MeetViewController.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/20/19.
//

import UIKit

class MeetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var meet = Meet()
    let user = User()
    let service = RDFileServise()
    
    
    
    
    
    @IBOutlet weak var DateTextField: UITextField!
    let datePicker = UIDatePicker()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        showDatePicker()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        //MARK: Fix events
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar,
                                            year: 2019,
                                            month: 04,
                                            day: 29,
                                            hour: 3,
                                            minute: 01)
        
        let date = NSCalendar.current.date(from: dateComponents)
        let path = service.parthICSFile(resourceFile: user.ICSFile ?? "A")
        let events = service.getEventDay(eventsList: path, date: date!)
        
        return events!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MeetCellViewController
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let someDateTime = formatter.date(from: "2019/04/28")
        
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar,
                                            year: 2019,
                                            month: 04,
                                            day: 29,
                                            hour: 3,
                                            minute: 01)
        
        let date = NSCalendar.current.date(from: dateComponents)
        
   
        
        let path = service.parthICSFile(resourceFile: user.ICSFile ?? "A")
        let events = service.getEventDay(eventsList: path, date: date!)
        
        meet = events![indexPath.row]

        cell.Title.text = meet.summary
        cell.StartMeetTime.text = "\(meet.dateStart!)"
        return cell
    }
    
    
    //MARK: - DatePicker
    
     func showDatePicker(){
           //Formate Date
        datePicker.datePickerMode = .date

          //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        DateTextField.inputAccessoryView = toolbar
        DateTextField.inputView = datePicker

    }
    
     @objc func donedatePicker(){

      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy"
      DateTextField.text = formatter.string(from: datePicker.date)
      view.endEditing(true)
    }

    @objc func cancelDatePicker(){
      view.endEditing(true)
     }

}
