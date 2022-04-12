//
//  ParticipantsCell.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 12.04.2022.
//

import UIKit

class ParticipantsCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userExpenses: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
