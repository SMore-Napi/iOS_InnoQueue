//
//  QueueTableViewController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 06.04.2022.
//

import UIKit

var selectedFromTableQueueId: Int = 0

class QueueTableViewController: UITableViewController, QueueCellDelegate {
    
    static var qrCodeScanned: String? = nil
    
    var selectedSegmentIndex = 0
    
    func openQueueDetails(sender: QueueCell) {
        
    }
    
    var activeQueues = [Queue]()
    var frozenQueues = [Queue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (loadedActiveQueues, loadedFrozenQueues) = QueueShortRequest.loadQueues()
    
        if let loadedActiveQueues = loadedActiveQueues,
           let loadedFrozenQueues = loadedFrozenQueues {
            activeQueues = loadedActiveQueues
            frozenQueues = loadedFrozenQueues
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let (loadedActiveQueues, loadedFrozenQueues) = QueueShortRequest.loadQueues()
    
        if let loadedActiveQueues = loadedActiveQueues,
           let loadedFrozenQueues = loadedFrozenQueues {
            activeQueues = loadedActiveQueues
            frozenQueues = loadedFrozenQueues
        }
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return selectedSegmentIndex == 0 ? activeQueues.count : frozenQueues.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentCellIdentifier", for: indexPath) as! SegmentCell
//            cell.delegate = self
            cell.segmentOutlet.selectedSegmentIndex = selectedSegmentIndex
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueueCellIdentifier", for: indexPath) as! QueueCell
            cell.delegate = self
            let queue = selectedSegmentIndex == 0 ? activeQueues[indexPath.row] : frozenQueues[indexPath.row]
            cell.queueName?.text = queue.name
            cell.queueColor?.backgroundColor = Queue.convertStringToColor(colorName: queue.color)
        
            return cell
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFromTableQueueId = selectedSegmentIndex == 0 ? activeQueues[indexPath.row].id : frozenQueues[indexPath.row].id
    }
//
//    override func tableView(_ tableView: UITableView, canEditRowAt
//       indexPath: IndexPath) -> Bool {
//        return false
//    }
    
//    override func tableView(_ tableView: UITableView,
//       commit editingStyle: UITableViewCell.EditingStyle,
//       forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            queues.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            Queue.saveQueues(queues)
//        }
//    }
    
    @IBAction func joinButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Input queue's pin code", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Pin code"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let queueId = QueueShortRequest.joinQueue(pinCode: (textField?.text)!)
            if (queueId != nil) {
                self.tableView.reloadData()
                selectedFromTableQueueId = queueId!
                self.performSegue(withIdentifier: "showQueueDetails", sender: self)
            } else {
                self.showToast(message: "Invalid pin code", font: .systemFont(ofSize: 18.0))
            }
        }))
        alert.addAction(UIAlertAction(title: "Scan QR", style: .default, handler: {  (_) in
            QueueTableViewController.qrCodeScanned = nil
            let viewControllerYouWantToPresent = self.storyboard?.instantiateViewController(withIdentifier: "QrScannerIdentifier")
            self.present(viewControllerYouWantToPresent!, animated: true, completion: nil)
            if (QueueTableViewController.qrCodeScanned != nil) {
                let queueId = QueueShortRequest.joinQueue(qrCode: QueueTableViewController.qrCodeScanned!)
                if (queueId != nil) {
                    self.tableView.reloadData()
                    selectedFromTableQueueId = queueId!
                    self.performSegue(withIdentifier: "showQueueDetails", sender: self)
                } else {
                    self.showToast(message: "Invalid QR code", font: .systemFont(ofSize: 18.0))
                }
            }

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindQueuesList(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindQueuesList" else { return }
        let sourceViewController = segue.source as! QueueCreation
        if let queue = sourceViewController.queue {
            let newIndexPath = IndexPath(row: activeQueues.count, section: 1)
            activeQueues.append(queue)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
//        Queue.saveQueues(queues)
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
