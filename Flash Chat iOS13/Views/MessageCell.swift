//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by macbook on 07/03/2023.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

   @IBOutlet weak var messageBublle: UIView!
   @IBOutlet weak var label: UILabel!
   @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBublle.layer.cornerRadius = messageBublle.frame.size.height / 5
        label.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
