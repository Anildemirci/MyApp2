//
//  StadiumsTableViewCell.swift
//  MyApp2
//
//  Created by Anıl Demirci on 24.06.2021.
//

import UIKit

class StadiumsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stadiumNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
