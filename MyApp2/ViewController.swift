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
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.setTitleColor(UIColor.white, for: .disabled)
        loginButton.backgroundColor = .blue
        loginButton.layer.cornerRadius=20
        signUpButton.setTitleColor(UIColor.white, for: .disabled)
        signUpButton.backgroundColor = .green
        signUpButton.layer.cornerRadius=20
        MyAppLabel.layer.cornerRadius=20
        imageView.isHidden=false
        print("didload")
    }
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
    
    @IBAction func loginButtonClicked(_ sender: Any) {
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
    }
    

}

