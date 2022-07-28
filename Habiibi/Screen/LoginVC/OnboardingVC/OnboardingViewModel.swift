//
//  OnboardingViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 6/28/22.
//

import Foundation
import FBSDKLoginKit

class OnboardingViewModel {
    
    weak var vc:  OnboardingViewController?
    
    init(vc: OnboardingViewController) {
        self.vc = vc
    }
    
//    func checkAccountActive() -> Bool{
//        if DatabaseManager.shared.checkUserActive() {
//            return true
//        }
//        
//        if let token = AccessToken.current,
//                 !token.isExpired {
//            return true
//        }
//        
//        return false
//    }
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
            
            //            loginManager.logOut()
            print("Log out FB")
        } else {
            // Login Fb
            loginManager.logIn(permissions: ["public_profile", "email"], from: vc) { result, error in
                // Check for error
                guard error == nil else {
                    // Error occurred
                    print(error!.localizedDescription)
                    completion(false)
                    return
                }
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    completion(false)
                    return
                }
                completion(true)
                
            }
            
        }
    }
}

