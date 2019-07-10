//
//  ViewController.swift
//  Counters
//
//  Created by admin on 09/07/2019.
//  Copyright © 2019 Jabka Studio. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var countersTableView: UITableView!
    
    
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var helperText: UILabel!
    @IBOutlet weak var helperIcon: UIImageView!
    
    var isLightMode = UserDefaults.standard.bool(forKey: "is_light_mode")
    
    var counters: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColorMode()
        
        countersTableView.delegate = self
        countersTableView.dataSource = self
        
        settingsButton.setImage(UIImage(named: "SettingsWhite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.setImage(UIImage(named: "PlusWhite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        updateCounters()
    }
    
    public func updateCounters() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Counter")
        
        do {
            counters = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if counters.count == 0 {
            helperText.isHidden = false
            helperIcon.isHidden = false
        } else {
            helperText.isHidden = true
            helperIcon.isHidden = true
        }
        
        self.countersTableView.reloadData()
    }
    
    @IBAction func onAddButton() {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
                                        
            guard let textField = alert.textFields?.first,
                let counterName = textField.text else {
                    return
            }
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Counter", in: managedContext)!
            
            let counter = NSManagedObject(entity: entity, insertInto: managedContext)
            
            counter.setValue(counterName, forKeyPath: "name")
            
            do {
                try managedContext.save()
                self.counters.append(counter)
                DispatchQueue.main.async {
                    self.updateCounters()
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "counterCell") as! CounterCell
        let counter = counters[indexPath.row]
        cell.nameLabel.text = counter.value(forKey: "name") as? String
        cell.counterObj = counter
        cell.updateCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let cell = tableView.cellForRow(at: indexPath) as! CounterCell
        
        let deleteAction = UIContextualAction(style: .normal, title: /*NSLocalizedString("Delete", comment: "Delete")*/ "") { (action, view, handler) in
            self.countersTableView.setEditing(false, animated: true)
            let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(cell.counterObj!)
                do {
                    try managedContext.save()
                    DispatchQueue.main.async {
                        self.updateCounters()
                    }
                } catch {
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            tableView.cellForRow(at: indexPath)?.setEditing(false, animated: true)
        }
        deleteAction.backgroundColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 0)
        deleteAction.image = UIImage(named: "TrashIcon")!
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    @IBAction func onSettingsButton() {
        isLightMode = !isLightMode
        UserDefaults.standard.set(isLightMode, forKey: "is_light_mode")
        setColorMode()
    }
    
    public func setColorMode() {
        if self.isLightMode {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "LightBackground")!)
            UIApplication.shared.statusBarStyle = .default
        } else {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "DarkBackground")!)
            UIApplication.shared.statusBarStyle = .lightContent
        }
        self.updateCounters()
        UIView.animate(withDuration: 0.3) {
            if self.isLightMode {
                self.settingsButton.tintColor = .black
                self.addButton.tintColor = .black
                self.titleLabel.textColor = .black
                self.separatorView.backgroundColor = .black
            } else {
                self.settingsButton.tintColor = .white
                self.addButton.tintColor = .white
                self.titleLabel.textColor = .white
                self.separatorView.backgroundColor = .white
            }
        }
    }
    
}

