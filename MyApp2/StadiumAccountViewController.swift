//
//  StadiumAccountViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 23.06.2021.
//

import UIKit
import MapKit
import CoreLocation

class StadiumAccountViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager=CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        locationManager.delegate=self
        // Do any additional setup after loading the view.
    }
    

}
