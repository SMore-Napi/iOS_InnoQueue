//
//  SettingsViewController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 20.04.2022.
//

import UIKit

class SettingsViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var switch1: UISwitch!
    
    @IBOutlet weak var switch2: UISwitch!
    
    @IBOutlet weak var switch3: UISwitch!
    
    @IBOutlet weak var switch4: UISwitch!
    
    @IBOutlet weak var switch5: UISwitch!
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        saveSettings()
        self.showToast(message: "Saved", font: .systemFont(ofSize: 18.0))
        self.view.endEditing(true)
    }
    
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let s = SettingsRequest.loadSettings() {
            settings = s
        }
        
        updateSettingsFields()
        
        userName.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSettingsFields()
        self.tableView.reloadData()
    }
    
    
    func updateSettingsFields() {
        if let settings = settings {
            userName.text = settings.name
            switch1.isOn = settings.n1
            switch2.isOn = settings.n2
            switch3.isOn = settings.n3
            switch4.isOn = settings.n4
            switch5.isOn = settings.n5
        }
    }
    
    func saveSettings() {
        settings = Settings(name: userName.text!, n1: switch1.isOn, n2: switch2.isOn, n3: switch3.isOn, n4: switch4.isOn, n5: switch5.isOn)
        SettingsRequest.saveSettings(settings: settings!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }

    
    @IBAction func switch1Action(_ sender: UISwitch) {
        saveSettings()
    }
    
    @IBAction func switch2Action(_ sender: UISwitch) {
        saveSettings()
    }
    
    
    @IBAction func switch3Action(_ sender: UISwitch) {
        saveSettings()
    }
    
    @IBAction func switch4Action(_ sender: UISwitch) {
        saveSettings()
    }
    
    @IBAction func switch5Action(_ sender: UISwitch) {
        saveSettings()
    }
}

extension SettingsViewController {
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2 - 250, width: 150, height: 150))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.3, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        }
}
