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
        loginButton.setTitleColor(UIColor.white, for: .disabled)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius=20
        signUpButton.setTitleColor(UIColor.white, for: .disabled)
        signUpButton.backgroundColor = .systemGreen
        signUpButton.layer.cornerRadius=20
        
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        print("willappear")
      //  imageView.isHidden=false
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("willdisappear")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("didappear")
        imageView.isHidden=true
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("diddisappear")
    }
    */
    @IBAction func loginButtonClicked(_ sender: Any) {
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
    }
    

}

