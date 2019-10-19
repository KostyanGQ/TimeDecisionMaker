//
//  NewMeetViewController.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/20/19.
//

import UIKit

class NewMeetViewController: UIViewController {


    let meet = Meet()
    let user = User()
    let service = RDFileServise()
    let timeZone = "Europe/Kiev"
    let format = "dd/MM/yyyy HH:mm"
    
    @IBOutlet weak var TitleTextView: UITextView!
    @IBOutlet weak var StartTimeTextFIeld: UITextField!
    @IBOutlet weak var EndTimeTextField: UITextField!
    @IBOutlet weak var EmailTextEdin: UITextField!
    @IBOutlet weak var ChooseICSFileTextField: UITextField!
    @IBOutlet weak var RecomendationTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewVC()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    func viewVC(){
        self.meet.descriptionAp = TitleTextView.text
        self.meet.dateInterval.start = StartTimeTextFIeld.text!.convertStringToDate(timezone: timeZone, format: format)
        self.meet.dateInterval.end = EndTimeTextField.text!.convertStringToDate(timezone: timeZone, format: format)
       
        if ChooseICSFileTextField != nil {
            self.meet.UID = ChooseICSFileTextField.text!
        }else {
            self.meet.UID = EmailTextEdin.text!
        }
        typeOfUID()
        
        
    }
    
    
    func typeOfUID() {
        if EmailTextEdin != nil {
            ChooseICSFileTextField.isHidden = true
        }
        if ChooseICSFileTextField != nil{
            EmailTextEdin.isHidden = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
