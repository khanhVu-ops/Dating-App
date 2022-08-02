//
//  OnboardingViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 6/28/22.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth
import RxSwift
import RxCocoa

class OnboardingViewModel {
    
    weak var vc:  OnboardingViewController?
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    init(vc: OnboardingViewController) {
        self.vc = vc
    }
    
    //
    //NOTE: nên bắn cả error ra ngoài completion
    func loginWithFb(completion: @escaping ((Bool)->Void)) {
        guard let vc = vc else {
            completion(false)
            return
        }
        let loginManager = LoginManager()
        
        if let _ = AccessToken.current {
            //Log out fb
            loginManager.logOut()
            
            print("Log out FB")
        } else {
            loadingBehavior.accept(true)
                loginManager.logIn(permissions:["public_profile","email"], from:vc){ (facebookData, error)in
                    if let facebookData = facebookData, error == nil {
                        if (AccessToken.current != nil) {
                            let token = AccessToken.current?.tokenString ?? ""
                        }
                      
                        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "" )
                        Auth.auth().signIn(with: credential) { result, error in
                            if let result = result, error == nil {
                                print(result)
                                print("Signed in")
                                guard let uid = Auth.auth().currentUser?.uid else{
                                    return
                                }
                                DatabaseManager.auth.checkAccountExists(uid: uid) {[weak self] (bool) in
                                    if bool {
                                        self?.loadingBehavior.accept(false)
                                        completion(true)
                                    }else {
                                        if facebookData.grantedPermissions.contains("email"){
                                                GraphRequest(graphPath:"me",parameters:["fields" : " id,name,first_name,                 last_name,picture.type(large),email"]).start(completion: {[weak self] (connection, result, error) in
                                                    if error != nil{
                                                        self?.loadingBehavior.accept(false)
                                                        completion(false)
                                                        vc.view.makeToast(error!.localizedDescription)
                                                    }else{
                                                        guard let data = result as? NSDictionary else {
                                                            return
                                                        }
                                                        DatabaseManager.auth.registerFacbook(userData: data) {[weak self] (bool) in
                                                            self?.loadingBehavior.accept(false)
                                                            if bool {
                                
                                                                completion(true)
                                                            }else{
                                                                completion(false)
                                                            }
                                                        }
                                                        
                                                    }
                                                })
                                            }
                                    }
                                }
                                //
                            }
                            else {
                                self.loadingBehavior.accept(false)
                                print("Some thing error: \(String(describing: error?.localizedDescription))")
                            }
                            
                        }
                        
                    }else {
                        self.loadingBehavior.accept(false)
                        print(error?.localizedDescription ?? "")
                    }
                    
                }

        }
        
    }
}
