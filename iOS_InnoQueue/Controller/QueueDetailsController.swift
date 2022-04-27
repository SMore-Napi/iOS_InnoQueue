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
    
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var addProgressOutlet: UIButton!
    
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
            if (queue.is_admin) {
                editButtonOutlet.isEnabled = true
            } else {
                editButtonOutlet.isEnabled = false
            }
            if (queue.is_active) {
                addProgressOutlet.isEnabled = true
            } else {
                addProgressOutlet.isEnabled = false
            }
        }
    }
    
    
    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        self.showToast(message: "Not implemented :(", font: .systemFont(ofSize: 15.0))
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
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.sendCompleteTaskRequest(task_id: (self.queue?.id)!, expenses: Int((textField?.text)!))
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.sendCompleteTaskRequest(task_id: (queue?.id)!, expenses: nil)
        }
    }
    
    @IBAction func ManageQueueAction(_ sender: UIButton) {
        
        let deleteString = (queue?.is_admin)! ? "Delete" : "Leave"
        let freezeString = (queue?.is_active)! ? "Freeze" : "Unfreeze"
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Invite user", style: .default , handler:{ (UIAlertAction)in
                self.inviteUser(sender)
            }))
            
            alert.addAction(UIAlertAction(title: "\(freezeString) queue", style: .default , handler:{ (UIAlertAction)in
                self.freezeUnfreezeQueue()
            }))

            alert.addAction(UIAlertAction(title: "\(deleteString) queue", style: .destructive , handler:{ (UIAlertAction)in
                self.deleteQueue()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                
            }))

            self.present(alert, animated: true, completion: {
                
            })
    }
    
    private func sendCompleteTaskRequest(task_id: Int, expenses: Int?) {
        ToDoTasksRequest.completeTask(task_id: task_id, expenses: expenses)
        self.showToast(message: "Added", font: .systemFont(ofSize: 18.0))
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    private func inviteUser(_ sender: UIButton) {
        let inviteCodes = QueueShortRequest.inviteInQueueById(id: (queue?.id)!)
        if let pinCode = inviteCodes.0,
           let qrCode = inviteCodes.1 {
            let alert = UIAlertController(title: "\((queue?.name)!)", message: "Pin code: \(pinCode)", preferredStyle: .alert)
            
            let imgViewTitle = UIImageView(frame: CGRect(x: 0, y: -268, width: 268, height: 268))            
            imgViewTitle.image = self.generateQRCode(from: qrCode)
            imgViewTitle.layer.cornerRadius = 8.0
            imgViewTitle.clipsToBounds = true
            alert.view.addSubview(imgViewTitle)
            
            alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_) in
                let description = "Join '\((self.queue?.name)!)' in InnoQueue. Pin code: \(pinCode)"
                let activityController = UIActivityViewController(activityItems: [description], applicationActivities: nil)
                activityController.popoverPresentationController?.sourceView = sender
                self.present(activityController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Done", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func freezeUnfreezeQueue() {
        let freezeString = (queue?.is_active)! ? "Freeze" : "Unfreeze"
        let freezeDescriptionString = (queue?.is_active)!
            ? "Temporarily leave this queue. Other users will still participate. Your progress will be saved."
            : "Return back to this queue. You'll continue receiving tasks for this queue."
        
        let alert = UIAlertController(title: "\(freezeString) queue", message: "\(freezeDescriptionString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "\(freezeString)", style: .destructive, handler: { (_) in
            if ((self.queue?.is_active)!) {
                QueueShortRequest.freezeQueue(queue_id: (self.queue?.id)!)
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                QueueShortRequest.unfreezeQueue(queue_id: (self.queue?.id)!)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteQueue() {
        let deleteString = (queue?.is_admin)! ? "Delete" : "Leave"
        let deleteDescriptionString = (queue?.is_admin)!
            ? "All participants will be removed from this queue. The progress will be lost."
            : "Leave this queue. You will no longer participate in this queue. Your progress will be lost."
        
        let alert = UIAlertController(title: "\(deleteString) queue", message: "\(deleteDescriptionString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "\(deleteString)", style: .destructive, handler: { (_) in
            QueueShortRequest.deleteQueue(queue_id: (self.queue?.id)!)
            _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
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
