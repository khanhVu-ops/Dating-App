//
//  VerifyCodeviewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class VerifyCodeViewModel {
    var stvOTP: OTPStackView!
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    func checkOTPSuccessfull() -> Bool {
        if stvOTP.getOTPString() == "111111" {
            return true
        }
        return false
    }
    
//    func checkAccountRegisted() ->Bool {
//        if DatabaseManager.shared.loginUser(phoneNumber: GobalData.userRegister.phoneNumber) {
//            return true
//        }
//        return false
//    }
    
    func verifyPhoneNumber(vc: BaseViewController) {
        loadingBehavior.accept(true)
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID") else{
            return
            
        }
        let veriCode = stvOTP.getOTPString()
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
            verificationCode: veriCode
        )
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let result = result, error == nil {
                print(result)
                print("Signed in")
                print("UID: \(Auth.auth().currentUser?.uid)")

                DatabaseManager.auth.checkAccountExists(uid: result.user.uid) { (bool) in
                    self.loadingBehavior.accept(false)
                    if bool {
                        
                        let st = UIStoryboard(name: "Main", bundle: nil)
                        let vcMain = st.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
                        vc.navigationController?.setViewControllers([vcMain], animated: true)
                    }else {
                        
                        let st = UIStoryboard(name: "Main", bundle: nil)
                        let vcGender = st.instantiateViewController(withIdentifier: "GenderSignUpViewController") as! GenderSignUpViewController
                        vc.navigationController?.pushViewController(vcGender, animated: true)
                    }
                }
                
//
            }else {
                self.loadingBehavior.accept(false)
                print("Some thing error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
}
