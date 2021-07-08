//
//  CommentsCellViewCell.swift
//  MyApp2
//
//  Created by Anıl Demirci on 8.07.2021.
//

import UIKit

class CommentsCellViewCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var score1View: UIImageView!
    @IBOutlet weak var score2View: UIImageView!
    @IBOutlet weak var score3View: UIImageView!
    @IBOutlet weak var score4View: UIImageView!
    @IBOutlet weak var score5View: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
