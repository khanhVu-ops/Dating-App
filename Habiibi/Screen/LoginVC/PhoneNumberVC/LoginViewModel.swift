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
class LoginViewModel {
    
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
    
}
