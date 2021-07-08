//
//  CommentsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit

class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scoringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsCellViewCell
        cell.commentLabel.text="güzel işletme fakat sahanın ve topların yenilenmesi gerekiyor. maçtan sonra oturmak için kafesi gayet ferah ve rahattı."
        cell.dateLabel.text="08.07.2021"
        cell.userLabel.text="anil demirci"
        return cell
        
        //randevu oluşturulduktan sonra puanlayıp yorum yapılabilir.
    }
}
