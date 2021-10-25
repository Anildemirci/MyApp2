//
//  AppDelegate.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase
import CoreData
@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let currentUser=Auth.auth().currentUser
        let firebaseDatabase=Firestore.firestore()
        var userTypeArray=[String]()
        var stadiumTypeArray=[String]()
        
        if currentUser != nil {
            firebaseDatabase.collection("Users").addSnapshotListener { (snapshot, error) in
                if error == nil {
                    for document in snapshot!.documents{
                        if let userType=document.get("User") as? String{
                            userTypeArray.append(userType)
                            if userTypeArray.contains(currentUser!.uid) {
                                firebaseDatabase.collection("Users").whereField("User", isEqualTo: currentUser!.uid).addSnapshotListener { (snapshot, error) in
                                    if error == nil {
                                        for document in snapshot!.documents {
                                            if let userName=document.get("Name") as? String{
                                                if userName == "" {
                                                    let board=UIStoryboard(name: "Main", bundle: nil)
                                                    let userInfo=board.instantiateViewController(withIdentifier: "userInfo")
                                                    self.window?.rootViewController=userInfo
                                                } else {
                                                    let board=UIStoryboard(name: "Main", bundle: nil)
                                                    let userInfo=board.instantiateViewController(withIdentifier: "userProfile") as! UITabBarController
                                                    self.window?.rootViewController=userInfo
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            firebaseDatabase.collection("Stadiums").addSnapshotListener { (snapshot, error) in
                if error==nil {
                    for document in snapshot!.documents{
                        if let userType=document.get("User") as? String{
                            stadiumTypeArray.append(userType)
                            if stadiumTypeArray.contains(currentUser!.uid) {
                                
                                firebaseDatabase.collection("Stadiums").whereField("User", isEqualTo: currentUser!.uid).addSnapshotListener { (snapshot, error) in
                                    if error == nil {
                                        for document in snapshot!.documents {
                                            if let stadiumName=document.get("Name") as? String{
                                                if stadiumName == "" {
                                                    let board=UIStoryboard(name: "Main", bundle: nil)
                                                    let stadiumInfo=board.instantiateViewController(withIdentifier: "stadiumInfo")
                                                    self.window?.rootViewController=stadiumInfo
                                                } else {
                                                    let board=UIStoryboard(name: "Main", bundle: nil)
                                                    let stadiumInfo=board.instantiateViewController(withIdentifier: "stadiumProfile") as! UITabBarController
                                                    self.window?.rootViewController=stadiumInfo
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

