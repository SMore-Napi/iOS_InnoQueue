//
//  QueueDetailsController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 12.04.2022.
//

import UIKit

class QueueDetailsController: UIViewController {
    
    @IBOutlet weak var queueColor: UIView!
    
    @IBOutlet weak var queueName: UILabel!
    
    @IBOutlet weak var participantsTable: UITableView!
    
    @IBOutlet weak var currentUserName: UILabel!
    
    @IBOutlet weak var currentUserSpent: UILabel!
    
    @IBOutlet weak var shakeButtonOutlet: UIButton!
    
    var queue: QueueFullJSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = QueueShortRequest.loadQueueById(id: selectedFromTableQueueId)
        
        participantsTable.dataSource = self
        
        if let queue = queue {
            queueName.text = String(queue.name)
            queueColor.backgroundColor =  Queue.convertStringToColor(colorName: queue.color)
            currentUserName.text = queue.on_duty.user
            currentUserSpent.text = "Spent \(String(queue.on_duty.expenses))"
            participantsTable.reloadData()
            if (queue.is_on_duty) {
                shakeButtonOutlet.isEnabled = false
            } else {
                shakeButtonOutlet.isEnabled = true
            }
        }
    }
    
    @IBAction func shakeButtonAction(_ sender: UIButton) {
        QueueShortRequest.shakeUser(queue_id: (queue?.id)!)
        self.showToast(message: "Shook!", font: .systemFont(ofSize: 18.0))
    }
    
    @IBAction func addProgressAction(_ sender: Any) {
        if ((queue?.track_expenses)!) {
            let alert = UIAlertController(title: "Input expenses", message: "Enter how much it costs", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Price"
                textField.keyboardType = .numberPad
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.sendCompleteTaskRequest(task_id: (self.queue?.id)!, expenses: Int((textField?.text)!))
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.sendCompleteTaskRequest(task_id: (queue?.id)!, expenses: nil)
        }
    }
    
    private func sendCompleteTaskRequest(task_id: Int, expenses: Int?){
        ToDoTasksRequest.completeTask(task_id: task_id, expenses: expenses)
        self.showToast(message: "Added", font: .systemFont(ofSize: 18.0))
    }
}

extension QueueDetailsController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return (queue?.participants.count)!
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier:
          "ParticipantsIdentifier", for: indexPath) as! ParticipantsCell
       
       let user = queue?.participants[indexPath.row]
       
       cell.userName?.text = user?.user
       cell.userExpenses?.text = String("Spent: \((user?.expenses)!)")
       return cell
   }
}

extension QueueDetailsController {
func showToast(message : String, font: UIFont) {

//    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 150))
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2 - 75, width: 150, height: 150))
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
} }
