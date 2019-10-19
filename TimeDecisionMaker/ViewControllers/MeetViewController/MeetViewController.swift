//
//  MeetViewController.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/20/19.
//

import UIKit

class MeetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var meet = Meet()
    var events : [Meet]? = nil
    let user = User()
    let service = RDFileServise()
    let dataPiker = ChooseDayView()
    var selectEvent  = Meet()
    
    
    private var date : Date? = nil

    
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var DateTextField: UITextField!
    let datePicker = UIDatePicker()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let calendar = Calendar.current
//        let dateComponents = DateComponents(calendar: calendar,
//                                            year: 2019,
//                                            month: 04,
//                                            day: 29,
//                                            hour: 3,
//                                            minute: 01)
//        
//        var date = NSCalendar.current.date(from: dateComponents)
        
        date = dataPiker.showDatePicker(dateText: DateTextField)

        let path = service.parthICSFile(resourceFile: user.ICSFile )
        print("userFile \(user.ICSFile)")
        self.events = service.getEventDay(eventsList: path, date: date!)!
        for event in self.events! {
            print("meets \(event.summary)")
        }
        

       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTable),
            name: NSNotification.Name(rawValue: "ChooseDayView_UpdateAfterClouse"),
            object: nil)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        //MARK: Fix events


       
        if events == nil {
            return 1
        } else {
            return self.events!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MeetCellViewController
        
        let path = service.parthICSFile(resourceFile: user.ICSFile )
             print("userFile \(user.ICSFile)")
        
        if self.events![indexPath.row] == nil {
            cell.Title.text = "You have no event today"
        } else {
        meet = events![indexPath.row]
            print("eventTO, \(meet)")
        cell.Title.text = meet.summary
        cell.StartMeetTime.text = "\(meet.dateInterval.start.hoursValueFromDateToString())"
            print("dateIntervalStart \(meet.dateInterval.start.hoursValueFromDateToString())")
        }
 
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let path = service.parthICSFile(resourceFile: user.ICSFile )
        let events = service.getEventDay(eventsList: path, date: self.date!)
        meet = events![indexPath.row]
        print("eventTO, \(meet)")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "MeetViewController", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.present(nextViewController, animated:true, completion:nil)
         
    }
    

    
    
    @objc func updateTable(){
        
        self.TableView.reloadData()
    }
    

}
