//
//  SubtaskCell.swift
//  VisualScheduleApp
//
//  Created by Aleksey Yakushev on 08.05.2023.
//

import UIKit

class SubtaskCell: UITableViewCell {

    @IBOutlet weak var dotView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLabel?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
