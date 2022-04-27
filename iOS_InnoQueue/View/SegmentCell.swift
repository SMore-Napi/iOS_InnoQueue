//
//  SegmentCell.swift
//  iOS_InnoQueue
//
//  Created by Роман Солдатов on 25.04.2022.
//

import UIKit

class SegmentCell: UITableViewCell {
    
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
