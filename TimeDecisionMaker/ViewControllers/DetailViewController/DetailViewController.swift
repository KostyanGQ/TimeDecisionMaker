//
//  DetailViewController.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/20/19.
//

import UIKit

class DetailViewController: UIViewController {
    
    let meet = Meet()
    let user = User()
    let service = RDFileServise()
    
    let timeZone = "Europe/Kiev"
    let format = "dd/MM/yyyy HH:mm"
    

    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var startMeetinTextField: UITextField!
    
    @IBOutlet weak var endMeetingTextField: UITextField!
    
    @IBOutlet weak var LastChangeDate: UILabel!
    
    @IBOutlet weak var CreateMeetingDate: UILabel!
    
    @IBOutlet weak var StatusLabel: UILabel!
    
    @IBOutlet weak var securetyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateMeet()
    }
    
    func viewVC() {
        
        self.TitleLabel.text = meet.summary
        self.startMeetinTextField.text = meet.dateInterval.start.hoursValueFromDateToString()
        self.endMeetingTextField.text = meet.dateInterval.end.hoursValueFromDateToString()
        self.LastChangeDate.text = meet.lastModified.hoursValueFromDateToString()
        self.CreateMeetingDate.text = meet.created.hoursValueFromDateToString()
 //       self.StatusLabel.text = event.status
        
        if self.securetyLabel.isHidden == true {
             let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
             lpgr.minimumPressDuration = 0.5
             lpgr.delaysTouchesBegan = true
             lpgr.delegate = self as? UIGestureRecognizerDelegate
             self.securetyLabel.addGestureRecognizer(lpgr)
        }
        
    }
    
    func updateMeet(){
        
        if service.chekTime(startTime: (startMeetinTextField.text?.convertStringToDate(timezone: timeZone, format: format))!, endTime: (endMeetingTextField.text?.convertStringToDate(timezone: timeZone, format: format))!) {
            
            if service.saveEventChanges(event: meet, resourceFile: user.ICSFile, resourseFile2: nil) {
                print("Your meet were resaved")
            } else{
                print("Somesing gone wrong")
            }
        }
        
        
    }
    
    //MARK: - UILongPressGestureRecognizer Action -
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            //When lognpress is start or running
        }
        else {
            self.view.removeFromSuperview()
        }
    }
    
}
