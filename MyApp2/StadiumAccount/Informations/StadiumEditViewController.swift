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
    }
    @IBAction func addClicked(_ sender: Any) {
    }
    
    func makeAlert(titleInput: String,messageInput: String){
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
