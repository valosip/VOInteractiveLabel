//
//  ViewController.swift
//  VOInteractiveLabel
//
//  Created by valosip on 09/02/2017.
//  Copyright (c) 2017 valosip. All rights reserved.
//

import UIKit
import VOInteractiveLabel

struct Attributes {
    static let fillInBlank: [String: Any] = [
        NSForegroundColorAttributeName: UIColor.black,
        NSUnderlineColorAttributeName: UIColor.black,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
    ]
    static let link: [String: Any] = [
        NSForegroundColorAttributeName: UIColor.blue,
        ]
    static let mention: [String: Any] = [
        NSForegroundColorAttributeName: UIColor.red
    ]
    static let hashtag: [String: Any] = [
        NSForegroundColorAttributeName: UIColor.green
    ]
}

class ViewController: UIViewController, UITextFieldDelegate, VOInteractiveLabelDelegate {
    var activeLabel: VOInteractiveLabel!
    var selectedBlank: BlankModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let myLabel = VOInteractiveLabel(frame: .zero)
        myLabel.text = "Enter Name assisted me with reviewing the Terms Of Service on Enter Date. #thanks #tos"
        myLabel.blankArray.append(BlankModel(type: .string, text: "Enter Name", hint: "Please enter your name",
                                             placeholder: "Name", attributes: Attributes.fillInBlank))
        myLabel.blankArray.append(BlankModel(type: .link, text: "Terms Of Service", hint: nil,
                                             placeholder: "Name", url: "https://cocoapods.org/legal", attributes: Attributes.link, data: nil))
        myLabel.blankArray.append(BlankModel(type: .date, text: "Enter Date", hint: "Please enter the date you helped",placeholder: "MM/DD/YY", attributes: Attributes.fillInBlank))
        myLabel.blankArray.append(BlankModel(type: .hashtag, text: "#thanks", hint: nil,
                                             placeholder: "Name", attributes: Attributes.hashtag))
        myLabel.blankArray.append(BlankModel(type: .hashtag, text: "#tos", hint: nil,
                                             placeholder: "Name", attributes: [NSForegroundColorAttributeName: UIColor.cyan]))
        myLabel.delegate = self
        
        self.view.addSubview(myLabel)
        myLabel.setupLabelAttributes()
        
        myLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        myLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        myLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickedOnLinkAtIndex(_ index: Int, inLabel label: VOInteractiveLabel) {
        print("Clicked on link")
        guard let urlString = label.blankArray[index].url else { return }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func clickedOnBlankAtIndex(_ index: Int, inLabel label: VOInteractiveLabel) {
        print("Clicked on blank")
        activeLabel = label
        selectedBlank = label.blankArray[index]
        let alert = UIAlertController(title: "", message: label.blankArray[index].hint, preferredStyle: .alert)
        
        switch label.blankArray[index].type! {
        case .date:
            alert.addTextField(configurationHandler:configureDateTextField(_:))
        default:
            alert.addTextField(configurationHandler:configureTextField(_:))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            if let value = label.alertTextField.text, value != "" {
                label.updateBlankAtIndex(index, withValue: value)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clickedOnHashtagAtIndex(_ index: Int, inLabel label: VOInteractiveLabel) {
        print("Clicked on hashtag")
        
        let alert = UIAlertController(title: label.blankArray[index].text, message: "Do something", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clickedOnMentionAtIndex(_ index: Int, inLabel label: VOInteractiveLabel) {
        print("Clicked on mention")
    }
    
    func configureTextField(_ textField: UITextField!) {
        textField.placeholder = selectedBlank.placeholder
        activeLabel.alertTextField = textField
    }
    
    func configureDateTextField(_ textField: UITextField!) {
        textField.placeholder = selectedBlank.placeholder
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        textField.inputView = datePicker
        
        activeLabel.alertTextField = textField
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        activeLabel.alertTextField.text = dateFormatter.string(from: sender.date)
    }
}
