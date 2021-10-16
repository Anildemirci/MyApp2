//
//  WorkingHoursCell.swift
//  MyApp2
//
//  Created by Anıl Demirci on 8.07.2021.
//

import UIKit

class WorkingHoursCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var deleteView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
