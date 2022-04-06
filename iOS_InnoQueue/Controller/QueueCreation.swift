//
//  QueueCreation.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 06.04.2022.
//

import UIKit

class QueueCreation: UITableViewController {
  
    @IBOutlet weak var queueName: UITextField!
    
    @IBOutlet weak var trackExpenses: UISwitch!
    
    @IBOutlet weak var redButtonColor: UIButton!
    
    @IBOutlet weak var orangeButtonColor: UIButton!
    
    @IBOutlet weak var yellowButtonColor: UIButton!
    
    @IBOutlet weak var greenButtonColor: UIButton!
    
    @IBOutlet weak var blueButtonColor: UIButton!
    
    @IBOutlet weak var purpleButtonColor: UIButton!
    
    @IBOutlet weak var grayButtonColor: UIButton!
    
    @IBAction func redButtonPressed(_ sender: UIButton) {
        unHighlightButtons()
        highlightButton(buttonColor: redButtonColor)
        color = "RED"
    }
    
    @IBAction func orangeButtonPressed(_ sender: UIButton) {
        unHighlightButtons()
        highlightButton(buttonColor: orangeButtonColor)
        color = "ORANGE"
    }
    
    @IBAction func yellowButtonPressed(_ sender: UIButton) {
        unHighlightButtons()
        highlightButton(buttonColor: yellowButtonColor)
        color = "YELLOW"
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) {
        unHighlightButtons()
        highlightButton(buttonColor: greenButtonColor)
        color = "GREEN"
    }
    
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        unHighlightButtons()
        highlightButton(buttonColor: blueButtonColor)
        color = "BLUE"
    }
    
    @IBAction func purpleButtonPressed(_ sender: UIButton) {
        unHighlightButtons()
        highlightButton(buttonColor: purpleButtonColor)
        color = "PURPLE"
    }
    
    @IBAction func grayButtonPressed(_ sender: UIButton) {
        unHighlightButtons()
        highlightButton(buttonColor: grayButtonColor)
        color = "GRAY"
    }
    
    private func unHighlightButtons() {
        // greenButtonColor.layer.borderWidth = 0.0
        redButtonColor.layer.borderColor = UIColor.clear.cgColor
        orangeButtonColor.layer.borderColor = UIColor.clear.cgColor
        yellowButtonColor.layer.borderColor = UIColor.clear.cgColor
        greenButtonColor.layer.borderColor = UIColor.clear.cgColor
        blueButtonColor.layer.borderColor = UIColor.clear.cgColor
        purpleButtonColor.layer.borderColor = UIColor.clear.cgColor
        grayButtonColor.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func highlightButton(buttonColor: UIButton) {
        buttonColor.layer.borderColor = UIColor.brown.cgColor
        buttonColor.layer.borderWidth = 1.0
        buttonColor.imageView?.contentMode = .scaleAspectFit
        buttonColor.layer.cornerRadius = buttonColor.frame.height * 0.5
    }
    
    var queue: Queue?
    var color: String = "GRAY"
    
    @IBAction func createQueue(_ sender: UIButton) {
        let name = queueName.text!
        queue = Queue(id: 10, name: name, color: color)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "createQueue" else { return }
        let name = queueName.text!
        queue = Queue(id: 10, name: name, color: color)
    }
}
