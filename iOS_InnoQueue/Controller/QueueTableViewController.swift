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
//        if let indexPath = tableView.indexPath(for: sender) {
//            var toDo = toDos[indexPath.row]
//            toDo.isComplete.toggle()
//            toDos[indexPath.row] = toDo
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//            ToDo.saveToDos(toDos)
//        }
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
