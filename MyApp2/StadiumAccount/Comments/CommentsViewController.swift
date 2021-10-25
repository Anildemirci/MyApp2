//
//  CommentsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scoringLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userTypeArray=[String]()
    var stadiumTypeArray=[String]()
    
    
    var name=""
    var score=[String]()
    var comment=[String]()
    var date=[String]()
    var commentArray=[String]()
    var documentID=""
    var userName=[String]()
    var totalScore=Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
        navigationItem.title="Yorumlar"
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        firestoreDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        self.userTypeArray.append(userType)
                        if self.userTypeArray.contains(self.currentUser!.uid) {
                        }
                    }
                }
            }
        }
        
        firestoreDatabase.collection("Evaluation").document(name).collection(name).order(by: "CommentDate",descending: true).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                        for document in snapshot!.documents {
                            self.commentArray.append(document.documentID)
                            if let comments = document.get("Comment") as? String {
                                self.comment.append(comments)
                            }
                            if let username = document.get("FullName") as? String {
                                self.userName.append(username)
                            }
                            if let commentDate = document.get("CommentDate") as? String {
                                self.date.append(commentDate)
                            }
                            if let scorePoint = document.get("Score") as? String {
                                self.score.append(scorePoint)
                                if self.score.contains("5-Çok iyi") {
                                    self.totalScore=self.totalScore+5
                                } else if self.score.contains("4-İyi") {
                                    self.totalScore=self.totalScore+4
                                } else if self.score.contains("3-Orta") {
                                    self.totalScore=self.totalScore+3
                                } else if self.score.contains("2-Kötü") {
                                    self.totalScore=self.totalScore+2
                                } else if self.score.contains("1-Çok kötü") {
                                    self.totalScore=self.totalScore+1
                                }
                            }
                        }
                    if self.commentArray.count == 0 {
                        self.scoringLabel.text="Henüz oy verilmemiştir."
                    } else {
                        let averageScore=self.totalScore/Double(self.commentArray.count)
                        let numberFormatter=NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        guard let number=numberFormatter.string(from: NSNumber(value: averageScore)) else {
                            fatalError("Çevrilemedi.")
                        }
                        self.scoringLabel.text="\(String(self.commentArray.count)) müşteri oyu ile \(number)/5 puan."
                        self.tableView.reloadData()
                    }
                }
            }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentArray.count == 0 {
            return 1
        } else {
            return commentArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsCellViewCell
        if commentArray.count == 0 {
            cell.dateLabel.isHidden=true
            cell.userLabel.isHidden=true
            cell.score1View.isHidden=true
            cell.score2View.isHidden=true
            cell.score3View.isHidden=true
            cell.score4View.isHidden=true
            cell.score5View.isHidden=true
            cell.commentLabel.text="Saha hakkında henüz yorum yapılmamıştır."
            return cell
        } else {
            cell.commentLabel.text=comment[indexPath.row]
            cell.dateLabel.text=date[indexPath.row]
            cell.userLabel.text=userName[indexPath.row]
            if score[indexPath.row]=="5-Çok iyi" {
                cell.score5View.image=UIImage(named: "yellowStar")
                cell.score4View.image=UIImage(named: "yellowStar")
                cell.score3View.image=UIImage(named: "yellowStar")
                cell.score2View.image=UIImage(named: "yellowStar")
                cell.score1View.image=UIImage(named: "yellowStar")
            }
            else if score[indexPath.row]=="4-İyi" {
                cell.score4View.image=UIImage(named: "yellowStar")
                cell.score3View.image=UIImage(named: "yellowStar")
                cell.score2View.image=UIImage(named: "yellowStar")
                cell.score1View.image=UIImage(named: "yellowStar")
            }
            else if score[indexPath.row]=="3-Orta" {
                cell.score3View.image=UIImage(named: "yellowStar")
                cell.score2View.image=UIImage(named: "yellowStar")
                cell.score1View.image=UIImage(named: "yellowStar")
            }
            else if score[indexPath.row]=="2-Kötü" {
                cell.score2View.image=UIImage(named: "yellowStar")
                cell.score1View.image=UIImage(named: "yellowStar")
            }
            else if score [indexPath.row]=="1-Kötü" {
                cell.score1View.image=UIImage(named: "yellowStar")
            }
            return cell
        }
        
    }

    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
