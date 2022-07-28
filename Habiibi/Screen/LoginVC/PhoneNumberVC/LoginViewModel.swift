//
//  LoginViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
class LoginViewModel {
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    let txtPhoneNumber = BehaviorRelay<String>(value: "")

    var isValidPhoneNumber: Observable <Bool> {
        return self.txtPhoneNumber.map { (txtPhone) in
            if txtPhone.first == "0" {
                return txtPhone.count >= 10 && txtPhone.isValidPhoneNumber()
            }else {
                return txtPhone.count >= 9 && txtPhone.isValidPhoneNumber()
            }
        }
        
    }
    
    func getPhoneNumber() -> String {
        var txtPhone = txtPhoneNumber.value
        if txtPhone.first == "0" {
            txtPhone.removeFirst()
            
        }
        txtPhone = "+84" + txtPhone
        return txtPhone
    }
    
    func signInWithPhoneNumber(vc: BaseViewController) {
        loadingBehavior.accept(true)
        GobalData.phoneNumber = getPhoneNumber()
        Auth.auth().languageCode = "vi"
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(GobalData.phoneNumber, uiDelegate: nil) { verificationID, error in
            if error != nil {
                self.loadingBehavior.accept(false)
                
//                self.showMessagePrompt(error.localizedDescription)
                print("Error: \(String(describing: error?.localizedDescription))")
                return
              }else {
                print("Success")
                self.loadingBehavior.accept(false)
//                print(verificationID as Any)
                guard let verification = verificationID else {return}
                UserDefaults.standard.setValue(verification, forKey: "verificationID")
                let st = UIStoryboard(name: "Main", bundle: nil)
                let vcVerify = st.instantiateViewController(withIdentifier: "VerifyCodeViewController") as! VerifyCodeViewController
                vc.navigationController?.pushViewController(vcVerify, animated: true)
              }
              
          }
    }
    
}
