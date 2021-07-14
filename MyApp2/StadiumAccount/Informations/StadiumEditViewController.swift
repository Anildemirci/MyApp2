//
//  StadiumEditViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 8.07.2021.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import Firebase

class StadiumEditViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var villageText: UITextField!
    @IBOutlet weak var streetText: UITextField!
    @IBOutlet weak var townText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var infoText: UITextField!
    
    var locationManager=CLLocationManager()
    var chosenLatitude=Double()
    var chosenLongitude=Double()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKit.delegate=self
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let hideKeyboard=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboard)
        
        let gestureRecognizer=UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2.5
        mapKit.addGestureRecognizer(gestureRecognizer)
    }
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchedPoint=gestureRecognizer.location(in: self.mapKit)
            let touchedCoordinates=self.mapKit.convert(touchedPoint, toCoordinateFrom: self.mapKit)
            let annotation=MKPointAnnotation()
            annotation.coordinate=touchedCoordinates  // dokunduğun yeri işaretliyor.
            self.mapKit.addAnnotation(annotation)
           
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span=MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region=MKCoordinateRegion(center: location, span: span)          //anlık konum alıyor.
        mapKit.setRegion(region, animated: true)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        
        if villageText.text != "" && streetText.text != "" && townText.text! != "" && cityText.text != "" {
            self.firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: self.currentUser?.uid).getDocuments { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents{
                        let documentId=document.documentID
                        self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Address": (self.villageText.text!)+",\(self.streetText.text!)"+",\(self.townText.text!)"+"/\(self.cityText.text!)"])
                        self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Town":self.townText.text!])
                        self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["City":self.cityText.text!])
                        self.makeAlert(titleInput: "Başarılı", messageInput: "Adres bilgileriniz değiştirilmiştir.")
                    }
                }
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Lütfen tüm bilgileri giriniz.")
        }
        
    }
    
    @IBAction func addClicked(_ sender: Any) {
        
        if infoText.text != "" {
            self.firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: self.currentUser?.uid).getDocuments { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents{
                        let documentId=document.documentID
                        if var infoArray=document.get("Informations") as? [String] {
                            infoArray.append(self.infoText.text!)
                            let addInfo=["Informations":infoArray] as [String:Any]
                            self.firestoreDatabase.collection("Stadiums").document(documentId).setData(addInfo, merge: true) { (error) in
                                if error == nil {
                                    self.makeAlert(titleInput: "Success", messageInput: "Bilgi eklendi")
                                }
                            }
                        }else {
                            let addInfo=["Informations":[self.infoText.text!]] as [String:Any]
                            self.firestoreDatabase.collection("Stadiums").document(documentId).setData(addInfo, merge: true)
                            self.makeAlert(titleInput: "Success", messageInput: "Bilgi eklendi")
                        }
                    }
                }
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Lütfen boş bırakmayınız.")
        }
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
