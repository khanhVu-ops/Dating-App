//
//  FillNameSignUpViewModel.swift
//  Habiibi
//
//  Created by KhanhVu on 7/18/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FillNameSignUpViewModel {
    var txtFirstName = BehaviorRelay<String>(value: "")
    var txtLastName = BehaviorRelay<String>(value: "")
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var isValidFirstName: Observable<Bool> {
        return txtFirstName.map({ txt in
            return txt.count > 0
            
        })
    }
    var isValidLastName: Observable<Bool> {
        return txtLastName.map({ txt in
            return txt.count > 0
            
        })
    }
    
    var isBtnContinureEnable: Observable<Bool> {
        return Observable.combineLatest(isValidFirstName, isValidLastName) { (isFirstName, isLastName) in
            let isEnable = isFirstName && isLastName
            return isEnable
        }
    }
    
    func saveFullName() {
        GobalData.userRegister.firstName = txtFirstName.value
        GobalData.userRegister.lastName = txtLastName.value
    }
    
    func addUserLoginSuccessfully() {
        loadingBehavior.accept(true)
        print("GOBAL: \(GobalData.userRegister.phoneNumber)")
        DatabaseManager.shared.addUser(userActive: 1, phoneNumber: GobalData.userRegister.phoneNumber, gender: GobalData.userRegister.gender, firstName: GobalData.userRegister.firstName, lastName: GobalData.userRegister.lastName)
        loadingBehavior.accept(false)
    }
}
