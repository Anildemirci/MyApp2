//
//  SceneDelegate.swift
//  MyApp2
//
//  Created by Anıl Demirci on 22.06.2021.
//

import UIKit
import Firebase
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
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
            
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    @available(iOS 13.0, *)
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    @available(iOS 13.0, *)
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    @available(iOS 13.0, *)
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    @available(iOS 13.0, *)
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    @available(iOS 13.0, *)
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

