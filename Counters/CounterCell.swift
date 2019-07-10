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
    
    var counterValue = 0
    var counterObj:NSManagedObject? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 45
        minusButton.layer.masksToBounds = true
        minusButton.layer.cornerRadius = 45
        plusButton.layer.masksToBounds = true
        plusButton.layer.cornerRadius = 45
    }
    
    public func updateCell() {
        if UserDefaults.standard.bool(forKey: "is_light_mode") {
            mainView.effect = UIBlurEffect(style: .dark)
        } else {
            mainView.effect = UIBlurEffect(style: .light)
        }
        self.valueLabel.text = "0"
        counterValue = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.counterValue = self.counterObj?.value(forKey: "value") as? Int ?? 0
            self.valueLabel.text = String(self.counterValue)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onPlusButton() {
        counterValue += 1
        valueLabel.text = String(counterValue)
        updateCounter()
    }

    @IBAction func onMinusButton() {
        counterValue -= 1
        valueLabel.text = String(counterValue)
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
}
