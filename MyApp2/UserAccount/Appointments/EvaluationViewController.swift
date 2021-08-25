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
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var documentID=""
    var points=["5-Çok iyi","4-İyi","3-Orta","2-Kötü","1-Çok kötü"]
    override func viewDidLoad() {
        super.viewDidLoad()
        scoringPicker.delegate=self
        scoringPicker.dataSource=self
        // Do any additional setup after loading the view.
        firestoreDatabase.collection("UserAppointments").document(currentUser!.uid).collection(currentUser!.uid).document(documentID).getDocument(source: .cache) { (snapshot, error) in
                    if let document = snapshot {
                        let fieldName=document.get("FieldName") as! String
                        self.fieldName.text=fieldName
                        let date=document.get("AppointmentDate") as! String
                        self.dateLabel.text=date
                        let hour=document.get("Hour") as! String
                        self.hourLabel.text=hour
                        let stadiumName=document.get("StadiumName") as! String
                        self.stadiumName.text=stadiumName
                        let status=document.get("Status") as! String
                        self.statusLabel.text=status
                        if self.statusLabel.text == "Onaylandı." {
                            self.scoringPicker.isHidden=false
                            self.commentText.isHidden=false
                            self.sendButton.isHidden=false
                            self.commentLabel.isHidden=false
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
        print(points[row])
    }
    @IBAction func sendClicked(_ sender: Any) {
    }
    
}
