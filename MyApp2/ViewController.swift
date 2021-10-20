//
//  ViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius=25
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        //signUpButton.backgroundColor = .systemGreen
        signUpButton.layer.cornerRadius=25
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
    }
    
    
}
