//
//  LoginViewController.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var stadiumLoginButton: UIButton!
    @IBOutlet weak var userLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stadiumLoginButton.setTitleColor(UIColor.white, for: .disabled)
        stadiumLoginButton.backgroundColor = .systemGreen
        stadiumLoginButton.layer.cornerRadius=20
        userLoginButton.setTitleColor(UIColor.white, for: .disabled)
        userLoginButton.backgroundColor = .systemGreen
        userLoginButton.layer.cornerRadius=20
        // Do any additional setup after loading the view.
        
        let gestureRecognizer=UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}
