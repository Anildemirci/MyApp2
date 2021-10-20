//
//  EvaluationViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 25.08.2021.
//

import UIKit
import Firebase

class EvaluationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var stadiumName: UILabel!
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scoringPicker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var documentID=""
    var chosenPoint=""
    var points=["","5-Çok iyi","4-İyi","3-Orta","2-Kötü","1-Çok kötü"]
    var fullName=""
    var currentTime=""
    var daysArray=[String]()
    var field=""
    var stadium=""
    var day=""
    var hour=""
    var status=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoringPicker.delegate=self
        scoringPicker.dataSource=self
        // Do any additional setup after loading the view.
        stadiumName.layer.borderWidth=1
        stadiumName.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        fieldName.layer.borderWidth=1
        fieldName.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        dateLabel.layer.borderWidth=1
        dateLabel.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        hourLabel.layer.borderWidth=1
        hourLabel.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        statusLabel.layer.borderWidth=1
        statusLabel.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        commentText.layer.borderWidth=1
        commentText.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        //cancelButton.layer.borderWidth=3
        //cancelButton.layer.borderColor=UIColor.black.cgColor
        cancelButton.backgroundColor=UIColor.systemRed
        cancelButton.layer.cornerRadius=25
        scoringPicker.layer.borderWidth=1
        scoringPicker.layer.borderColor=UIColor(named: "myGreen")?.cgColor
        sendButton.layer.cornerRadius=25
        view1.layer.cornerRadius=30
        view2.layer.cornerRadius=30
        let docref=firestoreDatabase.collection("Users").document(currentUser!.uid)
        docref.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                let surname=document.get("Surname") as! String
                self.fullName=name+" "+surname
            }
        }
        
        for day in 0...13 {
            let hourToAdd=3
            let daysToAdd=0 + day
            let UTCDate = getCurrentDate()
            var dateComponent = DateComponents()
            dateComponent.hour=hourToAdd
            dateComponent.day = daysToAdd
            let currentDate = Calendar.current.date(byAdding: dateComponent, to: UTCDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let date = dateFormatter.string(from: currentDate! as Date)
            daysArray.append(date)
        }
        
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(documentID).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        self.field=document.get("FieldName") as! String
                        self.fieldName.text=("Saha numarası: \(self.field)")
                        self.day=document.get("AppointmentDate") as! String
                        self.dateLabel.text=("Maç tarihi: \(self.day)")
                        self.hour=document.get("Hour") as! String
                        self.hourLabel.text=("Maç saati: \(self.hour)")
                        self.stadium=document.get("StadiumName") as! String
                        self.stadiumName.text=("Saha adı: \(self.stadium)")
                        self.status=document.get("Status") as! String
                        self.statusLabel.text=("Durum: \(self.status)")
                        if self.status == "Onaylandı." {
                            if self.daysArray.contains(self.day) {
                                //yorum yapamazsın.
                                //cancelButton.isHidden=true
                            } else {
                                self.scoringPicker.isHidden=false
                                self.commentText.isHidden=false
                                self.sendButton.isHidden=false
                                self.commentLabel.isHidden=false
                                self.cancelButton.isHidden=true
                                self.view2.isHidden=false
                                
                            }
                        }
                        self.getDataFromDatabase()
                    }
                }
        
        let date=Date()
        let formatter=DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        formatter.timeZone=TimeZone(abbreviation: "UTC+3")
        currentTime=formatter.string(from: date)
        
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }

@objc func hideKeyboard(){
    view.endEditing(true)
}
    func getCurrentDate()->Date {
        var now=Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now
        
    }
    
    func getDataFromDatabase(){
        firestoreDatabase.collection("Evaluation").document(stadium).collection(stadium).document(day+"-"+hour).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        let comment=document.get("Comment") as! String
                        if comment != "" {
                            self.commentText.isHidden=true
                            self.commentLabel.isHidden=true
                            self.cancelButton.isHidden=true
                            self.sendButton.isHidden=false
                            self.view2.isHidden=true
                        }
                        let score=document.get("Score") as! String
                        if score != "" {
                            self.scoringPicker.isHidden=true
                            self.sendButton.isHidden=false
                        }
                        if score != "" && comment != "" {
                            self.sendButton.isHidden=true
                        }
                    }
                }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return points.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return points[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenPoint=points[row]
    }
    @IBAction func sendClicked(_ sender: Any) {
        
        let firestoreUser=["User":Auth.auth().currentUser!.uid,
                           "Email":Auth.auth().currentUser?.email,
                           "StadiumName":stadium,
                           "FieldName":field,
                           "Date":day,
                           "Hour":hour,
                           "Status":status,
                           "Comment":commentText.text!,
                           "Score":chosenPoint,
                           "FullName":fullName,
                           "CommentDate":currentTime] as [String:Any]
        if chosenPoint != "" && commentText.text != "" {
            //sadece yorum ya da oylama yaptırırsan güncelleme yaptır database'e.
            firestoreDatabase.collection("Evaluation").document(stadium).collection(stadium).document(day+"-"+hour).setData(firestoreUser) {
                error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toUserProfileFromComment", sender: nil)
                }
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Lütfen yorum/puan boş bırakmayınız.")
        }
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        confirmAlert(titleInput: "Onaylama", messageInput: "İptal etmek istiyor musunuz?")
    }
    
    func confirmAlert(titleInput: String,messageInput: String) {
           let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        
        let yesButton=UIAlertAction(title: "Evet", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.firestoreDatabase.collection("StadiumAppointments").document(self.stadium).collection(self.stadium).document(self.documentID).updateData(["Status":"İptal edildi."])
            self.firestoreDatabase.collection("UserAppointments").document(self.currentUser!.uid).collection(self.currentUser!.uid).document(self.documentID).updateData(["Status":"İptal edildi."])
            self.firestoreDatabase.collection("Calendar").document(self.stadium).collection(self.field).document(self.day+"-"+self.hour).updateData(["Status":"İptal edildi."])
            self.makeAlert(titleInput: "Başarılı", messageInput: "Randevunuz iptal edildi.")
        })
        let noButton=UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil)
           
           alert.addAction(yesButton)
           alert.addAction(noButton)
           self.present(alert, animated: true, completion: nil)
       }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "toUserProfileFromComment", sender: nil)
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
