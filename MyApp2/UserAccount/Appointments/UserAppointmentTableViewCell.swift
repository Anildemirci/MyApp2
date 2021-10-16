//
//  UserAppointmentTableViewCell.swift
//  MyApp2
//
//  Created by Anıl Demirci on 25.08.2021.
//

import UIKit

class UserAppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var appointmentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        appointmentLabel.layer.borderWidth=1
        appointmentLabel.layer.borderColor=UIColor.black.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
