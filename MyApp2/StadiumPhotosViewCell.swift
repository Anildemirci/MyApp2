//
//  StadiumPhotosViewCell.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit

class StadiumPhotosViewCell: UITableViewCell {
    
    @IBOutlet weak var stadiumPhotosView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
