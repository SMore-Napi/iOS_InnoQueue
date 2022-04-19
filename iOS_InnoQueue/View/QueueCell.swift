//
//  QueueCell.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 06.04.2022.
//

import UIKit

protocol QueueCellDelegate: AnyObject {
    func openQueueDetails(sender: QueueCell)
}

class QueueCell: UITableViewCell {
    
    weak var delegate: QueueCellDelegate?
    
    @IBOutlet weak var queueName: UILabel!
    @IBOutlet weak var queueColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
