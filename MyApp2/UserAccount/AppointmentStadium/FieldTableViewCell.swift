//
//  FieldTableViewCell.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit

class FieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fieldNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
