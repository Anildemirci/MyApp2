//
//  ViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var MyAppLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.setTitleColor(UIColor.white, for: .disabled)
        loginButton.backgroundColor = .blue
        loginButton.layer.cornerRadius=20
        signUpButton.setTitleColor(UIColor.white, for: .disabled)
        signUpButton.backgroundColor = .green
        signUpButton.layer.cornerRadius=20
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
    }
    

}

