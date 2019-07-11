//
//  CounterCell.swift
//  Counters
//
//  Created by admin on 09/07/2019.
//  Copyright © 2019 Jabka Studio. All rights reserved.
//

import UIKit
import CoreData

class CounterCell: UITableViewCell {

    @IBOutlet weak var mainView: UIVisualEffectView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var copyMessage: UIView!
    
    var counterValue = 0
    var counterStep = 1.0
    var counterObj:NSManagedObject? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 45
        minusButton.layer.masksToBounds = true
        minusButton.layer.cornerRadius = 45
        plusButton.layer.masksToBounds = true
        plusButton.layer.cornerRadius = 45
        
        copyMessage.layer.masksToBounds = true
        copyMessage.layer.cornerRadius = 40
        copyMessage.alpha = 0
    }
    
    public func updateCell() {
        if UserDefaults.standard.bool(forKey: "is_light_mode") {
            mainView.effect = UIBlurEffect(style: .dark)
        } else {
            mainView.effect = UIBlurEffect(style: .light)
        }
        self.valueLabel.text = "0"
        counterValue = 0
        plusButton.setTitle("", for: .normal)
        minusButton.setTitle("", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.counterValue = self.counterObj?.value(forKey: "value") as? Int ?? 0
            self.counterStep = (self.counterObj?.value(forKey: "step") as! Double)
            if self.counterStep != 1 {
                if self.counterStep < 1 {
                    self.plusButton.setTitle(String(self.counterStep), for: .normal)
                    self.minusButton.setTitle(String(self.counterStep), for: .normal)
                } else {
                    self.plusButton.setTitle(String(Int(self.counterStep)), for: .normal)
                    self.minusButton.setTitle(String(Int(self.counterStep)), for: .normal)
                }
                
            }
            let value = Double(self.counterValue) * self.counterStep
            if value == floor(value) {
                self.valueLabel.text = String(Int(value))
            } else {
                self.valueLabel.text = String(value)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onPlusButton() {
        counterValue += 1
        
        let value = Double(counterValue) * counterStep
        if value == floor(value) {
            valueLabel.text = String(Int(value))
        } else {
            valueLabel.text = String(value)
        }
        updateCounter()
    }

    @IBAction func onMinusButton() {
        counterValue -= 1
        
        let value = Double(counterValue) * counterStep
        if value == floor(value) {
            valueLabel.text = String(Int(value))
        } else {
            valueLabel.text = String(value)
        }
        updateCounter()
    }
    
    private func updateCounter() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        counterObj?.setValue(counterValue, forKey: "value")
        do {
            try context.save()
        } catch {}
    }
    
    @IBAction func onCopyButton() {
        UIPasteboard.general.string = String(counterValue)
        copyMessage.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.8) {
                self.copyMessage.alpha = 0
            }
        }
    }
    
}
