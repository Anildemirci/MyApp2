//
//  AllAppointmentsViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 2.10.2021.
//

import UIKit
import Firebase


class AllAppointmentsViewController: UIViewController {
    
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var confirmedButton: UIButton!
    @IBOutlet weak var pendingButton: UIButton!
    
    var appointmentStatus=""
    var today=""
    var navTitle=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pastButton.layer.borderWidth=3
        pastButton.layer.borderColor=UIColor.black.cgColor
        confirmedButton.layer.borderWidth=3
        confirmedButton.layer.borderColor=UIColor.black.cgColor
        pendingButton.layer.borderWidth=3
        pendingButton.layer.borderColor=UIColor.black.cgColor
        // Do any additional setup after loading the view.
        navigationItem.title="Randevularım"
        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    @objc func backButton(){
        performSegue(withIdentifier: "toProfileFromAllAppointments", sender: nil)
    }
    
    @IBAction func pastAppointments(_ sender: Any) {
        appointmentStatus="Onaylandı."
        today="past"
        navTitle="Geçmiş Randevularım"
        performSegue(withIdentifier: "toAppointments", sender: nil)
    }
    @IBAction func approvedAppointments(_ sender: Any) {
        appointmentStatus="Onaylandı."
        today="next"
        navTitle="Onaylanmış Randevularım"
        performSegue(withIdentifier: "toAppointments", sender: nil)
    }
    @IBAction func pendingAppointments(_ sender: Any) {
        today=""
        appointmentStatus="Onay bekliyor."
        navTitle="Onay Bekleyen Randevularım"
        performSegue(withIdentifier: "toAppointments", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toAppointments" {
            let destinationVC=segue.destination as! UserAppointmentsViewController
            destinationVC.status=appointmentStatus
            destinationVC.today=today
            destinationVC.navTitle=navTitle
        }
    }
}
