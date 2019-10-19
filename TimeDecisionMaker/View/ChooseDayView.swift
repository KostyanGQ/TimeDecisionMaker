//
//  ChooseDayView.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 10/6/19.
//

import Foundation
import UIKit

class ChooseDayView : UIView, UITextFieldDelegate {
    
    private weak var date : UITextField?
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    
    public func showDatePicker(dateText : UITextField) -> Date{
    
        self.date = dateText
        formatter.dateFormat = "dd/MM/yyyy"
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        toolbar.setItems([doneButton,spaceButton], animated: false)

        dateText.inputAccessoryView = toolbar
        dateText.inputView = datePicker
        dateText.text = "29/04/2019"
        let date = formatter.date(from: dateText.text!)

    return date!
 }
 
  @objc func doneDatePicker(){
    
    
    // MARK: How to delete this line
    formatter.dateFormat = "dd/MM/yyyy"
    
    

    
    let notificationName = NSNotification.Name.init("ChooseDayView_UpdateAfterClouse")
    NotificationCenter.default.post(name: notificationName, object: nil)
    
    date?.text = formatter.string(from: datePicker.date)
    UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
    
 }    
    
}
    
//
//
//    private weak var errorTitle : UILabel?
//    private weak var day : UITextField?
//    private weak var month : UITextField?
//    private weak var year : UILabel?
//    private weak var saveDate : UILabel?
//
//
//
//
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let width  = self.frame.size.width
//        let height = self.frame.size.height
//        var textFieldOfX : CGFloat  = 10
//        let heightOffTextField = height / 5
//        let widthOffTextField = width / 3
//        let heighterrorTitleOfErrorTitle = height - heightOffTextField
//        let heightSaveDate = height - heighterrorTitleOfErrorTitle
//
//
//
//        self.day?.frame = CGRect(x: textFieldOfX,
//                                 y: 10,
//                                 width: widthOffTextField,
//                                 height: heightOffTextField)
//
//        textFieldOfX += widthOffTextField
//
//        self.month?.frame = CGRect(x: textFieldOfX,
//                                   y: 10,
//                                   width: widthOffTextField,
//                                   height: heightOffTextField)
//
//        textFieldOfX += widthOffTextField
//
//        self.year?.frame = CGRect(x: textFieldOfX,
//                                  y: 10,
//                                  width: widthOffTextField,
//                                  height: heightOffTextField)
//
//        self.errorTitle?.frame = CGRect(x: 10,
//                                        y: heighterrorTitleOfErrorTitle,
//                                        width: width,
//                                        height: heighterrorTitleOfErrorTitle)
//
//        self.saveDate?.frame = CGRect(x: 0,
//                                      y: heightSaveDate,
//                                      width: width,
//                                      height: heightSaveDate)
//
//
//    }
//
//    func addSubviews(){
//
//        self.addDayTextField()
//        self.addMonthTextField()
//        self.addYearTextField()
//        self.addSaveDate()
//        self.addErrorTitle()
//
//    }
//
//    func addDayTextField(){
//        let day = UITextField()
//        self.addSubview(day)
//        self.day = day
//    }
//    func addMonthTextField(){
//        let month = UITextField()
//        self.addSubview(month)
//        self.month = month
//    }
//    func addYearTextField(){
//        let year = UILabel()
//        self.addSubview(year)
//        self.year = year
//        self.year?.text = "2019"
//    }
//    func addSaveDate(){
//        let saveDate = UILabel()
//        self.addSubview(saveDate)
//        self.saveDate = saveDate
//        let tap = UITapGestureRecognizer(target: self, action: #selector(returnDate))
//        self.saveDate?.addGestureRecognizer(tap)
//    }
//    func addErrorTitle(){
//        let errorTitle = UILabel()
//        self.addSubview(errorTitle)
//        self.errorTitle = errorTitle
//    }
//
//
//    @objc private func returnDate() {
////            let correctDate = chekDate()
////        if correctDate == true{
////
////        }else {
////
////        }
//
//
//    }
//
//    func chekDate(day : String, month : String) -> Bool{
//
//        let calendar = Calendar.self
//
//
//
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let currentText = textField.text ?? ""
//
//         // attempt to read the range they are trying to change, or exit if we can't
//         guard let stringRange = Range(range, in: currentText) else { return false }
//
//         // add their new text to the existing text
//         let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//
//         // make sure the result is under 16 characters
//         return updatedText.count <= 2 && updatedText.count != 0
//    }
//
//}
    

