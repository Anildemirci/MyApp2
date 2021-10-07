//
//  DateEditViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 8.08.2021.
//

import UIKit
import Firebase
import ImageSlideshow

class DateEditViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    

    @IBOutlet weak var openingTime: UIPickerView!
    @IBOutlet weak var closingTime: UIPickerView!
    @IBOutlet weak var setTimeButton: UIButton!
    @IBOutlet weak var setPriceButton: UIButton!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var downPaymentText: UITextField!
    @IBOutlet weak var fieldSizeText: UITextField!
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var chosenField=""
    var chosenStadium=""
    var hourArray=[String]()
    var closeTime=""
    var openTime=""
    var price=""
    var downPayment=""
    var fieldSize=""
    var selectedOpen = Int()
    var selectedClose = Int()
    var addHours=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openingTime.delegate=self
        openingTime.dataSource=self
        closingTime.delegate=self
        closingTime.dataSource=self
        
        
        // Do any additional setup after loading the view.
        hourArray=["","05:00-06:00","06:00-07:00","07:00-08:00","08:00-09:00","09:00-10:00","10:00-11:00","11:00-12:00","12:00-13:00","13:00-14:00","14:00-15:00","15:00-16:00","16:00-17:00","17:00-18:00","18:00-19:00","19:00-20:00","20:00-21:00","21:00-22:00","22:00-23:00","23:00-00:00","00:00-01:00","01:00-02:00","02:00-03:00","03:00-04:00","04:00-05:00"]
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hourArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOpen=openingTime.selectedRow(inComponent: 0)
        selectedClose=closingTime.selectedRow(inComponent: 0)
        closeTime=hourArray[selectedClose]
        openTime=hourArray[selectedOpen]
    }

    @IBAction func setTimeClicked(_ sender: Any) {
        if closeTime != "" && openTime != "" && closeTime != openTime && selectedClose > selectedOpen {
            addHours.removeAll()
            let newArray=hourArray[selectedOpen...selectedClose]
            for index in newArray {
                addHours.append(index)
            }
            let addInfo=["Informations":addHours] as [String:Any]
            firestoreDatabase.collection("FieldInfo").document(chosenStadium).collection(chosenStadium).document(chosenField).setData(addInfo, merge: true) { (error) in
                if error == nil {
                    self.makeAlert(titleInput: "Success", messageInput: "Bilgiler düzenlendi.")
                }
            }
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Geçerli açılış ve kapanış saatlerini seçin.")
        }
    }
    
    @IBAction func setPriceClicked(_ sender: Any) {
        
        if priceText.text != "" && downPaymentText.text != "" && fieldSizeText.text != "" {
            let firestoreInfo=[    "User":Auth.auth().currentUser!.uid,
                                   "Email":Auth.auth().currentUser!.email!,
                                   "StadiumName":chosenStadium,
                                   "FieldName":chosenField,
                                   "Price":priceText.text!,
                                   "DownPayment":downPaymentText.text!,
                                   "SizeOfField":fieldSizeText.text!,
                                   "Date":FieldValue.serverTimestamp()] as [String:Any]
            firestoreDatabase.collection("FieldInfo").document(chosenStadium).collection(chosenStadium).document(chosenField).setData(firestoreInfo, merge:true) {
                error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Bilgiler düzenlendi.")
                }
            }
        } else {
            self.makeAlert(titleInput: "Hata", messageInput: "Lütfen fiyat/kapora/büyüklük bilgilerini giriniz.")
        }
        
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
