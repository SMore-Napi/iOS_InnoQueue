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
        }
    }

}

extension QueueDetailsController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print("hehe")
       return (queue?.participants.count)!
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       print("hahah")
       let cell = tableView.dequeueReusableCell(withIdentifier:
          "ParticipantsIdentifier", for: indexPath) as! ParticipantsCell
       
       let user = queue?.participants[indexPath.row]
       
       cell.userName?.text = user?.user
       cell.userExpenses?.text = String("Spent: \((user?.expenses)!)")
       return cell
   }
}
