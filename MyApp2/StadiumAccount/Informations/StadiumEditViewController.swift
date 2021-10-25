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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var villageText: UITextField!
    @IBOutlet weak var streetText: UITextField!
    @IBOutlet weak var townText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var infoText: UITextField!
    @IBOutlet weak var openingTimeText: UITextField!
    @IBOutlet weak var closingTimeText: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    
    var locationManager=CLLocationManager()
    var chosenLatitude=Double()
    var chosenLongitude=Double()
    var firestoreDatabase=Firestore.firestore()
    var currentUser=Auth.auth().currentUser
    var nameStadium=""
    var town=""
    var city=""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //confirmButton.setTitleColor(UIColor.white, for: .disabled)
        //confirmButton.backgroundColor = .blue
        confirmButton.layer.cornerRadius=30
        //editButton.setTitleColor(UIColor.white, for: .disabled)
        //editButton.backgroundColor = .blue
        editButton.layer.cornerRadius=30
        //addButton.setTitleColor(UIColor.white, for: .disabled)
        //addButton.backgroundColor = .blue
        addButton.layer.cornerRadius=30
        villageText.layer.borderWidth=1
        villageText.layer.borderColor=UIColor.black.cgColor
        streetText.layer.borderWidth=1
        streetText.layer.borderColor=UIColor.black.cgColor
        townText.layer.borderWidth=1
        townText.layer.borderColor=UIColor.black.cgColor
        cityText.layer.borderWidth=1
        cityText.layer.borderColor=UIColor.black.cgColor
        infoText.layer.borderWidth=1
        infoText.layer.borderColor=UIColor.black.cgColor
        openingTimeText.layer.borderWidth=1
        openingTimeText.layer.borderColor=UIColor.black.cgColor
        closingTimeText.layer.borderWidth=1
        closingTimeText.layer.borderColor=UIColor.black.cgColor
        view1.layer.cornerRadius=30
        view2.layer.cornerRadius=30
        view3.layer.cornerRadius=30
        navigationItem.title="Düzenle"
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
        let docRef=firestoreDatabase.collection("Stadiums").document(currentUser!.uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let name=document.get("Name") as! String
                self.nameStadium=name
                let town=document.get("Town") as! String
                self.town=town
                let city=document.get("City") as! String
                self.city=city
            }
    }
        
        mapKit.delegate=self
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let hideKeyboard=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboard)
        
        let gestureRecognizer=UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2.5
        mapKit.addGestureRecognizer(gestureRecognizer)
    }
    
    
    var isExpand:Bool=false
    @objc func keyboardAppear(){
        if isExpand {
            self.scrollView.contentSize=CGSize(width: self.view.frame.width, height: self.scrollView.frame.height+300)
        }
    }
    
    @objc func keyboardDisappear(){
        if isExpand{
            self.scrollView.contentSize=CGSize(width: self.view.frame.height, height: self.scrollView.frame.height+300)
            isExpand=true
        }
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
            chosenLatitude=touchedCoordinates.latitude
            chosenLongitude=touchedCoordinates.longitude
            annotation.title=nameStadium
            self.mapKit.addAnnotation(annotation)
            
            let firestoreUser=["User":Auth.auth().currentUser!.uid,
                               "Email":Auth.auth().currentUser!.email,
                               "StadiumName":nameStadium,
                               "Town":town,
                               "City":city,
                               "Latitude":chosenLatitude,
                               "Longitude":chosenLongitude,
                               "AnnotationTitle":nameStadium,
                               "Date":FieldValue.serverTimestamp()] as [String:Any]
            
            firestoreDatabase.collection("Locations").document(currentUser!.uid).setData(firestoreUser) {
                    error in
                    if error != nil {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    } else {
                        self.makeAlert(titleInput: "Başarılı", messageInput: "Konumunuz eklendi.")
                    }
                }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span=MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region=MKCoordinateRegion(center: location, span: span)          //anlık konum alıyor.
        mapKit.setRegion(region, animated: true)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        if villageText.text != "" && streetText.text != "" && townText.text! != "" && cityText.text != "" {
            self.firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: self.currentUser!.uid).getDocuments { (snapshot, error) in
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
            self.firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: self.currentUser!.uid).getDocuments { (snapshot, error) in
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
    @IBAction func confirmClicked(_ sender: Any) {
        
        if openingTimeText.text != "" && closingTimeText.text != "" {
            self.firestoreDatabase.collection("Stadiums").whereField("User", isEqualTo: self.currentUser!.uid).getDocuments { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents{
                        let documentId=document.documentID
                        if document.get("Opened") != nil && document.get("Closed") != nil {
                            self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Opened":self.openingTimeText.text!])
                            self.firestoreDatabase.collection("Stadiums").document(documentId).updateData(["Closed":self.closingTimeText.text!])
                            }
                        else {
                            let addOpened=["Opened":self.openingTimeText.text!,
                                           "Closed":self.closingTimeText.text!] as [String:Any]
                            self.firestoreDatabase.collection("Stadiums").document(documentId).setData(addOpened, merge: true)
                            self.makeAlert(titleInput: "Success", messageInput: "Çalışma saatleri düzenlendi")
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
