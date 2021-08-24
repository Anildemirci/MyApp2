//
//  SignUpViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var stadiumSignUpButton: UIButton!
    @IBOutlet weak var userSignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stadiumSignUpButton.setTitleColor(UIColor.white, for: .disabled)
        stadiumSignUpButton.backgroundColor = .green
        stadiumSignUpButton.layer.cornerRadius=20
        userSignUpButton.setTitleColor(UIColor.white, for: .disabled)
        userSignUpButton.backgroundColor = .green
        userSignUpButton.layer.cornerRadius=20
        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonClicked(_ sender: Any) {
    }
    @IBAction func stadiumButtonClicked(_ sender: Any) {
    }
    @IBAction func userButtonClicked(_ sender: Any) {
    }
    

}
