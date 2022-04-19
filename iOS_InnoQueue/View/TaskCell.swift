//
//  TaskCell.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 19.04.2022.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func completeTaskTapped(sender: TaskCell)
}

class TaskCell: UITableViewCell {
    
    weak var delegate: TaskCellDelegate?
    
    @IBOutlet weak var isImportantDot: UIView!
    
    @IBOutlet weak var queueColor: UIView!
    
    @IBOutlet weak var queueName: UILabel!
    
    var queue_id: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func completeButtonAction(_ sender: UIButton) {
        delegate?.completeTaskTapped(sender: self)
    }
    
    
}
