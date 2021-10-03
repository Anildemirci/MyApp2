//
//  AllAppointmentsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 2.10.2021.
//

import UIKit
import Firebase

class AllAppointmentsViewController: UIViewController {
    
    var appointmentStatus=""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pastAppointments(_ sender: Any) {
        appointmentStatus="Onaylandı."
        performSegue(withIdentifier: "toAppointments", sender: nil)
    }
    @IBAction func approvedAppointments(_ sender: Any) {
        appointmentStatus="Onaylandı."
        performSegue(withIdentifier: "toAppointments", sender: nil)
    }
    @IBAction func pendingAppointments(_ sender: Any) {
        appointmentStatus="Onay bekliyor."
        performSegue(withIdentifier: "toAppointments", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toAppointments" {
            let destinationVC=segue.destination as! UserAppointmentsViewController
            destinationVC.status=appointmentStatus
            
        }
    }
}
