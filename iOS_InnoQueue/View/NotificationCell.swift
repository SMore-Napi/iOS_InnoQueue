//
//  NotificationCell.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 20.04.2022.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
