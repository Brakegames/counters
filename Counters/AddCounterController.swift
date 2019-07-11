//
//  AddCounterController.swift
//  Counters
//
//  Created by admin on 11/07/2019.
//  Copyright © 2019 Jabka Studio. All rights reserved.
//

import UIKit
import CoreData

class AddCounterController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var mainView: UIVisualEffectView!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var stepPicker: UIPickerView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let pickerData = ["0.1", "0.5", "1", "2", "3", "4", "5", "10", "15"]
    var selectedStep:Double = 1.0
    
    var isLightMode = UserDefaults.standard.bool(forKey: "is_light_mode")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepPicker.delegate = self
        stepPicker.dataSource = self
        stepPicker.selectRow(2, inComponent: 0, animated: true)
        
        stepPicker.layer.cornerRadius = 16
        stepPicker.layer.borderWidth = 1
        
        nameInput.layer.borderWidth = 1
        nameInput.layer.cornerRadius = 16
        nameInput.layer.masksToBounds = true
        
        cancelButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        cancelButton.layer.cornerRadius = 16
        
        saveButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        saveButton.layer.cornerRadius = 16
        
        if isLightMode {
            mainView.effect = UIBlurEffect(style: .dark)
            popupView.backgroundColor = UIColor(patternImage: UIImage(named: "LightBackground")!)
            nameLabel.textColor = .black
            stepLabel.textColor = .black
            nameInput.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            nameInput.layer.borderColor = UIColor.black.cgColor
            stepPicker.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            stepPicker.layer.borderColor = UIColor.black.cgColor
        } else {
            mainView.effect = UIBlurEffect(style: .light)
            popupView.backgroundColor = UIColor(patternImage: UIImage(named: "DarkBackground")!)
            nameLabel.textColor = .white
            stepLabel.textColor = .white
            nameInput.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
            nameInput.layer.borderColor = UIColor.white.cgColor
            stepPicker.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
            nameInput.textColor = .white
            stepPicker.layer.borderColor = UIColor.white.cgColor
        }
        
        popupView.layer.cornerRadius = 16
        popupView.layer.masksToBounds = true
    }

    @IBAction func onBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButton() {
        
        if nameInput.text == "" {
            let alert = UIAlertController(title: "Counter name is empty", message: "Please enter counter name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Counter", in: managedContext)!

        let counter = NSManagedObject(entity: entity, insertInto: managedContext)

        counter.setValue(nameInput.text, forKeyPath: "name")
        counter.setValue(selectedStep, forKey: "step")

        do {
            try managedContext.save()
            
            let parent = self.presentingViewController as? ViewController
            self.dismiss(animated: true) {
                parent?.updateCounters()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if isLightMode {
            let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            return attributedString
        } else {
            let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            return attributedString
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStep = (Double(pickerData[row]))!
    }
    
}
