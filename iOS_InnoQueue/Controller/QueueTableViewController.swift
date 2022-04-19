//
//  QueueTableViewController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 06.04.2022.
//

import UIKit

var selectedFromTableQueueId: Int = 0

class QueueTableViewController: UITableViewController, QueueCellDelegate {
    func openQueueDetails(sender: QueueCell) {
        
    }
    
    var queues = [Queue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let savedQueues = QueueShortRequest.loadQueues() {
            queues = savedQueues
        } else {
            queues = Queue.loadSampleQueues()
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedQueues = QueueShortRequest.loadQueues() {
            queues = savedQueues
        } else {
            queues = Queue.loadSampleQueues()
        }
        self.tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return queues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
       indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
           "QueueCellIdentifier", for: indexPath) as! QueueCell
    
        cell.delegate = self
        
        let queue = queues[indexPath.row]
        cell.queueName?.text = queue.name
        cell.queueColor?.backgroundColor = Queue.convertStringToColor(colorName: queue.color)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFromTableQueueId = queues[indexPath.row].id
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
       indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView,
       commit editingStyle: UITableViewCell.EditingStyle,
       forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            queues.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Queue.saveQueues(queues)
        }
    }
    
    @IBAction func joinButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Input queue's pin code", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Pin code"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
//            self.sendCompleteTaskRequest(task_id: toDotask.queue_id, expenses: Int((textField?.text)!), index: indexPath.row)
            let queueId = QueueShortRequest.joinQueue(pinCode: (textField?.text)!)
            print(queueId)
            if (queueId != nil) {
                print("hhhh1")
                self.tableView.reloadData()
                selectedFromTableQueueId = queueId!
                self.performSegue(withIdentifier: "showQueueDetails", sender: self)
            } else {
                print("hhhh2")
                self.showToast(message: "Invalid pin code", font: .systemFont(ofSize: 18.0))
            }

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindQueuesList(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindQueuesList" else { return }
        let sourceViewController = segue.source as! QueueCreation
        if let queue = sourceViewController.queue {
            let newIndexPath = IndexPath(row: queues.count, section: 0)
            queues.append(queue)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        Queue.saveQueues(queues)
    }
}

extension QueueTableViewController {
func showToast(message : String, font: UIFont) {
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
    }
}
