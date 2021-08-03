//
//  DateTableViewCell.swift
//  MyApp2
//
//  Created by Anıl Demirci on 3.08.2021.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
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
