//
//  LoginViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit
class LoginViewModel {
//    var btnContinue: UIButton!
    var tfEnter: UITextField!
    
    func checkPhoneNumberIsValid() -> Bool{
        guard let text = tfEnter.text else { return false}
        
        if text.isValidPhoneNumber() {
            GobalData.userRegister.phoneNumber = text
            return true
        }
        return false
    }
    
   
}
