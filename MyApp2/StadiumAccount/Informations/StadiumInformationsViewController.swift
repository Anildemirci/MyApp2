//
//  StadiumInformationsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 6.07.2021.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class StadiumInformationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var featuresTableView: UITableView!
    @IBOutlet weak var openingTime: UILabel!
    @IBOutlet weak var closingTime: UILabel!
    @IBOutlet weak var navigationButton: UIButton!
    
    
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var userTypeArray=[String]()
    var stadiumTypeArray=[String]()
    var equalName=""
    var infoArray = [String]()
    var annotationLatitude=Double()
    var annotationLongitude=Double()
    var user=""
    override func viewDidLoad() {
        super.viewDidLoad()
        featuresTableView.delegate=self
        featuresTableView.dataSource=self
        // Do any additional setup after loading the view.
        
        //user girişi ise
        firestoreDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    if let userType=document.get("User") as? String{
                        self.userTypeArray.append(userType)
                        if self.userTypeArray.contains(self.currentUser!.uid) {
                            self.user="1"
                            self.backButton.isHidden=true
                            self.editButton.isHidden=true
                            self.navigationButton.isHidden=false
                            //self.featuresTableView.isUserInteractionEnabled=false
                            self.firestoreDatabase.collection("Stadiums").whereField("Name", isEqualTo: self.equalName).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        let docRef=self.firestoreDatabase.collection("Stadiums").document(documentId)
                                        docRef.getDocument(source: .cache) { (document, error) in
                                            if let document = document {
                                                let address=document.get("Address") as! String
                                                self.addressLabel.text=address
                                                if let openHour=document.get("Opened") as? String {
                                                    self.openingTime.text="Açılış saati: \(openHour)"
                                                }
                                                if let closeHour=document.get("Closed") as? String {
                                                    self.closingTime.text="Kapanış saati: \(closeHour)"
                                                }

                                                if let info=document.get("Informations") as? [String] {
                                                    self.infoArray=info
                                                    self.featuresTableView.reloadData()
                                                }else {
                                                    self.infoArray=["Saha tarafından henüz bilgi girilmemiştir."]
                                                }
                                            }
                                    }
                                    }
                                }
                            }
                            
                            self.firestoreDatabase.collection("Locations").whereField("StadiumName", isEqualTo: self.equalName).getDocuments { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents{
                                        let documentId=document.documentID
                                        let docRef=self.firestoreDatabase.collection("Locations").document(documentId)
                                        docRef.getDocument(source: .cache) { (document, error) in
                                            if let document = document {
                                                if let longitude=document.get("Longitude") {
                                                    self.annotationLongitude=longitude as! Double
                                                } else  {
                                                    self.annotationLongitude=0
                                                }
                                                if let latitude=document.get("Latitude") {
                                                    self.annotationLatitude=latitude as! Double
                                                } else {
                                                    self.annotationLatitude=0
                                                }
                                            }
                                    }
                                    }
                                }
                            }
                        }else {//saha girişi ise
                            let docRef=self.firestoreDatabase.collection("Stadiums").document(self.currentUser!.uid)
                            docRef.getDocument(source: .cache) { (document, error) in
                                if let document = document {
                                    let address=document.get("Address") as? String
                                    self.addressLabel.text=address
                                    if let openHour=document.get("Opened") as? String {
                                        self.openingTime.text="Açılış saati: \(openHour)"
                                    }
                                    if let closeHour=document.get("Closed") as? String {
                                        self.closingTime.text="Kapanış saati: \(closeHour)"
                                    }
                                    if let info=document.get("Informations") as? [String] {
                                        self.infoArray=info
                                        self.featuresTableView.reloadData()
                                    }else {
                                        self.infoArray=["Saha tarafından henüz bilgi girilmemiştir."]
                                    }
                                }
                        }
                            
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let firestoreDatabase=Firestore.firestore()
            firestoreDatabase.collection("Stadiums").addSnapshotListener { [self] (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents
                    {
                        if let userType=document.get("User") as? String{
                            stadiumTypeArray.append(userType)
                        }
                    }
                    if stadiumTypeArray.contains(currentUser!.uid) {
                        if editingStyle == .delete {
                        let delField = infoArray[indexPath.row]
                        firestoreDatabase.collection("Stadiums").document(currentUser!.uid).updateData(["Informations" : FieldValue.arrayRemove([delField])])
                            self.makeAlert(titleInput: "Başarılı", messageInput: "Bilgi silindi.")
                        }
                    }
            }
            }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if userTypeArray.contains(self.currentUser!.uid) {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=featuresTableView.dequeueReusableCell(withIdentifier: "WorkingHoursCell", for: indexPath) as! WorkingHoursCell
        cell.dayLabel.text=infoArray[indexPath.row]
        if user == "1" {
            cell.deleteView.isHidden=true
        }
        return cell
    }
    
    @IBAction func backClicked(_ sender: Any) {
        
    }
    @IBAction func editClicked(_ sender: Any) {
        
    }
    
    @IBAction func navigationClicked(_ sender: Any) {

        if annotationLatitude != 0 && annotationLongitude != 0 {
            let requestLocation=CLLocation(latitude: annotationLatitude, longitude: annotationLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark=MKPlacemark(placemark: placemarks![0])
                        let item=MKMapItem(placemark: newPlacemark)
                        item.name=self.equalName
                        let launchOptions=[MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        } else {
            self.makeAlert(titleInput: "Hata", messageInput: "Sahanın konumu henüz kayıtlı değil.")
        }
        
        
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
