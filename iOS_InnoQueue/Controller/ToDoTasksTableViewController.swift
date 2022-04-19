//
//  ToDoTasksTableViewController.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 19.04.2022.
//

import UIKit

class ToDoTasksTableViewController: UITableViewController, TaskCellDelegate {
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todoTasks = ToDoTasksRequest.loadTasks() {
            tasks = todoTasks
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let todoTasks = ToDoTasksRequest.loadTasks() {
            tasks = todoTasks
        }
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
       indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
           "ToDoTasksIdentifier", for: indexPath) as! TaskCell
    
        cell.delegate = self
        
        let toDoTask = tasks[indexPath.row]
        cell.queue_id = toDoTask.queue_id
        cell.queueName?.text = toDoTask.name
        cell.queueColor?.backgroundColor = Queue.convertStringToColor(colorName: toDoTask.color)
        
        if (toDoTask.is_important) {
            cell.isImportantDot?.backgroundColor = .red
        } else {
            cell.isImportantDot?.backgroundColor = .clear
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Archive action
        let skip = UIContextualAction(style: .normal, title: "Skip") {
            [weak self] (action, view, completionHandler) in
            self?.handleMoveToSkip(index: indexPath.row)
                completionHandler(true)
        }
        skip.backgroundColor = .systemYellow

        let configuration = UISwipeActionsConfiguration(actions: [skip])

        return configuration
    }
    
    private func handleMoveToSkip(index: Int) {
        ToDoTasksRequest.skipTask(task_id: tasks[index].queue_id)
        self.showToast(message: "Skipped", font: .systemFont(ofSize: 18.0))
        tasks.remove(at: index)
        self.tableView.reloadData()
    }
    
    func completeTaskTapped(sender: TaskCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            let toDotask = tasks[indexPath.row]
            
            if (toDotask.track_expenses) {
                let alert = UIAlertController(title: "Input expenses", message: "Enter how much it costs", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Price"
                    textField.keyboardType = .numberPad
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .default))
                alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    self.sendCompleteTaskRequest(task_id: toDotask.queue_id, expenses: Int((textField?.text)!), index: indexPath.row)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.sendCompleteTaskRequest(task_id: toDotask.queue_id, expenses: nil, index: indexPath.row)
            }
        }
    }
    
    private func sendCompleteTaskRequest(task_id: Int, expenses: Int?, index: Int){
        ToDoTasksRequest.completeTask(task_id: task_id, expenses: expenses)
        self.showToast(message: "Completed", font: .systemFont(ofSize: 18.0))
        tasks.remove(at: index)
        self.tableView.reloadData()
    }
    
}

extension ToDoTasksTableViewController {
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

