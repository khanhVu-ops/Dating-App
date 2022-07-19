//
//  VerifyCodeviewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/11/22.
//

import Foundation
import UIKit

class VerifyCodeViewModel {
    var stvOTP: OTPStackView!
    
    func checkOTPSuccessfull() -> Bool {
        if stvOTP.getOTPString() == "111111" {
            return true
        }
        return false
    }
    
    func checkAccountRegisted() ->Bool {
        if DatabaseManager.shared.loginUser(phoneNumber: GobalData.userRegister.phoneNumber) {
            return true
        }
        return false
    }
    
}
